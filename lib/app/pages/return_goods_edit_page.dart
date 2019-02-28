import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:retog/app/models/goods.dart';
import 'package:retog/app/models/goods_barcode.dart';
import 'package:retog/app/models/measure.dart';
import 'package:retog/app/models/return_goods.dart';
import 'package:retog/app/widgets/date_picker_widget.dart';

class ReturnGoodsEditPage extends StatefulWidget {
  final ReturnGoods returnGoods;
  final List<Goods> goodsDict;
  final List<Measure> measureDict;

  ReturnGoodsEditPage({
    @required this.returnGoods,
    @required this.goodsDict,
    @required this.measureDict,
    Key key
  }) : super(key: key);

  @override
  _ReturnGoodsEditPageState createState() => _ReturnGoodsEditPageState();
}

class _ReturnGoodsEditPageState extends State<ReturnGoodsEditPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _goodsTextController = TextEditingController();
  TextEditingController _volumeTextController = TextEditingController();

  Widget _buildGoodsSearch(BuildContext context) {
    ThemeData theme = Theme.of(context);

    _goodsTextController.text = widget.returnGoods.goodsId != null ?
      widget.goodsDict.firstWhere((Goods goods) => goods.id == widget.returnGoods.goodsId).name :
      '';

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        maxLines: 2,
        cursorColor: theme.textSelectionColor,
        autocorrect: false,
        controller: _goodsTextController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          labelText: 'Товар',
          suffixIcon: IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _scanBarcode
          )
        )
      ),
      errorBuilder: (BuildContext ctx, error) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: Text('Произошла ошибка', style: TextStyle(color: theme.errorColor)),
        );
      },
      noItemsFoundBuilder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Ничего не найдено',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.disabledColor, fontSize: 14.0),
          ),
        );
      },
      suggestionsCallback: (String value) async {
        return (await Goods.byBuyer(widget.returnGoods.buyerId)).where(
          (Goods goods) => goods.name.toLowerCase().contains(value.toLowerCase())
        ).toList();
      },
      itemBuilder: (BuildContext ctx, Goods suggestion) {
        return ListTile(
          isThreeLine: false,
          title: Text(suggestion.name, style: Theme.of(context).textTheme.caption)
        );
      },
      onSuggestionSelected: (Goods suggestion) async {
        widget.returnGoods.goodsId = suggestion.id;
        await widget.returnGoods.update();
      }
    );
  }

  Widget _buildTypeDropDown(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        labelText: 'Состояние'
      ),
      items: <bool>[false, true].map((bool value) {
        return DropdownMenuItem<bool>(
          value: value,
          child: Text(value ? 'Некондиция' : 'Кондиция'),
        );
      }).toList(),
      value: widget.returnGoods.isBad,
      onChanged: (bool value) async {
        widget.returnGoods.isBad = value;
        await widget.returnGoods.update();
        setState(() {});
      }
    );
  }

  Widget _buildProductionDate(BuildContext context) {
    return DatePickerWidget(
      selectedDate: widget.returnGoods.productionDate,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        labelText: 'Дата производства'
      ),
      selectDate: (DateTime value) async {
        widget.returnGoods.productionDate = value;
        await widget.returnGoods.update();
        setState(() {});
      }
    );
  }

  Widget _buildVolumeField(BuildContext context) {
    _volumeTextController.text = widget.returnGoods.volume?.toString() ?? '';

    return TextField(
      controller: _volumeTextController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        labelText: 'Кол-во'
      ),
      onChanged: (String value) async {
        widget.returnGoods.volume = int.tryParse(value);
        await widget.returnGoods.update();
        setState(() {});
      }
    );
  }

  Widget _buildMeasureDropDown(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        labelText: 'Ед. изм.'
      ),
      items: widget.measureDict.map((Measure value) {
        return DropdownMenuItem<int>(
          value: value.id,
          child: Text(value.name),
        );
      }).toList(),
      value: widget.returnGoods.measureId,
      onChanged: (int value) async {
        widget.returnGoods.measureId = value;
        await widget.returnGoods.update();
        setState(() {});
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8),
      children: <Widget>[
        _buildGoodsSearch(context),
        _buildTypeDropDown(context),
        _buildProductionDate(context),
        _buildVolumeField(context),
        _buildMeasureDropDown(context)
      ]
    );
  }

  void _scanBarcode() async {
    String errorMsg;

    try {
      List<GoodsBarcode> barcodes = await GoodsBarcode.byBarcode(await BarcodeScanner.scan());

      if (barcodes.isNotEmpty) {
        GoodsBarcode firstRec = barcodes.first;
        Goods goods = widget.goodsDict.firstWhere((Goods goods) => goods.id == firstRec.goodsId, orElse: () => null);

        if (goods == null) {
          errorMsg = 'Покупателю указанный товар не отгружался';
        } else {
          widget.returnGoods.goodsId = goods.id;
          widget.returnGoods.measureId = firstRec.measureId;
          await widget.returnGoods.update();
          setState(() {});
        }
      } else {
        errorMsg = 'Товар не найден';
      }
    } on PlatformException catch (e) {
      errorMsg = 'Произошла ошибка';

      if (e.code == BarcodeScanner.CameraAccessDenied) {
        errorMsg = 'Необходимо дать доступ к использованию камеры';
      }
    }

    if (errorMsg != null) {
      _showMessage(errorMsg);
    }
  }

  void _showMessage(String content) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(content)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Позиция')),
      body: _buildBody(context)
    );
  }
}
