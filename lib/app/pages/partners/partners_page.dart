import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/returns_repository.dart';
import 'buyers/buyers_page.dart';

part 'partners_state.dart';
part 'partners_view_model.dart';

class PartnersPage extends StatelessWidget {
  PartnersPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PartnersViewModel>(
      create: (context) => PartnersViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<ReturnsRepository>(context),
      ),
      child: _PartnersView(),
    );
  }
}

class _PartnersView extends StatefulWidget {
  @override
  _PartnersViewState createState() => _PartnersViewState();
}

class _PartnersViewState extends State<_PartnersView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PartnersViewModel, PartnersState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(Strings.partnersPageName),
            actions: <Widget>[
              IconButton(
                tooltip: 'Поиск',
                icon: const Icon(Icons.search),
                onPressed: () async {
                  final vm = context.read<PartnersViewModel>();
                  final partner = await showSearch<Partner?>(
                    context: context,
                    delegate: _PartnersPageDelegate(partners: vm.state.partners)
                  );

                  if (partner != null) vm.selectPartner(partner);
                },
              )
            ]
          ),
          body: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 24),
            children: [
              ...state.partners.map((e) => partnerTile(context, e)).toList(),
            ]
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case PartnersStateStatus.partnerSelected:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BuyersPage(partner: state.selectedPartner!))
              );
            });
            break;
          default:
            break;
        }
      }
    );
  }

  Widget partnerTile(BuildContext context, Partner partner) {
    final vm = context.read<PartnersViewModel>();

    return ListTile(
      title: Text(partner.name, style: const TextStyle(fontSize: 14.0)),
      onTap: () => vm.selectPartner(partner)
    );
  }
}

class _PartnerTile extends StatelessWidget {
  _PartnerTile({
    required this.partner,
    required this.onTap
  });

  final Partner partner;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(partner.name),
      onTap: onTap
    );
  }
}

class _PartnersPageDelegate extends SearchDelegate<Partner?> {
  final List<Partner> partners;

  _PartnersPageDelegate({
    required this.partners
  });

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

    if (suggestions.isEmpty) return const Center(child: Text('Ничего не найдено', textAlign: TextAlign.center));
    if (query.isEmpty) return Container();

    return ListView(
      children: suggestions.map((partner) {
        return _PartnerTile(
          partner: partner,
          onTap: () async => close(context, partner)
        );
      }).toList()
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty ?
        Container() :
        IconButton(tooltip: 'Очистить', icon: const Icon(Icons.clear), onPressed: () => query = '')
    ];
  }
}
