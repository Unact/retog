import 'package:drift/drift.dart' show Value;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/renew_api.dart';

class AppRepository extends BaseRepository {
  AppRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

  Future<bool> get newVersionAvailable async {
    String currentVersion = (await PackageInfo.fromPlatform()).version;
    String remoteVersion = (await dataStore.usersDao.getUser()).version;

    return Version.parse(remoteVersion) > Version.parse(currentVersion);
  }

  Future<String> get fullVersion async {
    PackageInfo info = await PackageInfo.fromPlatform();

    return '${info.version}+${info.buildNumber}';
  }

  Future<Pref> getPref() {
    return dataStore.getPref();
  }

  Future<void> loadData() async {
    try {
      ApiData data = await api.getData();

      await dataStore.transaction(() async {
        final acts = data.acts.map((e) => e.toDatabaseEnt()).toList();
        final buyers = data.buyers.map((e) => e.toDatabaseEnt()).toList();
        final partners = data.partners.map((e) => e.toDatabaseEnt()).toList();
        final returnTypes = data.returnTypes.map((e) => e.toDatabaseEnt()).toList();
        final partnerReturnTypes = data.partnerReturnTypes.map((e) => e.toDatabaseEnt()).toList();

        await dataStore.returnsDao.loadActs(acts);
        await dataStore.returnsDao.loadBuyers(buyers);
        await dataStore.returnsDao.loadPartners(partners);
        await dataStore.returnsDao.loadReturnTypes(returnTypes);
        await dataStore.returnsDao.loadPartnerReturnTypes(partnerReturnTypes);
        await dataStore.returnsDao.clearReturnOrderLines();
        await dataStore.returnsDao.clearReturnOrders();
        await dataStore.updatePref(PrefsCompanion(lastSyncTime: Value(DateTime.now())));
      });
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> clearData() async {
    await dataStore.clearData();
  }
}
