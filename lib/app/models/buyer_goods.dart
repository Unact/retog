import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class BuyerGoods extends DatabaseModel {
  static String _tableName = 'buyer_goods';

  int goodsId;
  int buyerId;

  get tableName => _tableName;

  BuyerGoods({Map<String, dynamic> values, this.goodsId, this.buyerId}) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    goodsId = values['goods_id'];
    buyerId = values['buyer_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['goods_id'] = goodsId;
    map['buyer_id'] = buyerId;

    return map;
  }

  static Future<List<BuyerGoods>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => BuyerGoods(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, BuyerGoods(values: rec).toMap()));
  }
}
