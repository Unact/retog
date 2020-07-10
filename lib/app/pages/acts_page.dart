import 'package:flutter/material.dart';

import 'package:retog/app/models/act.dart';
import 'package:retog/app/models/return_order.dart';
import 'package:retog/app/models/return_type.dart';
import 'package:retog/app/models/user.dart';
import 'package:retog/app/pages/return_order_page.dart';

class ActsPage extends StatefulWidget {
  ActsPage({Key key}) : super(key: key);

  @override
  _ActsPageState createState() => _ActsPageState();
}

class _ActsPageState extends State<ActsPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Act> _acts = [];

  Future<void> _loadData() async {
    _acts = await Act.all();

    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: _acts.map((partner) => _buyerTile(context, partner)).toList()..insert(0, _editTile(context))
    );
  }

  Widget _buyerTile(BuildContext context, Act act) {
    return ListTile(
      title: Text('${act.typeName} № ${act.number}', style: TextStyle(fontSize: 14.0)),
      subtitle: Text('Позиций: ${act.goodsCnt}'),
    );
  }

  Widget _editTile(BuildContext context) {
    if (User.currentUser.cReturnOrder == null) {
      return Container();
    }

    return ListTile(
      title: Text('Черновик', style: TextStyle(fontSize: 16.0)),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: editDraft
      ),
      onTap: editDraft
    );
  }

  Future<void> editDraft() async {
    ReturnOrder returnOrder = await ReturnOrder.find(User.currentUser.cReturnOrder);
    await returnOrder.loadReturnGoods();

    List<ReturnType> returnTypes = await ReturnType.byBuyer(returnOrder.buyerId);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReturnOrderPage(returnOrder: returnOrder, returnTypes: returnTypes))
    );
    await _loadData();
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
      appBar: AppBar(
        title: Text('Акты')
      ),
      body: _buildBody(context)
    );
  }
}
