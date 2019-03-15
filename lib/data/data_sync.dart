import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/buyer.dart';
import 'package:retog/app/models/buyer_goods.dart';
import 'package:retog/app/models/goods.dart';
import 'package:retog/app/models/goods_barcode.dart';
import 'package:retog/app/models/partner.dart';
import 'package:retog/app/models/return_goods.dart';
import 'package:retog/app/models/return_order.dart';
import 'package:retog/app/modules/api.dart';

class DataSync {
  DateTime get lastSyncTime {
    String time = App.application.data.prefs.getString('lastSyncTime') ?? '';
    return time != '' ? DateTime.parse(time) : null;
  }
  set lastSyncTime(val) => App.application.data.prefs.setString('lastSyncTime', val.toString());

  Future<void> importData() async {
    Map<String, dynamic> data = await Api.get('v2/retog');

    Batch batch = App.application.data.db.batch();
    await Buyer.import(data['buyers'], batch);
    await BuyerGoods.import(data['buyer_goods'], batch);
    await Goods.import(data['goods'], batch);
    await GoodsBarcode.import(data['goods_barcodes'], batch);
    await Partner.import(data['partners'], batch);
    await batch.commit();
    lastSyncTime = DateTime.now();
  }

  Future<void> clearData() async {
    await Buyer.deleteAll();
    await BuyerGoods.deleteAll();
    await Goods.deleteAll();
    await GoodsBarcode.deleteAll();
    await Partner.deleteAll();
    await ReturnGoods.deleteAll();
    await ReturnOrder.deleteAll();
    lastSyncTime = '';
  }
}
