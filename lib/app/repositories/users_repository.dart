import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/renew_api.dart';

class UsersRepository extends BaseRepository {
  UsersRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

  bool get isLoggedIn => api.isLoggedIn;

  Future<User> getUser() {
    return dataStore.usersDao.getUser();
  }

  Future<void> loadUserData() async {
    try {
      ApiUserData userData = await api.getUserData();

      await dataStore.usersDao.loadUser(userData.toDatabaseEnt());
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> login(String url, String login, String password) async {
    try {
      await api.login(url: url, login: login, password: password);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }

    await loadUserData();
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await api.logout();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }

    await dataStore.clearData();
    notifyListeners();
  }

  Future<void> resetPassword(String url, String login) async {
    try {
      await api.resetPassword(url: url, login: login);
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }
}
