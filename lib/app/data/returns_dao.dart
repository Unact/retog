part of 'database.dart';

@DriftAccessor(
  tables: [
    Acts,
    Buyers,
    Partners,
    Recepts,
    ReturnOrders,
    ReturnOrderLines,
    ReturnTypes,
    PartnerReturnTypes,
    AllGoods,
    GoodsBarcodes
  ]
)
class ReturnsDao extends DatabaseAccessor<AppDataStore> with _$ReturnsDaoMixin {
  ReturnsDao(AppDataStore db) : super(db);

   Future<void> loadBuyers(List<Buyer> list) async {
    await db._loadData(buyers, list);
  }

  Future<void> loadActs(List<Act> list) async {
    await db._loadData(acts, list);
  }

  Future<void> loadPartners(List<Partner> list) async {
    await db._loadData(partners, list);
  }

  Future<void> loadReturnTypes(List<ReturnType> list) async {
    await db._loadData(returnTypes, list);
  }

  Future<void> loadPartnerReturnTypes(List<PartnerReturnType> list) async {
    await db._loadData(partnerReturnTypes, list);
  }

  Future<void> loadGoods(List<Goods> list) async {
    await db._loadData(allGoods, list);
  }
  Future<void> loadGoodsBarcodes(List<GoodsBarcode> list) async {
    await db._loadData(goodsBarcodes, list);
  }
  Future<void> loadRecepts(List<Recept> list) async {
    await db._loadData(recepts, list);
  }

  Future<List<Act>> getActs() async {
    return select(acts).get();
  }

  Future<List<ReturnOrder>> getReturnOrders() async {
    return select(returnOrders).get();
  }

  Future<List<Recept>> getRecepts() async {
    return (
      select(recepts)
        ..orderBy([(u) => OrderingTerm(expression: u.ndoc), (u) => OrderingTerm(expression: u.ddate)])
    ).get();
  }

  Future<List<ReturnType>> getReturnTypesByBuyer(int buyerId) async {
    final hasBuyer = existsQuery(
      select(partnerReturnTypes)
        .join([innerJoin(buyers, buyers.partnerId.equalsExp(partnerReturnTypes.partnerId))])
        ..where(buyers.id.equals(buyerId))
        ..where(partnerReturnTypes.returnTypeId.equalsExp(returnTypes.id))
    );

    return (select(returnTypes)..where((tbl) => hasBuyer)..orderBy([(u) => OrderingTerm(expression: u.name)])).get();
  }

  Future<List<Buyer>> getBuyers() async {
    return (select(buyers)..orderBy([(u) => OrderingTerm(expression: u.name)])).get();
  }

  Future<List<Partner>> getPartners() async {
    return (select(partners)..orderBy([(u) => OrderingTerm(expression: u.name)])).get();
  }

  Future<int> addReturnOrder(ReturnOrdersCompanion newReturnOrder) async {
    return await into(returnOrders).insert(newReturnOrder);
  }

  Future<void> updateReturnOrder(int id, ReturnOrdersCompanion updatedReturnOrder) async {
    await (update(returnOrders)..where((tbl) => tbl.id.equals(id))).write(updatedReturnOrder);
  }

  Future<void> clearReturnOrders() async {
    await delete(returnOrders).go();
  }

  Future<int> addReturnOrderLine(ReturnOrderLinesCompanion newReturnOrderLine) async {
    return await into(returnOrderLines).insert(newReturnOrderLine);
  }

  Future<void> updateReturnOrderLine(int id, ReturnOrderLinesCompanion updatedReturnOrderLine) async {
    await (update(returnOrderLines)..where((tbl) => tbl.id.equals(id))).write(updatedReturnOrderLine);
  }

