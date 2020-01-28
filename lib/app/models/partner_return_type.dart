import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';

class PartnerReturnType extends DatabaseModel {
  static String _tableName = 'partner_return_types';

  int partnerId;
  int returnTypeId;

  get tableName => _tableName;

  PartnerReturnType({Map<String, dynamic> values, this.partnerId, this.returnTypeId}) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    partnerId = values['partner_id'];
    returnTypeId = values['return_type_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['partner_id'] = partnerId;
    map['return_type_id'] = returnTypeId;

    return map;
  }

  static Future<List<PartnerReturnType>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => PartnerReturnType(values: rec)).toList();
  }

  static Future<void> import(List<dynamic> recs, Batch batch) async {
    batch.delete(_tableName);
    recs.forEach((rec) => batch.insert(_tableName, PartnerReturnType(values: rec).toMap()));
  }

  static Future<void> deleteAll() async {
    return await App.application.data.db.delete(_tableName);
  }
}
