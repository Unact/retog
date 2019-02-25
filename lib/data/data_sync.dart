import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/barcode.dart';
import 'package:retog/app/models/buyer.dart';
import 'package:retog/app/models/buyer_goods.dart';
import 'package:retog/app/models/goods.dart';
import 'package:retog/app/models/measure.dart';
import 'package:retog/app/models/partner.dart';
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
    await Barcode.import(data['barcodes'], batch);
    await Buyer.import(data['buyers'], batch);
    await BuyerGoods.import(data['buyer_goods'], batch);
    await Goods.import(data['goods'], batch);
    await Measure.import(data['measures'], batch);
    await Partner.import(data['partners'], batch);
    await User.import(data['user']);
    await batch.commit();
    lastSyncTime = DateTime.now();
  }
}
