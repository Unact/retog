import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class Measure extends DatabaseModel {
  static String _tableName = 'measures';

  int id;
  String name;

  get tableName => _tableName;

  Measure({Map<String, dynamic> values, this.id, this.name}) {
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

  static Future<List<Measure>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => Measure(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, Measure(values: rec).toMap()));
  }
}
