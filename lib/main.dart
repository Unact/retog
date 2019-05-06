import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

import 'package:retog/app/app.dart';
import 'package:retog/config/app_config.dart';
import 'package:retog/config/app_env.dart' show appEnv;

void main() async {
  AndroidDeviceInfo androidDeviceInfo;
  IosDeviceInfo iosDeviceInfo;
  String developmentUrl;
  String osVersion;
  String deviceModel;
  bool isPhysicalDevice;
  bool development = false;
  assert(development = true); // Метод выполняется только в debug режиме

  if (Platform.isIOS) {
    developmentUrl = 'http://localhost:3000';
    iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
    isPhysicalDevice = iosDeviceInfo.isPhysicalDevice;
    osVersion = iosDeviceInfo.systemVersion;
    deviceModel = iosDeviceInfo.utsname.machine;
  } else {
    developmentUrl = 'http://10.0.2.2:3000';
    androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    isPhysicalDevice = androidDeviceInfo.isPhysicalDevice;
    osVersion = androidDeviceInfo.version.release;
    deviceModel = androidDeviceInfo.brand + ' - ' + androidDeviceInfo.model;
  }

  await appEnv.load();

  App.setup(AppConfig(
    packageInfo: await PackageInfo.fromPlatform(),
    isPhysicalDevice: isPhysicalDevice,
    deviceModel: deviceModel,
    osVersion: osVersion,
    env: development ? 'development' : 'production',
    databaseVersion: 4,
    apiBaseUrl: '${development ? developmentUrl : 'https://rapi.unact.ru'}/api/',
    sentryDsn: appEnv['SENTRY_DSN']
  )).run();
}
