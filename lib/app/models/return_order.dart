import 'dart:async';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class ReturnOrder extends DatabaseModel {
  static String _tableName = 'return_orders';

  int buyerId;

  get tableName => _tableName;

  ReturnOrder({
    Map<String, dynamic> values,
    this.buyerId
  }) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    buyerId = values['buyer_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['buyer_id'] = buyerId;

    return map;
  }

  static Future<List<ReturnOrder>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => ReturnOrder(values: rec)).toList();
  }

  static Future<void> deleteAll() async {
    return await App.application.data.db.delete(_tableName);
  }

  static Future<ReturnOrder> find(int returnOrderId) async {
    return (await App.application.data.db.rawQuery("""
      select
        return_orders.*
      from $_tableName return_orders
      where local_id = $returnOrderId
      order by local_id
    """)).map((rec) => ReturnOrder(values: rec)).firstWhere((el) => el != null, orElse: () => null);
  }
}
