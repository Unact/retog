import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class Buyer extends DatabaseModel {
  static String _tableName = 'buyers';

  int id;
  String name;
  int partnerId;

  get tableName => _tableName;

  Buyer({Map<String, dynamic> values, this.id, this.name, this.partnerId}) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    id = values['id'];
    name = values['name'];
    partnerId = values['partner_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['partner_id'] = partnerId;

    return map;
  }

  static Future<List<Buyer>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => Buyer(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, Buyer(values: rec).toMap()));
  }

  static Future<void> deleteAll() async {
    return await App.application.data.db.delete(_tableName);
  }

  static Future<Buyer> find(int buyerId) async {
    return (await App.application.data.db.rawQuery("""
      select
        buyers.*
      from $_tableName buyers
      where id = $buyerId
      order by buyers.name
    """)).map((rec) => Buyer(values: rec)).first;
  }

  static Future<List<Buyer>> byPartnerId(int partnerId) async {
    return (await App.application.data.db.rawQuery("""
      select
        buyers.*
      from $_tableName buyers
      where partner_id = $partnerId
      order by buyers.name
    """)).map((rec) => Buyer(values: rec)).toList();
  }
}
