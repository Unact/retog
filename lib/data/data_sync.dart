import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/buyer.dart';
import 'package:retog/app/models/goods.dart';
import 'package:retog/app/models/goods_barcode.dart';
import 'package:retog/app/models/partner_return_type.dart';
import 'package:retog/app/models/partner.dart';
import 'package:retog/app/models/return_goods.dart';
import 'package:retog/app/models/return_order.dart';
import 'package:retog/app/models/return_type.dart';
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
    await Partner.import(data['partners'], batch);
    await PartnerReturnType.import(data['partner_return_types'], batch);
    await ReturnType.import(data['return_types'], batch);
    await batch.commit();
    lastSyncTime = DateTime.now();
  }

  Future<void> loadGoodsData(int buyerId, int type) async {
    Map<String, dynamic> data = await Api.get('v2/retog/buyer_goods', queryParameters: {
      'buyer_id': buyerId,
      'type': type
    });

    Batch batch = App.application.data.db.batch();
    await Goods.import(data['goods'], batch);
    await GoodsBarcode.import(data['goods_barcodes'], batch);
    await batch.commit();
  }

  Future<void> clearData() async {
    await Buyer.deleteAll();
    await Partner.deleteAll();
    await ReturnGoods.deleteAll();
    await ReturnOrder.deleteAll();
    await ReturnType.deleteAll();
    lastSyncTime = '';
  }
}
