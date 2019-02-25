import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:retog/app/app.dart';

class User {
  int id = kGuestId;
  String username = kGuestUsername;
  String password;
  String email = '';
  String agentName;
  String token;

  static const int kGuestId = 1;
  static const String kGuestUsername = 'guest';

  User.init() {
    _currentUser = this;
    id = App.application.data.prefs.getInt('id');
    username = App.application.data.prefs.getString('username');
    password = App.application.data.prefs.getString('password');
    agentName = App.application.data.prefs.getString('agentName');
    email = App.application.data.prefs.getString('email');
    token = App.application.data.prefs.getString('token');
  }

  User._();

  static User _currentUser;
  static User get currentUser => _currentUser;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = id;
    map['username'] = username;
    map['password'] = password;
    map['agent_name'] = agentName;
    map['email'] = email;
    map['token'] = token;

    return map;
  }

  bool isLogged() {
    return password != null;
  }

  static Future<void> import(Map<String, dynamic> userData) async {
    User user = User.currentUser;

    user.id = userData['id'];
    user.email = userData['email'];
    user.agentName = userData['agent_name'];
    await user.save();
  }

  Future<void> reset() async {
    id = kGuestId;
    username = kGuestUsername;
    password = null;
    email = '';
    agentName = null;
    token = null;

    await save();
  }

  Future<void> save() async {
    SharedPreferences prefs = App.application.data.prefs;

    await (id != null ? prefs.setInt('id', id) : prefs.remove('id'));
    await (username != null ? prefs.setString('username', username) : prefs.remove('username'));
    await (password != null ? prefs.setString('password', password) : prefs.remove('password'));
    await (email != null ? prefs.setString('email', email) : prefs.remove('email'));
    await (agentName != null ? prefs.setString('agentName', agentName) : prefs.remove('agentName'));
    await (token != null ? prefs.setString('token', token) : prefs.remove('token'));
  }
}
