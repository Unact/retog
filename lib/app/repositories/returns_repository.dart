import 'package:drift/drift.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/renew_api.dart';

class ReturnsRepository extends BaseRepository {
  ReturnsRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

  Future<List<Act>> getActs() async {
    return dataStore.returnsDao.getActs();
  }

  Future<List<Buyer>> getBuyers() async {
    return dataStore.returnsDao.getBuyers();
  }

  Future<List<Partner>> getPartners() async {
    return dataStore.returnsDao.getPartners();
  }

  Future<List<ReturnOrder>> getReturnOrders() async {
    return dataStore.returnsDao.getReturnOrders();
  }

  Future<ReturnOrder?> getReturnOrder(int id) async {
    return dataStore.returnsDao.getReturnOrder(id);
  }

  Future<List<ReturnOrderLineEx>> getReturnOrderLineExList(int returnOrderId) async {
    return dataStore.returnsDao.getReturnOrderLineExList(returnOrderId);
  }

  Future<ReturnOrder> addReturnOrder({
    required Buyer buyer,
  }) async {
    final companion = ReturnOrdersCompanion.insert(
      buyerId: buyer.id,
      needPickup: false
    );

    await dataStore.returnsDao.clearReturnOrderLines();
    await dataStore.returnsDao.clearReturnOrders();
    await dataStore.returnsDao.loadGoods([]);
    await dataStore.returnsDao.loadGoodsBarcodes([]);
    await dataStore.returnsDao.loadRecepts([]);

    final id = await dataStore.returnsDao.addReturnOrder(companion);
    final returnOrder = await dataStore.returnsDao.getReturnOrder(id);

    notifyListeners();

    return returnOrder!;
  }

  Future<void> updateReturnOrder(ReturnOrder returnOrder, {
    Optional<bool>? needPickup,
    Optional<int?>? returnTypeId,
    Optional<int?>? receptId,
  }) async {
    final companion = ReturnOrdersCompanion(
      needPickup: needPickup == null ? const Value.absent() : Value(needPickup.value),
      returnTypeId: returnTypeId == null ? const Value.absent() : Value(returnTypeId.orNull),
      receptId: receptId == null ? const Value.absent() : Value(receptId.orNull),
    );

    await dataStore.returnsDao.updateReturnOrder(returnOrder.id, companion);
    notifyListeners();
  }

  Future<ReturnOrderLineEx> addReturnOrderLine(ReturnOrder returnOrder) async {
    final companion = ReturnOrderLinesCompanion.insert(
      returnOrderId: returnOrder.id
    );
    final id = await dataStore.returnsDao.addReturnOrderLine(companion);
    final returnOrderLineEx = dataStore.returnsDao.getReturnOrderLineEx(id);

    notifyListeners();

    return returnOrderLineEx;
  }

  Future<void> updateReturnOrderLine(ReturnOrderLine returnOrderLine, {
    Optional<bool>? isBad,
    Optional<int?>? goodsId,
    Optional<int?>? volume,
    Optional<DateTime?>? productionDate,
  }) async {
    final companion = ReturnOrderLinesCompanion(
      isBad: isBad == null ? const Value.absent() : Value(isBad.value),
      goodsId: goodsId == null ? const Value.absent() : Value(goodsId.orNull),
      volume: volume == null ? const Value.absent() : Value(volume.orNull),
      productionDate: productionDate == null ? const Value.absent() : Value(productionDate.orNull),
    );

    await dataStore.returnsDao.updateReturnOrderLine(returnOrderLine.id, companion);
    notifyListeners();
  }

  Future<void> deleteReturnOrderLine(ReturnOrderLine line) async {
    await dataStore.returnsDao.deleteReturnOrderLine(line.id);
    notifyListeners();
  }

  Future<List<Goods>> getGoodsByBarcode(String barcode) async {
    return dataStore.returnsDao.getGoodsByBarcode(barcode);
  }

  Future<List<Goods>> getGoods() async {
    return dataStore.returnsDao.getGoods();
  }

  Future<List<Recept>> getRecepts() async {
    return dataStore.returnsDao.getRecepts();
  }

  Future<List<ReturnType>> getReturnTypesByBuyer(int buyerId) async {
    return dataStore.returnsDao.getReturnTypesByBuyer(buyerId);
  }

  Future<ReturnOrderLineEx> getReturnOrderLineEx(int id) async {
    return dataStore.returnsDao.getReturnOrderLineEx(id);
  }

  Future<void> clearBuyerData() async {
    await dataStore.transaction(() async {
      await dataStore.returnsDao.loadGoods([]);
      await dataStore.returnsDao.loadGoodsBarcodes([]);
      await dataStore.returnsDao.loadRecepts([]);
    });
    notifyListeners();
  }

  Future<void> loadBuyerData(int buyerId, int returnTypeId) async {
    try {
      ApiBuyerData data = await api.getBuyerGoods(buyerId, returnTypeId);

      await dataStore.transaction(() async {
        final goods = data.goods.map((e) => e.toDatabaseEnt()).toList();
        final goodsBarcodes = data.goodsBarcodes.map((e) => e.toDatabaseEnt()).toList();
        final recepts = data.recepts.map((e) => e.toDatabaseEnt()).toList();

        await dataStore.returnsDao.loadGoods(goods);
        await dataStore.returnsDao.loadGoodsBarcodes(goodsBarcodes);
        await dataStore.returnsDao.loadRecepts(recepts);
      });
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> loadReceptData(int buyerId, int returnTypeId, int receptId) async {
    try {
      ApiReceptData data = await api.getReceptGoods(buyerId, returnTypeId, receptId);

      await dataStore.transaction(() async {
        final goods = data.goods.map((e) => e.toDatabaseEnt()).toList();
        final goodsBarcodes = data.goodsBarcodes.map((e) => e.toDatabaseEnt()).toList();

        await dataStore.returnsDao.loadGoods(goods);
        await dataStore.returnsDao.loadGoodsBarcodes(goodsBarcodes);
      });
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> saveReturnOrder(ReturnOrder returnOrder, List<ReturnOrderLineEx> exLines) async {
    try {
      Map<String, dynamic> data = {
        'return_order': {
          'buyer_id': returnOrder.buyerId,
          'need_pickup': returnOrder.needPickup,
          'type': returnOrder.returnTypeId,
          'recept_id': returnOrder.receptId,
        },
        'return_goods': exLines.map((i) => {
          'goods_id': i.line.goodsId,
          'production_date': i.line.productionDate?.toIso8601String(),
          'volume': i.line.volume,
          'is_bad': i.line.isBad,
        }).toList()
      };

      await api.save(data);

      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }
}
