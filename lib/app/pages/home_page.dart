import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/buyer.dart';
import 'package:retog/app/models/buyer_goods.dart';
import 'package:retog/app/models/goods.dart';
import 'package:retog/app/models/partner.dart';
import 'package:retog/app/models/return_goods.dart';
import 'package:retog/app/models/return_order.dart';
import 'package:retog/app/models/return_type.dart';
import 'package:retog/app/models/user.dart';
import 'package:retog/app/modules/api.dart';
import 'package:retog/app/pages/person_page.dart';
import 'package:retog/app/pages/return_goods_edit_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final double tileTextWidth = 92;
  final TextEditingController _partnerTextController = TextEditingController();
  final TextEditingController _buyerTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Partner _partner;
  Buyer _buyer;
  ReturnOrder _returnOrder = ReturnOrder();
  List<Goods> _allGoods = [];
  List<Goods> _allBuyerGoods = [];
  List<ReturnType> _returnTypes = [];

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Theme.of(context).bottomAppBarColor,
      child: Column(
        children: <Widget>[
          _buildTypeDropdown(context),
          _buildPickupCheckBox(context),
          _buildPartnerSearch(context),
          _buildBuyerSearch(context)
        ],
      )
    );
  }

  Widget _buildPartnerSearch(BuildContext context) {
    ThemeData theme = Theme.of(context);

    _partnerTextController.text = _partner?.name ?? '';

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        cursorColor: theme.textSelectionColor,
        autocorrect: false,
        enabled: _returnOrder.type != null && _returnOrder.returnGoods.isEmpty && _buyer == null,
        controller: _partnerTextController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          labelText: 'Партнер'
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
        _partner = null;

        return (await Partner.all()).where(
          (Partner partner) => partner.name.toLowerCase().contains(value.toLowerCase())
        ).toList();
      },
      itemBuilder: (BuildContext ctx, Partner suggestion) {
        return ListTile(
          isThreeLine: false,
          title: Text(suggestion.name, style: Theme.of(context).textTheme.caption)
        );
      },
      onSuggestionSelected: (Partner suggestion) async {
        setState(() {
          _partner = suggestion;
        });
      }
    );
  }

  Widget _buildBuyerSearch(BuildContext context) {
    ThemeData theme = Theme.of(context);

    _buyerTextController.text = _buyer?.name ?? '';

    return TypeAheadField(
      getImmediateSuggestions: true,
      textFieldConfiguration: TextFieldConfiguration(
        cursorColor: theme.textSelectionColor,
        autocorrect: false,
        enabled: _returnOrder.returnGoods.isEmpty && _partner != null,
        controller: _buyerTextController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          labelText: 'Покупатель'
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
        _buyer = null;

        return (await Buyer.all()).where(
          (Buyer buyer) => buyer.name.toLowerCase().contains(value.toLowerCase()) && buyer.partnerId == _partner.id
        ).toList();
      },
      itemBuilder: (BuildContext ctx, Buyer suggestion) {
        return ListTile(
          isThreeLine: false,
          title: Text(suggestion.name, style: Theme.of(context).textTheme.caption)
        );
      },
      onSuggestionSelected: (Buyer suggestion) async {
        _allBuyerGoods = await Goods.byBuyer(suggestion.id, _returnOrder.isBlack);

        _returnOrder.buyerId = suggestion.id;
        await _returnOrder.update();

        setState(() {
          _buyer = suggestion;
        });
      }
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
            value: !_returnOrder.needPickup,
            onChanged: (bool newValue) async {
              _returnOrder.needPickup = !newValue;
              await _returnOrder.update();
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
      value: _returnTypes.firstWhere((returnType) => _returnOrder.type == returnType.id, orElse: () => null),
      items: _returnTypes.map((ReturnType returnType) {
        return DropdownMenuItem<ReturnType>(
          value: returnType,
          child: Text(returnType.name)
        );
      }).toList(),
      onChanged: (ReturnType value) async {
        await _clear();
        _returnOrder.type = value.id;
        await _returnOrder.update();

        setState(() {});
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
                  onPressed: () async => _editReturnGoods(returnGoods, context)
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red,),
                  onPressed: () async => _removeReturnGoods(returnGoods)
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
            child: _buildReturnGoodsTile(context, _returnOrder.returnGoods[idx])
          );
        },
        childCount: _returnOrder.returnGoods.length
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
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) =>
            ReturnGoodsEditPage(
              returnOrder: _returnOrder,
              returnGoods: returnGoods,
              goodsDict: _allBuyerGoods
            )
        )
      );
    }
  }

  Future<ReturnGoods> _addReturnGoods() async {
    if (_buyer == null) {
      _showMessage('Не выбран покупатель');
      return null;
    }

    if (App.application.data.dataSync.lastSyncTime.difference(DateTime.now()).inDays > 0) {
      _showMessage('Необходимо обновить данные');
      return null;
    }

    ReturnGoods newReturnGoods = await ReturnGoods(returnOrderId: _returnOrder.localId).insert();
    setState(() {
      _returnOrder.returnGoods.add(newReturnGoods);
    });

    return newReturnGoods;
  }

  Future<void> _removeReturnGoods(ReturnGoods returnGoods) async {
    await returnGoods.delete();
    setState(() {
      _returnOrder.returnGoods.remove(returnGoods);
    });
  }

  Future<void> _createReturnOrder() async {
    _returnOrder = await ReturnOrder().insert();
    User.currentUser.cReturnOrder = _returnOrder.localId;
    await User.currentUser.save();
  }

  Future<void> _clear() async {
    await Future.wait(_returnOrder.returnGoods.map((ReturnGoods returnGoods) async {
      if (returnGoods.goodsId == null) return;

      BuyerGoods buyerGoods = await BuyerGoods.find(_returnOrder.buyerId, returnGoods.goodsId);
      if (_returnOrder.isBlack) {
        buyerGoods.leftBlackVolume += returnGoods.volume;
      } else {
        buyerGoods.leftVolume += returnGoods.volume;
      }

      await buyerGoods.update();
    }));
    await _createReturnOrder();
    setState(() {
      _buyer = null;
      _partner = null;
    });
  }

  Future<void> _saveReturnGoods() async {
    if (_returnOrder.returnGoods.isEmpty) {
      _showMessage('Нет позиций для возврата');
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Center(child: CircularProgressIndicator())
      );

      await Api.post('v2/retog/save', body: {
        'return_order': _returnOrder.toExportMap(),
        'return_goods': _returnOrder.returnGoods.map((ReturnGoods returnGoods) => returnGoods.toExportMap()).toList()
      });
      Navigator.pop(context);
      _showMessage('Возвраты успешно созданы');
      await _clear();
    } on ApiException catch(e) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(title: Text('Ошибка'), content: Text(e.errorMsg))
      );
    }
  }

  Future<void> _loadData() async {
    _returnTypes = await ReturnType.all();
    _allGoods = await Goods.all();

    if (User.currentUser.cReturnOrder != null) {
      _returnOrder = await ReturnOrder.find(User.currentUser.cReturnOrder);
      await _returnOrder.loadReturnGoods();

      if (_returnOrder.buyerId != null) {
        _buyer = await Buyer.find(_returnOrder.buyerId);
        _partner = await Partner.find(_buyer.partnerId);
        _allBuyerGoods = await Goods.byBuyer(_buyer.id, _returnOrder.isBlack);
      }
    } else {
      await _createReturnOrder();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _backgroundRefresh() async {
    DateTime now = DateTime.now();
    DateTime time = App.application.data.dataSync.lastSyncTime ?? now.subtract(Duration(days: 1));

    if (now.year != time.year || now.month != time.month || now.day != time.day) {
      await _importData();
    }

    await _loadData();
  }

  Future<void> _importData() async {
    String msg;

    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => Center(child: CircularProgressIndicator())
      );

      await App.application.data.dataSync.importData();
      msg = 'База данных успешно обновлена';
    } on ApiException catch(e) {
      msg = e.errorMsg;
    } catch(e) {
      msg = 'Произошла ошибка';
    } finally {
      Navigator.pop(context);
      _showMessage(msg);
    }
  }

  @override
  void initState() {
    super.initState();

    _loadData();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) => _backgroundRefresh());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      persistentFooterButtons: <Widget>[
        FlatButton(
          onPressed: () async => await _clear(),
          child: Text('Очистить'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))
        ),
        SizedBox(width: 24),
        FlatButton(
          onPressed: () async => _editReturnGoods(await _addReturnGoods(), context),
          child: Text('Добавить'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))
        ),
        FlatButton(
          onPressed: _saveReturnGoods,
          child: Text('Сохранить'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))
        ),
      ],
      appBar: AppBar(
        title: Text('Возвраты'),
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.person),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => PersonPage(), fullscreenDialog: true)
              );
              _loadData();
            }
          )
        ]
      ),
      body: _buildBody(context)
    );
  }
}
