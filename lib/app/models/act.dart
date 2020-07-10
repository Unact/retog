import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class Act extends DatabaseModel {
  static String _tableName = 'acts';

  int id;
  int number;
  String typeName;
  int goodsCnt;

  get tableName => _tableName;

  Act({Map<String, dynamic> values, this.id, this.number, this.typeName, this.goodsCnt}) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    id = values['id'];
    number = values['number'];
    typeName = values['type_name'];
    goodsCnt = values['goods_cnt'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = id;
    map['number'] = number;
    map['type_name'] = typeName;
    map['goods_cnt'] = goodsCnt;

    return map;
  }

  static Future<List<Act>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => Act(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, Act(values: rec).toMap()));
  }

  static Future<void> deleteAll() async {
    return await App.application.data.db.delete(_tableName);
  }
}
