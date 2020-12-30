import 'package:flutter/material.dart';

import 'package:retog/app/pages/info_page.dart';
import 'package:retog/app/pages/partners_page.dart';
import 'package:retog/app/pages/acts_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _bottomNavigationBarKey = GlobalKey();
  int _currentIndex = 0;
  List<Widget> _children = [];

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      key: _bottomNavigationBarKey,
      currentIndex: _currentIndex,
      onTap: (int index) => setState(() => _currentIndex = index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Главная'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_grocery_store),
          label: 'Партнеры'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Акты'
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return _children[_currentIndex];
  }

  @override
  void initState() {

    super.initState();
    _children = [
      InfoPage(bottomNavigationBarKey: _bottomNavigationBarKey),
      PartnersPage(),
      ActsPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: _buildBody(context)
    );
  }
}
