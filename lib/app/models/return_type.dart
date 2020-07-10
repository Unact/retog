import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class ReturnType extends DatabaseModel {
  static String _tableName = 'return_types';

  int id;
  String name;

  get tableName => _tableName;

  ReturnType({
    Map<String, dynamic> values,
    this.id,
    this.name
  }) {
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

  static Future<List<ReturnType>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => ReturnType(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, ReturnType(values: rec).toMap()));
  }

  static Future<void> deleteAll() async {
    return await App.application.data.db.delete(_tableName);
  }

  static Future<List<ReturnType>> byBuyer(int buyerId) async {
    return (await App.application.data.db.rawQuery("""
      select
        return_types.*
      from $_tableName return_types
      join partner_return_types on partner_return_types.return_type_id = return_types.id
      join buyers on buyers.partner_id = partner_return_types.partner_id
      where buyers.id = $buyerId
    """)).map((rec) => ReturnType(values: rec)).toList();
  }
}
