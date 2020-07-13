import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/goods_barcode.dart';
import 'package:retog/app/models/goods.dart';
import 'package:retog/app/models/recept.dart';
import 'package:retog/app/models/return_goods.dart';
import 'package:retog/app/models/return_order.dart';
import 'package:retog/app/models/return_type.dart';
import 'package:retog/app/models/user.dart';
import 'package:retog/app/modules/api.dart';
import 'package:retog/app/pages/return_goods_edit_page.dart';

class ReturnOrderPage extends StatefulWidget {
  final ReturnOrder returnOrder;
  final List<ReturnType> returnTypes;

  ReturnOrderPage({
    this.returnOrder,
    this.returnTypes,
    Key key
  }) : super(key: key);

  @override
  _ReturnOrderPageState createState() => _ReturnOrderPageState();
}

class _ReturnOrderPageState extends State<ReturnOrderPage> {
  final double tileTextWidth = 92;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Goods> _allGoods = [];
  List<Recept> _recepts = [];
  bool _editable = true;

  ReturnOrder get returnOrder => widget.returnOrder;

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Theme.of(context).bottomAppBarColor,
      child: Column(
        children: <Widget>[
          _buildPickupCheckBox(context),
          _buildTypeDropdown(context),
          _buildReceptDropdown(context),
        ],
      )
    );
  }

  Widget _buildPickupCheckBox(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(left: 8),
      child: Row(
        children: <Widget>[
          Expanded(child: Text('Самовывоз', style: TextStyle(color: theme.disabledColor, fontSize: 16.0))),
          Checkbox(
            value: !returnOrder.needPickup,
            onChanged: (bool newValue) async {
              returnOrder.needPickup = !newValue;
              await returnOrder.update();
              setState(() {});
            },
          ),
        ]
      )
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return DropdownButtonFormField<ReturnType>(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        labelText: 'Тип'
      ),
      value: widget.returnTypes.firstWhere((returnType) => returnOrder.type == returnType.id, orElse: () => null),
      items: widget.returnTypes.map((ReturnType returnType) {
        return DropdownMenuItem<ReturnType>(
          value: returnType,
          child: Text(returnType.name)
        );
      }).toList(),
      onChanged: (ReturnType value) async {
        String msg;

        await Future.forEach(returnOrder.returnGoods, (element) async => await _removeReturnGoods(element));
        returnOrder.receptId = null;
        returnOrder.type = value.id;
        await returnOrder.update();

        setState(() => returnOrder.returnGoods.clear());

        try {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => Center(child: CircularProgressIndicator())
          );

          await App.application.data.dataSync.loadBuyerData(widget.returnOrder.buyerId, value.id);
          _allGoods = await Goods.all();
          _recepts = await Recept.all();

          msg = 'Загружены товары покупателя';
        } on ApiException catch(e) {
          returnOrder.type = null;
          msg = e.errorMsg;
        } catch(e) {
          msg = 'Произошла ошибка';
        } finally {
          await returnOrder.update();
          setState((){
            Navigator.pop(context);
            _showMessage(msg);
          });
        }
      }
    );
  }

  Widget _buildReceptDropdown(BuildContext context) {
    return DropdownButtonFormField<Recept>(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        labelText: 'Накладная'
      ),
      value: _recepts.firstWhere((recept) => returnOrder.receptId == recept.id, orElse: () => null),
      items: _recepts.map((Recept recept) {
        return DropdownMenuItem<Recept>(
          value: recept,
          child: Text(recept.name)
        );
      }).toList(),
      onChanged: (Recept value) async {
        String msg;

        await Future.forEach(returnOrder.returnGoods, (element) async => await _removeReturnGoods(element));
        setState(() => returnOrder.returnGoods.clear());

        try {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => Center(child: CircularProgressIndicator())
          );

          await App.application.data.dataSync.loadReceptData(
            widget.returnOrder.buyerId,
            widget.returnOrder.type,
            value.id
          );
          _allGoods = await Goods.all();

          msg = 'Загружены товары накладной';
          returnOrder.receptId = value.id;
        } on ApiException catch(e) {
          msg = e.errorMsg;
        } catch(e) {
          msg = 'Произошла ошибка';
        } finally {
          await returnOrder.update();
          setState((){
            Navigator.pop(context);
            _showMessage(msg);
          });
        }
      }
    );
  }

  Widget _buildReturnGoodsTile(BuildContext context, ReturnGoods returnGoods) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: tileTextWidth, child: Text('Товар', style: TextStyle(color: Colors.grey))),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Text(_allGoods.isNotEmpty && returnGoods.goodsId != null ?
                        _allGoods.firstWhere((Goods goods) => returnGoods.goodsId == goods.id).name :
                        ''
                      )
                    ]
                  )
                )
              ]
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                SizedBox(width: tileTextWidth, child: Text('Состояние', style: TextStyle(color: Colors.grey))),
                Text(returnGoods.isBad != null ? (returnGoods.isBad ? 'Некондиция' : 'Кондиция') : '')
              ]
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                SizedBox(width: tileTextWidth, child: Text('Дата', style: TextStyle(color: Colors.grey))),
                Text(returnGoods.productionDate != null ?
                  DateFormat.yMMMd('ru').format(returnGoods.productionDate) :
                  ''
                )
              ]
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                SizedBox(width: tileTextWidth, child: Text('Кол-во', style: TextStyle(color: Colors.grey))),
                Text(returnGoods.volume?.toString() ?? ''),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async => await _editReturnGoods(returnGoods, context)
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red,),
                  onPressed: () async {
                    await _removeReturnGoods(returnGoods);

                    setState(() => returnOrder.returnGoods.remove(returnGoods));
                  }
                )
              ],
            )
          ],
        ),
      )
    );
  }

  Widget _buildSliver(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int idx) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: _buildReturnGoodsTile(context, returnOrder.returnGoods[idx])
          );
        },
        childCount: returnOrder.returnGoods.length
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverStickyHeader(
          header: _buildHeader(context),
          sliver: _buildSliver(context)
        )
      ]
    );
  }

  void _showMessage(String content) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(content)));
  }

  Future<void> _editReturnGoods(ReturnGoods returnGoods, BuildContext context) async {
    if (returnGoods != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) => ReturnGoodsEditPage(returnGoods: returnGoods, allGoods: _allGoods)
        )
      );
      setState((){});
    }
  }

  Future<ReturnGoods> _addReturnGoods() async {
    if (returnOrder.type == null) {
      _showMessage('Не выбран тип');
      return null;
    }

    if (App.application.data.dataSync.lastSyncTime.difference(DateTime.now()).inDays > 0) {
      _showMessage('Необходимо обновить данные');
      return null;
    }

    ReturnGoods newReturnGoods = await ReturnGoods(returnOrderId: returnOrder.localId).insert();
    setState(() {
      returnOrder.returnGoods.add(newReturnGoods);
    });

    return newReturnGoods;
  }

  Future<void> _removeReturnGoods(ReturnGoods returnGoods) async {
    if (returnGoods.goodsId != null) {
      Goods goods = _allGoods.firstWhere((Goods goods) => goods.id == returnGoods.goodsId);
      goods.leftVolume += returnGoods.volume;

      await goods.update();
    }

    await returnGoods.delete();
  }

  Future<void> _clear() async {
    await Goods.deleteAll();
    await GoodsBarcode.deleteAll();

    setState(() {});
  }

  Future<void> _saveReturnGoods() async {
    if (returnOrder.returnGoods.isEmpty) {
      _showMessage('Нет позиций для возврата');
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Center(child: CircularProgressIndicator())
      );

      await Api.post('v1/retog/save', data: {
        'return_order': returnOrder.toExportMap(),
        'return_goods': returnOrder.returnGoods.map((ReturnGoods returnGoods) => returnGoods.toExportMap()).toList()
      });
      await App.application.data.dataSync.importData();
      Navigator.pop(context);

      User.currentUser.cReturnOrder = null;
      await User.currentUser.save();

      setState(() {
        _editable = false;
      });
      _showMessage('Возвраты успешно созданы');
    } on ApiException catch(e) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(title: Text('Ошибка'), content: Text(e.errorMsg))
      );
    }
  }

  Future<void> _loadData() async {
    _allGoods = await Goods.all();
    _recepts = await Recept.all();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      persistentFooterButtons: <Widget>[
        FlatButton(
          onPressed: !_editable ? null : () async => await _clear(),
          child: Text('Очистить'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))
        ),
        SizedBox(width: 24),
        FlatButton(
          onPressed: !_editable ? null : () async => await _editReturnGoods(await _addReturnGoods(), context),
          child: Text('Добавить'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))
        ),
        FlatButton(
          onPressed: !_editable ? null : _saveReturnGoods,
          child: Text('Сохранить'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))
        ),
      ],
      appBar: AppBar(
        title: Text('Акт возврата')
      ),
      body: _buildBody(context)
    );
  }
}
