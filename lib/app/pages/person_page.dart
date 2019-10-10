import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/user.dart';
import 'package:retog/app/modules/api.dart';

class PersonPage extends StatefulWidget {
  PersonPage({Key key}) : super(key: key);

  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _logout() async {
    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Padding(padding: EdgeInsets.all(5.0), child: Center(child: CircularProgressIndicator()));
        }
      );

      await Api.logout();
      await User.currentUser.reset();
      await App.application.data.dataSync.clearData();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
    } on ApiException catch(e) {
      Navigator.pop(context);
      _showMessage(e.errorMsg);
    }
  }

  void _importData() async {
    String msg;

    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => Center(child: CircularProgressIndicator())
      );

      await App.application.data.dataSync.importData();
      msg = 'База данных успешно обновлена';
    } on ApiException catch(e) {
      msg = e.errorMsg;
    } catch(e) {
      msg = 'Произошла ошибка';
    } finally {
      setState((){
        Navigator.pop(context);
        _showMessage(msg);
      });
    }
  }

  Future<void> _launchAppUpdate() async {
    String androidUpdateUrl = 'https://github.com/Unact/retog/releases/download/${Api.workingVersion}/app-release.apk';
    String iosUpdateUrl = 'itms-services://?action=download-manifest&url=https://unact.github.io/mobile_apps/retog/manifest.plist';
    String url = Platform.isIOS ? iosUpdateUrl : androidUpdateUrl;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showMessage('Произошла ошибка');
    }
  }

  void _showMessage(String content) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(content)));
  }

  Widget _buildInfoRow(String leftStr, String rightStr) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(leftStr)),
          Text(rightStr)
        ]
      )
    );
  }

  Widget _buildUpdateAppButton(BuildContext context) {
    if (Api.workingVersion != null && Api.workingVersion != App.application.config.packageInfo.version)
      return Padding(
        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _launchAppUpdate,
              child: Text('Обновить приложение'),
            )
          ],
        )
      );

    return Container();
  }

  Widget _buildBody(BuildContext context) {
    DateTime lastSyncTime = App.application.data.dataSync.lastSyncTime;
    String lastSyncTimeText = lastSyncTime != null ?
      DateFormat.yMMMd('ru').add_jms().format(lastSyncTime) :
      'Не проводилось';

    return ListView(
      padding: EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
      children: [
        Column(
          children: [
            _buildInfoRow('Логин', User.currentUser.username),
            _buildInfoRow('ТП', User.currentUser.salesmanName),
            _buildInfoRow('Версия', App.application.config.packageInfo.version),
            _buildInfoRow('Обновление БД', lastSyncTimeText),
            _buildUpdateAppButton(context),
            Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: _importData,
                    child: Text('Обновить БД'),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: _logout,
                    child: Text('Выйти', style: TextStyle(color: Colors.white)),
                  ),
                ]
              )
            )
          ]
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Пользователь'),
      ),
      body: _buildBody(context)
    );
  }
}
