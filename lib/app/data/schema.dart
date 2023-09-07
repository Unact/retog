part of 'database.dart';

class Prefs extends Table {
  DateTimeColumn get lastSyncTime => dateTime().nullable()();
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text()();
  TextColumn get salesmanName => text()();
  TextColumn get email => text()();
  TextColumn get version => text()();
}

class Recepts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ndoc => text()();
  DateTimeColumn get ddate => dateTime()();
}

class Buyers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get partnerId => integer()();
}

class Partners extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class PartnerReturnTypes extends Table {
  IntColumn get partnerId => integer()();
  IntColumn get returnTypeId => integer()();

  @override
  Set<Column> get primaryKey => {partnerId, returnTypeId};
}

class GoodsBarcodes extends Table {
  IntColumn get goodsId => integer()();
  TextColumn get barcode => text()();

  @override
  Set<Column> get primaryKey => {goodsId, barcode};
}

@DataClassName('Goods')
class AllGoods extends Table {
  @override
  String get tableName => 'goods';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get leftVolume => integer()();
}

class Acts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get number => integer()();
  TextColumn get typeName => text()();
  IntColumn get goodsCnt => integer()();
}

class ReturnTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class ReturnOrders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get buyerId => integer()();
  BoolColumn get needPickup => boolean()();
  IntColumn get returnTypeId => integer().nullable()();
  IntColumn get receptId => integer().nullable()();
}

class ReturnOrderLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get returnOrderId => integer()();
  IntColumn get goodsId => integer().nullable()();
  IntColumn get volume => integer().nullable()();
  DateTimeColumn get productionDate => dateTime().nullable()();
  BoolColumn get isBad => boolean().nullable()();
}
