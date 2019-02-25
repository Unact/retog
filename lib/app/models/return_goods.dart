import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class ReturnGoods extends DatabaseModel {
  static String _tableName = 'return_goods';

  int id;
  String name;
  int buyerId;
  int goodsId;
  int measureId;
  double volume;
  DateTime productionDate;
  int goodsType;

  get tableName => _tableName;

  ReturnGoods({
    Map<String, dynamic> values,
    this.id,
    this.name,
    this.buyerId,
    this.goodsId,
    this.measureId,
    this.volume,
    this.productionDate,
    this.goodsType
  }) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    id = values['id'];
    name = values['name'];
    buyerId = values['buyer_id'];
    goodsId = values['goods_id'];
    measureId = values['measure_id'];
    volume = values['volume'];
    productionDate = values['production_date'];
    goodsType = values['goods_type'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['buyer_id'] = buyerId;
    map['goods_id'] = goodsId;
    map['measure_id'] = measureId;
    map['volume'] = volume;
    map['production_date'] = productionDate;
    map['goods_type'] = goodsType;

    return map;
  }

  static Future<List<ReturnGoods>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => ReturnGoods(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, ReturnGoods(values: rec).toMap()));
  }

  static Future<List<Map<String, dynamic>>> export() async {
    return (await ReturnGoods.all()).map((req) => req.toExportMap()).toList();
  }
}