  Future<void> deleteReturnOrderLine(int id) async {
    await (delete(returnOrderLines)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> clearReturnOrderLines() async {
    await delete(returnOrderLines).go();
  }

  Future<ReturnOrder?> getReturnOrder(int id) async {
    return (select(returnOrders)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<Goods>> getGoodsByBarcode(String barcode) async {
    final hasBarcode = existsQuery(
      select(goodsBarcodes)
        ..where((tbl) => tbl.goodsId.equalsExp(allGoods.id))
        ..where((tbl) => tbl.barcode.equals(barcode))
    );

    return (select(allGoods)..where((tbl) => hasBarcode)..orderBy([(u) => OrderingTerm(expression: u.name)])).get();
  }

  Future<List<Goods>> getGoods() async {
    return (select(allGoods)..orderBy([(u) => OrderingTerm(expression: u.name)])).get();
  }

  Future<ReturnOrderLineEx> getReturnOrderLineEx(int id) async {
    final returnOrderLinesQuery = select(returnOrderLines)
      .join([
        leftOuterJoin(allGoods, allGoods.id.equalsExp(returnOrderLines.goodsId)),
      ])
      ..where(returnOrderLines.id.equals(id));

    return returnOrderLinesQuery.map(
      (lineRow) => ReturnOrderLineEx(lineRow.readTable(returnOrderLines), lineRow.readTableOrNull(allGoods))
    ).getSingle();
  }

  Future<List<ReturnOrderLineEx>> getReturnOrderLineExList(int returnOrderId) async {
    final returnOrderLinesQuery = select(returnOrderLines)
      .join([
        leftOuterJoin(allGoods, allGoods.id.equalsExp(returnOrderLines.goodsId)),
      ])
      ..where(returnOrderLines.returnOrderId.equals(returnOrderId));

    return returnOrderLinesQuery.map(
      (lineRow) => ReturnOrderLineEx(lineRow.readTable(returnOrderLines), lineRow.readTableOrNull(allGoods))
    ).get();
  }

/*
  Future<void> loadOrders(List<Order> list) async {
    await batch((batch) {
      batch.deleteWhere(orders, (row) => const Constant(true));
      batch.insertAll(orders, list, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> loadOrderLines(List<OrderLine> list) async {
    await batch((batch) {
      batch.deleteWhere(orderLines, (row) => const Constant(true));
      batch.insertAll(orderLines, list, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> loadIncomes(List<Income> list) async {
    await batch((batch) {
      batch.deleteWhere(incomes, (row) => const Constant(true));
      batch.insertAll(incomes, list, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> loadRecepts(List<Recept> list) async {
    await batch((batch) {
      batch.deleteWhere(recepts, (row) => const Constant(true));
      batch.insertAll(recepts, list, mode: InsertMode.insertOrReplace);
    });
  }

  Future<List<Order>> getOrders() async {
    return select(orders).get();
  }

  Future<List<OrderLineWithCode>> getOrderLinesByOrderId(int orderId) async {
    final orderLineRows = await (select(orderLines)..where((tbl) => tbl.orderId.equals(orderId))).get();
    final orderLineCodeRows = await select(orderLineCodes).get();

    return orderLineRows.map(((e) {
      return OrderLineWithCode(
        e,
        orderLineCodeRows.where((element) => element.orderId == e.orderId && element.subid == e.subid).toList()
      );
    })).toList();
  }

  Future<List<Income>> getIncomes() async {
    return select(incomes).get();
  }

  Future<List<Recept>> getRecepts() async {
    return select(recepts).get();
  }

  Future<List<Buyer>> getBuyers() async {
    return (select(buyers)..orderBy([(u) => OrderingTerm(expression: u.name)])).get();
  }

  Future<List<Order>> getOrdersByBuyerId(int buyerId) async {
    return (
      select(orders)
        ..where((tbl) => tbl.buyerId.equals(buyerId))
        ..orderBy([(u) => OrderingTerm(expression: u.ndoc)])
    ).get();
  }

  Future<Order> getOrderById(int id) async {
    return (select(orders)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<int> upsertOrder(OrdersCompanion order) {
    return into(orders).insertOnConflictUpdate(order);
  }

  Future<int> upsertOrderLineCode(OrderLineCodesCompanion orderLineCode) {
    return into(orderLineCodes).insertOnConflictUpdate(orderLineCode);
  }

  Future<void> clearOrderLineCodesByOrderId(int orderId) async {
    await (delete(orderLineCodes)..where((tbl) => tbl.orderId.equals(orderId))).go();
  }

  Future<void> clearOrderLineCodesByOrderLineSubid(int orderId, int subid) async {
    await (
      delete(orderLineCodes)
        ..where((tbl) => tbl.orderId.equals(orderId))
        ..where((tbl) => tbl.subid.equals(subid))
    ).go();
  } */
}
/*
class OrderLineWithCode {
  final OrderLine orderLine;
  final List<OrderLineCode> orderLineCodes;

  OrderLineWithCode(this.orderLine, this.orderLineCodes);
}
 */

class ReturnOrderLineEx {
  final ReturnOrderLine line;
  final Goods? goods;

  ReturnOrderLineEx(this.line, this.goods);
}
