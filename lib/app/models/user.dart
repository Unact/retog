import 'dart:async';

import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/modules/api.dart';

class User {
  int id = kGuestId;
  String username = kGuestUsername;
  String password;
  String email = '';
  String salesmanName;
  String token;
  String remoteVersion;
  int cReturnOrder;

  static const int kGuestId = 1;
  static const String kGuestUsername = 'guest';

  User.init() {
    _currentUser = this;
    id = App.application.data.prefs.getInt('id');
    username = App.application.data.prefs.getString('username');
    password = App.application.data.prefs.getString('password');
    salesmanName = App.application.data.prefs.getString('salesmanName');
    email = App.application.data.prefs.getString('email');
    token = App.application.data.prefs.getString('token');
    cReturnOrder = App.application.data.prefs.getInt('cReturnOrder');
    remoteVersion = App.application.data.prefs.getString('remoteVersion');
  }

  static User _currentUser;
  static User get currentUser => _currentUser;

  bool get newVersionAvailable {
    String currentVersion = App.application.config.packageInfo.version;

    return remoteVersion != null && Version.parse(remoteVersion) > Version.parse(currentVersion);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = id;
    map['username'] = username;
    map['password'] = password;
    map['salesman_name'] = salesmanName;
    map['email'] = email;
    map['token'] = token;
    map['remote_version'] = remoteVersion;

    return map;
  }

  bool isLogged() {
    return password != null;
  }

  Future<void> loadDataFromRemote() async {
    Map<String, dynamic> userData = await Api.get('v1/retog/user_info');

    id = userData['id'];
    email = userData['email'];
    salesmanName = userData['salesman_name'];
    remoteVersion = userData['app']['version'];
    await save();
  }

  Future<void> reset() async {
    id = kGuestId;
    username = kGuestUsername;
    password = null;
    email = '';
    salesmanName = null;
    token = null;
    remoteVersion = null;
    cReturnOrder = null;

    await save();
  }

  Future<void> save() async {
    SharedPreferences prefs = App.application.data.prefs;

    await (id != null ? prefs.setInt('id', id) : prefs.remove('id'));
    await (username != null ? prefs.setString('username', username) : prefs.remove('username'));
    await (password != null ? prefs.setString('password', password) : prefs.remove('password'));
    await (email != null ? prefs.setString('email', email) : prefs.remove('email'));
    await (salesmanName != null ? prefs.setString('salesmanName', salesmanName) : prefs.remove('salesmanName'));
    await (token != null ? prefs.setString('token', token) : prefs.remove('token'));
    await (remoteVersion != null ? prefs.setString('remoteVersion', remoteVersion) : prefs.remove('remoteVersion'));
    await (cReturnOrder != null ? prefs.setInt('cReturnOrder', cReturnOrder) : prefs.remove('cReturnOrder'));
  }
}
