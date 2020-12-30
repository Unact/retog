import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'package:retog/app/app.dart';

class AppConfig {
  AppConfig({
    @required this.packageInfo,
    @required this.env,
    @required this.databaseVersion,
    @required this.apiBaseUrl
  });

  final PackageInfo packageInfo;
  final String env;
  final String secretKeyWord = '5005';
  final int databaseVersion;

  String apiBaseUrl;

  Future<void> save() async {
    await App.application.data.prefs.setString('apiBaseUrl', apiBaseUrl);
  }

  void loadSaved() {
    apiBaseUrl = App.application.data.prefs.getString('apiBaseUrl') ?? apiBaseUrl;
  }
}
