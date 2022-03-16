import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:package_info/package_info.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:retog/app/models/user.dart';
import 'package:retog/config/app_config.dart';
import 'package:retog/data/app_data.dart';

class App {
  App._({
    @required this.config,
    @required this.data
  }) {
    _application = this;
  }

  static App _application;
  static App get application => _application;
  final String name = 'retog';
  final String title = 'Ретог';
  final AppConfig config;
  final AppData data;

  static Future<App> init() async {
    if (_application != null)
      return _application;

    String developmentUrl = Platform.isIOS ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
    bool isDebug = false;
    assert(isDebug = true); // Метод выполняется только в debug режиме

    WidgetsFlutterBinding.ensureInitialized();

    await FkUserAgent.init();

    AppConfig config = AppConfig(
      packageInfo: await PackageInfo.fromPlatform(),
      env: isDebug ? 'development' : 'production',
      databaseVersion: 12,
      apiBaseUrl: '${isDebug ? developmentUrl : 'https://data.unact.ru'}/api/'
    );
    AppData data = AppData(config);

    await data.setup();
    await _initSentry(dsn: const String.fromEnvironment('RETOG_SENTRY_DSN'), capture: !isDebug);

    return App._(
      config: config,
      data: data
    );
  }

  Future<void> reportError(dynamic error, dynamic stackTrace) async {
    print(error);
    print(stackTrace);
    await Sentry.captureException(error, stackTrace: stackTrace);
  }

  static Future<void> _initSentry({
    @required String dsn,
    @required bool capture
  }) async {
    if (!capture)
      return;

    await SentryFlutter.init(
      (options) {
        options.dsn = dsn;
        options.beforeSend = (SentryEvent event, {dynamic hint}) {
          User user = User.currentUser;

          return event.copyWith(user: SentryUser(
            id: user.id.toString(),
            username: user.username,
            email: user.email
          ));
        };
      }
    );
  }
}
