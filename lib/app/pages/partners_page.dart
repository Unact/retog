import 'package:flutter/material.dart';

import 'package:retog/app/models/partner.dart';
import 'package:retog/app/models/buyer.dart';
import 'package:retog/app/pages/buyers_page.dart';

class PartnersPage extends StatefulWidget {
  PartnersPage({Key key}) : super(key: key);

  @override
  _PartnersPageState createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> with WidgetsBindingObserver {
  _PartnersPageDelegate _delegate = _PartnersPageDelegate();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Partner> _partners = [];

  Future<void> _loadData() async {
    _partners = await Partner.all();
    _partners.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    _delegate.partners = _partners;

    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildBody(BuildContext context) {
    return ListView(children: _partners.map((partner) => _partnerTile(context, partner)).toList());
  }

  Widget _partnerTile(BuildContext context, Partner partner) {
    return _PartnerTile(
      partner: partner,
      onTap: () async {
        List<Buyer> buyers = await Buyer.byPartnerId(partner.id);

        Navigator.push(context, MaterialPageRoute(builder: (context) => BuyersPage(buyers: buyers)));
      }
    );
  }

  @override
  void initState() {

    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Партнеры'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Поиск',
            icon: Icon(Icons.search),
            onPressed: () async {
              Partner partner = await showSearch<Partner>(context: context, delegate: _delegate);

              if (partner != null) {
                List<Buyer> buyers = await Buyer.byPartnerId(partner.id);

                Navigator.push(context, MaterialPageRoute(builder: (context) => BuyersPage(buyers: buyers)));
              }
            },
          )
        ],
      ),
      body: _buildBody(context)
    );
  }
}

class _PartnerTile extends StatelessWidget {
  _PartnerTile({this.partner, this.onTap});

  final Partner partner;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(partner.name),
      onTap: onTap
    );
  }
}

class _PartnersPageDelegate extends SearchDelegate<Partner> {
  List<Partner> partners = [];

  _PartnersPageDelegate();

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Назад',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    String searchStr = query.toLowerCase();
    List<Partner> suggestions = partners.
      where((Partner partner) => partner.name.toLowerCase().contains(searchStr)).
      toList();

    if (suggestions.isEmpty) {
      return Center(child: Text('Ничего не найдено', textAlign: TextAlign.center));
    }

    if (query.isEmpty) {
      return Container();
    }

    return ListView(
      children: suggestions.map((partner) {
        return _PartnerTile(
          partner: partner,
          onTap: () async {
            close(context, partner);
          },
        );
      }).toList()
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
        ? Container()
        : IconButton(tooltip: 'Очистить', icon: Icon(Icons.clear), onPressed: () => query = '')
    ];
  }
}
