import 'package:flutter/material.dart';

import 'package:retog/app/models/buyer.dart';
import 'package:retog/app/models/return_order.dart';
import 'package:retog/app/models/return_type.dart';
import 'package:retog/app/models/user.dart';
import 'package:retog/app/pages/return_order_page.dart';

class BuyersPage extends StatefulWidget {
  final List<Buyer> buyers;

  BuyersPage({
    this.buyers,
    Key key
  }) : super(key: key);

  @override
  _BuyersPageState createState() => _BuyersPageState();
}

class _BuyersPageState extends State<BuyersPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildBody(BuildContext context) {
    return ListView(children: widget.buyers.map((partner) => _buyerTile(context, partner)).toList());
  }

  Widget _buyerTile(BuildContext context, Buyer buyer) {
    return ListTile(
      title: Text(buyer.name, style: TextStyle(fontSize: 14.0)),
      onTap: () async {
        List<ReturnType> returnTypes = await ReturnType.byBuyer(buyer.id);
        ReturnOrder returnOrder = await ReturnOrder(buyerId: buyer.id).insert();

        User.currentUser.cReturnOrder = returnOrder.localId;
        await User.currentUser.save();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReturnOrderPage(returnOrder: returnOrder, returnTypes: returnTypes))
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Покупатели')
      ),
      body: _buildBody(context)
    );
  }
}
