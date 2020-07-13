import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';
import 'package:retog/app/utils/format.dart';
import 'package:retog/app/utils/nullify.dart';

class Recept extends DatabaseModel {
  static String _tableName = 'recepts';

  int id;
  String ndoc;
  DateTime ddate;

  get tableName => _tableName;

  get name => ndoc + ' от ' + Format.dateStr(ddate);

  Recept({Map<String, dynamic> values, this.id, this.ndoc, this.ddate}) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    id = values['id'];
    ndoc = values['ndoc'];
    ddate = Nullify.parseDate(values['ddate']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = id;
    map['ndoc'] = ndoc;
    map['ddate'] = ddate?.toIso8601String();

    return map;
  }

  static Future<List<Recept>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => Recept(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, Recept(values: rec).toMap()));
  }

  static Future<void> deleteAll() async {
    return await App.application.data.db.delete(_tableName);
  }
}
