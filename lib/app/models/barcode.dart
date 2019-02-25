import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class Barcode extends DatabaseModel {
  static String _tableName = 'barcodes';

  int id;
  String barcode;
  int goodsId;
  int measureId;

  get tableName => _tableName;

  Barcode({Map<String, dynamic> values, this.id, this.barcode, this.goodsId, this.measureId}) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    id = values['id'];
    barcode = values['barcode'];
    goodsId = values['goods_id'];
    measureId = values['measure_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = id;
    map['barcode'] = barcode;
    map['goods_id'] = goodsId;
    map['measure_id'] = measureId;

    return map;
  }

  static Future<List<Barcode>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => Barcode(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, Barcode(values: rec).toMap()));
  }
}
