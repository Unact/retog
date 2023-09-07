import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';

part 'schema.dart';
part 'database.g.dart';
part 'returns_dao.dart';
part 'users_dao.dart';

@DriftDatabase(
  tables: [
    Users,
    Prefs,
    Acts,
    Recepts,
    Partners,
    Buyers,
    PartnerReturnTypes,
    ReturnTypes,
    ReturnOrders,
    ReturnOrderLines,
    AllGoods,
    GoodsBarcodes
  ],
  daos: [
    ReturnsDao,
    UsersDao
  ]
)
class AppDataStore extends _$AppDataStore {
  AppDataStore({
    required bool logStatements
  }) : super(_openConnection(logStatements));

  Future<Pref> getPref() async {
    return select(prefs).getSingle();
  }

  Future<int> updatePref(PrefsCompanion pref) {
    return update(prefs).write(pref);
  }

  Future<void> clearData() async {
    await transaction(() async {
      await _clearData();
      await _populateData();
    });
  }

  Future<void> _clearData() async {
    await batch((batch) {
      for (var table in allTables) {
        batch.deleteWhere(table, (row) => const Constant(true));
      }
    });
  }

  Future<void> _populateData() async {
    await batch((batch) {
      batch.insert(users, const User(
        id: UsersDao.kGuestId,
        username: UsersDao.kGuestUsername,
        email: '',
        salesmanName: '',
        version: '0.0.0'
      ));
      batch.insert(prefs, const Pref());
    });
  }

  Future<void> _loadData(TableInfo table, Iterable<Insertable> rows) async {
    await batch((batch) {
      batch.deleteWhere(table, (row) => const Constant(true));
      batch.insertAll(table, rows, mode: InsertMode.insertOrReplace);
    });
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
        await m.createTable(table);
      }
    },
    beforeOpen: (details) async {
      if (details.hadUpgrade || details.wasCreated) await _populateData();
    },
  );
}

LazyDatabase _openConnection(bool logStatements) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, '${Strings.appName}.sqlite'));

    return NativeDatabase(file, logStatements: logStatements);
  });
}

extension ReceptX on Recept {
  String get name => '$ndoc от ${Format.dateStr(ddate)}';
}
