import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class GoodsBarcode extends DatabaseModel {
  static String _tableName = 'goods_barcodes';

  String barcode;
  int goodsId;
  int measureId;

  get tableName => _tableName;

  GoodsBarcode({Map<String, dynamic> values, this.barcode, this.goodsId, this.measureId}) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    barcode = values['barcode'];
    goodsId = values['goods_id'];
    measureId = values['measure_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['barcode'] = barcode;
    map['goods_id'] = goodsId;
    map['measure_id'] = measureId;

    return map;
  }

  static Future<List<GoodsBarcode>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => GoodsBarcode(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, GoodsBarcode(values: rec).toMap()));
  }

  static Future<List<GoodsBarcode>> byBarcode(String barcode) async {
    return (await App.application.data.db.rawQuery("""
      select
        goods_barcodes.*
      from $_tableName goods_barcodes
      where barcode = $barcode
      order by goods_barcodes.measure
    """)).map((rec) => GoodsBarcode(values: rec)).toList();
  }
}
