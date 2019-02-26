import 'dart:async';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/database_model.dart';
import 'package:retog/app/models/measure.dart';
import 'package:retog/app/utils/nullify.dart';

enum GoodsTypes {
  bad,
  good
}

class ReturnGoods extends DatabaseModel {
  static String _tableName = 'return_goods';

  int buyerId;
  int goodsId;
  int measureId;
  int volume;
  DateTime productionDate;
  int goodsType;

  static const int kDefaultVolume = 1;

  get tableName => _tableName;

  ReturnGoods({
    Map<String, dynamic> values,
    this.buyerId,
    this.goodsId,
    this.measureId = Measure.kPieceId,
    this.volume = kDefaultVolume,
    this.productionDate,
    this.goodsType
  }) {
    if (values != null) build(values);
  }

  @override
  void build(Map<String, dynamic> values) {
    super.build(values);

    buyerId = values['buyer_id'];
    goodsId = values['goods_id'];
    measureId = values['measure_id'];
    volume = values['volume'];
    productionDate = Nullify.parseDate(values['production_date']);
    goodsType = values['goods_type'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['buyer_id'] = buyerId;
    map['goods_id'] = goodsId;
    map['measure_id'] = measureId;
    map['volume'] = volume;
    map['production_date'] = productionDate?.toIso8601String();
    map['goods_type'] = goodsType;

    return map;
  }

  static Future<List<ReturnGoods>> all() async {
    return (await App.application.data.db.query(_tableName)).map((rec) => ReturnGoods(values: rec)).toList();
  }

  static Future<void> deleteAll() async {
    return await App.application.data.db.delete(_tableName);
  }
}
