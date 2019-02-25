import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:retog/app/pages/person_page.dart';
import 'package:retog/app/models/buyer.dart';
import 'package:retog/app/models/partner.dart';
import 'package:retog/app/models/return_goods.dart';
import 'package:retog/app/modules/api.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final TextEditingController _partnerTextController = TextEditingController();
  final TextEditingController _buyerTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Partner _partner;
  Buyer _buyer;
  List<ReturnGoods> _returnGoodsList = [];

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Theme.of(context).bottomAppBarColor,
      child: Column(
        children: <Widget>[
          _buildPartnerSearch(context),
          _buildBuyerSearch(context)
        ],
      )
    );
  }

  Widget _buildPartnerSearch(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        cursorColor: theme.textSelectionColor,
        autocorrect: false,
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
          _partnerTextController.text = suggestion.name;
        });
      }
    );
  }

  Widget _buildBuyerSearch(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        cursorColor: theme.textSelectionColor,
        autocorrect: false,
        enabled: _partner != null,
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
        setState(() {
          _buyer = suggestion;
          _buyerTextController.text = suggestion.name;
        });
      }
    );
  }

  Widget _buildReturnGoodsTile(ReturnGoods returnGoods, BuildContext context) {
    return Container();
  }

  Widget _buildSliver(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int idx) {
          Widget result;
          if (idx + 1 > _returnGoodsList.length) {
            result = Center(
              child: RaisedButton(
                onPressed: _addReturnGoods,
                child: Text('Добавить позицию'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))
            ));
          } else {
            result = Padding(padding: EdgeInsets.all(8), child: _buildReturnGoodsTile(_returnGoodsList[idx], context));
          }

          return result;
        },
        childCount: _returnGoodsList.length + 1
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

  Future<void> _addReturnGoods() async {
    if (_buyer == null) {
      _showMessage('Не выбран покупатель');
      return;
    }

    ReturnGoods newReturnGoods = await ReturnGoods(buyerId: _buyer.id).insert();
    setState(() {
      _returnGoodsList.add(newReturnGoods);
    });
  }

  Future<void> _clearReturnGoods() async {
    await ReturnGoods.deleteAll();
    setState(() {
      _returnGoodsList = [];
    });
  }

  Future<void> _saveReturnGoods() async {
    if (_returnGoodsList.isEmpty) {
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
        'return_goods': _returnGoodsList.map((ReturnGoods returnGoods) => returnGoods.toExportMap())
      });
      Navigator.pop(context);
      _showMessage('Возвраты успешно созданы');
      _clearReturnGoods();
    } on ApiException catch(e) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(title: Text('Ошибка'), content: Text(e.errorMsg))
      );
    }
  }

  Future<void> _loadData() async {
    _returnGoodsList = await ReturnGoods.all();

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.save),
        onPressed: _saveReturnGoods,
      ),
      appBar: AppBar(
        title: Text('Возвраты'),
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => PersonPage(), fullscreenDialog: true)
              );
            }
          )
        ]
      ),
      body: _buildBody(context)
    );
  }
}
