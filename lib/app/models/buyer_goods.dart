import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class BuyerGoods extends DatabaseModel {
  static String _tableName = 'buyer_goods';

  int goodsId;
  int buyerId;
  int leftVolume;
  int leftBlackVolume;

  get tableName => _tableName;

  BuyerGoods({Map<String, dynamic> values, this.goodsId, this.buyerId}) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    goodsId = values['goods_id'];
    buyerId = values['buyer_id'];
    leftVolume = values['left_volume'];
    leftBlackVolume = values['left_black_volume'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['goods_id'] = goodsId;
    map['buyer_id'] = buyerId;
    map['left_volume'] = leftVolume;
    map['left_black_volume'] = leftBlackVolume;

    return map;
  }

  static Future<List<BuyerGoods>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => BuyerGoods(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, BuyerGoods(values: rec).toMap()));
  }

  static Future<void> deleteAll() async {
    return await App.application.data.db.delete(_tableName);
  }

  static Future<BuyerGoods> find(int buyerId, int goodsId) async {
    return (await App.application.data.db.rawQuery("""
      select
        buyer_goods.*
      from $_tableName buyer_goods
      where buyer_goods.buyer_id = $buyerId and buyer_goods.goods_id = $goodsId
    """)).map((rec) => BuyerGoods(values: rec)).first;
  }
}
