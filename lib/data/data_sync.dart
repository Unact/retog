import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/buyer.dart';
import 'package:retog/app/models/buyer_goods.dart';
import 'package:retog/app/models/goods.dart';
import 'package:retog/app/models/goods_barcode.dart';
import 'package:retog/app/models/measure.dart';
import 'package:retog/app/models/partner.dart';
import 'package:retog/app/models/return_goods.dart';
import 'package:retog/app/models/user.dart';
import 'package:retog/app/modules/api.dart';

class DataSync {
  DateTime get lastSyncTime {
    String time = App.application.data.prefs.getString('lastSyncTime');
    return time != null ? DateTime.parse(time) : null;
  }
  set lastSyncTime(val) => App.application.data.prefs.setString('lastSyncTime', val.toString());

  Future<void> importData() async {
    Map<String, dynamic> data = await Api.get('v2/retog');

    Batch batch = App.application.data.db.batch();
    await Buyer.import(data['buyers'], batch);
    await BuyerGoods.import(data['buyer_goods'], batch);
    await Goods.import(data['goods'], batch);
    await GoodsBarcode.import(data['goods_barcodes'], batch);
    await Measure.import(data['measures'], batch);
    await Partner.import(data['partners'], batch);
    await User.import(data['user']);
    await batch.commit();
    lastSyncTime = DateTime.now();
  }

  Future<void> clearData() async {
    await Buyer.deleteAll();
    await BuyerGoods.deleteAll();
    await Goods.deleteAll();
    await GoodsBarcode.deleteAll();
    await Measure.deleteAll();
    await Partner.deleteAll();
    await ReturnGoods.deleteAll();
    await User.currentUser.reset();
    lastSyncTime = null;
  }
}
