import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/act.dart';
import 'package:retog/app/models/buyer.dart';
import 'package:retog/app/models/partner.dart';
import 'package:retog/app/models/user.dart';
import 'package:retog/app/modules/api.dart';
import 'package:retog/app/pages/person_page.dart';

class InfoPage extends StatefulWidget {
  final GlobalKey bottomNavigationBarKey;
  InfoPage({Key key, @required this.bottomNavigationBarKey}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Buyer> _buyers = [];
  List<Partner> _partners = [];
  List<Act> _acts = [];

  Future<void> _loadData() async {
    _acts = await Act.all();
    _buyers = await Buyer.all();
    _partners = await Partner.all();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _syncData() async {
    try {
      await App.application.data.dataSync.importData();
      await _loadData();
      _showSnackBar('Данные успешно обновлены');
    } on ApiException catch(e) {
      _showErrorSnackBar(e.errorMsg);
    } catch(e) {
      _showErrorSnackBar('Произошла ошибка');
    }
  }

  void _showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
  }

  void _showErrorSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      action: SnackBarAction(
        label: 'Повторить',
        onPressed: _refreshIndicatorKey.currentState?.show
      )
    ));
  }

  List<Widget> _buildInfoCards(BuildContext context) {
    return <Widget>[
      Card(
        child: ListTile(
          onTap: () {
            BottomNavigationBar navigationBar = widget.bottomNavigationBarKey.currentWidget;
            navigationBar.onTap(1);
          },
          isThreeLine: true,
          title: Text('Партнеры'),
          subtitle: _buildPartnersInfo(),
        ),
      ),
      Card(
        child: ListTile(
          onTap: () {
            BottomNavigationBar navigationBar = widget.bottomNavigationBarKey.currentWidget;
            navigationBar.onTap(2);
          },
          isThreeLine: true,
          title: Text('Акты'),
          subtitle: _buildActsInfo(),
        ),
      ),
      _buildInfoCard(),
    ];
  }

  Widget _buildInfoCard() {
    if (User.currentUser.newVersionAvailable) {
      return Card(
        child: ListTile(
          isThreeLine: true,
          title: Text('Информация'),
          subtitle: Text('Доступна новая версия приложения'),
        )
      );
    } else {
      return Container();
    }
  }

  Widget _buildPartnersInfo() {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey),
        children: <TextSpan>[
          TextSpan(text: 'Всего: ${_partners.length}', style: TextStyle(fontSize: 12.0)),
          TextSpan(text: '\nПокупателей: ${_buyers.length}', style: TextStyle(fontSize: 12.0))
        ]
      )
    );
  }

  Widget _buildActsInfo() {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey),
        children: <TextSpan>[
          TextSpan(text: 'Создано: ${_acts.length}', style: TextStyle(fontSize: 12.0))
        ]
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _syncData,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildInfoCards(context)
          );
        }
      )
    );
  }

  Future<void> _backgroundRefresh() async {
    DateTime now = DateTime.now();
    DateTime time = App.application.data.dataSync.lastSyncTime ?? now.subtract(Duration(days: 1));

    if (now.year != time.year || now.month != time.month || now.day != time.day) {
      _refreshIndicatorKey.currentState?.show();
    }
  }

  @override
  void initState() {

    super.initState();
    _loadData();

    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) => _backgroundRefresh());
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Возвраты'),
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.person),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => PersonPage(), fullscreenDialog: true)
              );
            }
          )
        ]
      ),
      body: _buildBody(context)
    );
  }
}
