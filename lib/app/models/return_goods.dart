import 'dart:async';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';
import 'package:retog/app/utils/nullify.dart';

class ReturnGoods extends DatabaseModel {
  static String _tableName = 'return_goods';

  int returnOrderId;
  int goodsId;
  int volume;
  int blackVolume;
  DateTime productionDate;
  bool isBad;

  get tableName => _tableName;

  ReturnGoods({
    Map<String, dynamic> values,
    this.returnOrderId,
    this.goodsId,
    this.volume,
    this.blackVolume,
    this.productionDate,
    this.isBad
  }) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    returnOrderId = values['return_order_id'];
    goodsId = values['goods_id'];
    volume = values['volume'];
    blackVolume = values['black_volume'];
    productionDate = Nullify.parseDate(values['production_date']);
    isBad = Nullify.parseBool(values['is_bad']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['return_order_id'] = returnOrderId;
    map['goods_id'] = goodsId;
    map['volume'] = volume;
    map['black_volume'] = blackVolume;
    map['production_date'] = productionDate?.toIso8601String();
    map['is_bad'] = isBad;

    return map;
  }

  static Future<List<ReturnGoods>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => ReturnGoods(values: rec)).toList();
  }

  static Future<void> deleteAll() async {
    return await App.application.data.db.delete(_tableName);
  }

  static Future<List<ReturnGoods>> byReturnOrder(int returnOrderId) async {
    return (await App.application.data.db.rawQuery("""
      select
        return_goods.*
      from $_tableName return_goods
      where return_order_id = $returnOrderId
      order by local_ts
    """)).map((rec) => ReturnGoods(values: rec)).toList();
  }
}
