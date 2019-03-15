import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class Goods extends DatabaseModel {
  static String _tableName = 'goods';

  int id;
  String name;

  get tableName => _tableName;

  Goods({Map<String, dynamic> values, this.id, this.name}) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    id = values['id'];
    name = values['name'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;

    return map;
  }

  static Future<List<Goods>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => Goods(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, Goods(values: rec).toMap()));
  }

  static Future<void> deleteAll() async {
    return await App.application.data.db.delete(_tableName);
  }

  static Future<List<Goods>> byBuyer(int buyerId) async {
    return (await App.application.data.db.rawQuery("""
      select
        goods.*
      from $_tableName goods
      join buyer_goods on buyer_goods.goods_id = goods.id
      where buyer_goods.buyer_id = $buyerId
      order by goods.name
    """)).map((rec) => Goods(values: rec)).toList();
  }

  static Future<Goods> find(int goodsId) async {
    return (await App.application.data.db.rawQuery("""
      select
        goods.*
      from $_tableName goods
      where id = $goodsId
      order by goods.name
    """)).map((rec) => Goods(values: rec)).first;
  }
}
