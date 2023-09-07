import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/home/home_page.dart';
import '/app/pages/person/person_page.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/returns_repository.dart';
import '/app/repositories/users_repository.dart';

part 'info_state.dart';
part 'info_view_model.dart';

class InfoPage extends StatelessWidget {
  InfoPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoViewModel>(
      create: (context) => InfoViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<ReturnsRepository>(context),
        RepositoryProvider.of<UsersRepository>(context),
      ),
      child: _InfoView(),
    );
  }
}

class _InfoView extends StatefulWidget {
  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<_InfoView> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  Completer<void> refresherCompleter = Completer();

  Future<void> openRefresher() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshIndicatorKey.currentState!.show();
    });
  }

  void closeRefresher() {
    refresherCompleter.complete();
    refresherCompleter = Completer();
  }

  void changePage(int index) {
    HomeViewModel homeVm = context.read<HomeViewModel>();

    homeVm.setCurrentIndex(index);
  }

  void setPageChangeable(bool pageChangeable) {
    final homeVm = context.read<HomeViewModel>();

    homeVm.setPageChangeable(pageChangeable);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InfoViewModel, InfoState>(
      builder: (context, state) {
        InfoViewModel vm = context.read<InfoViewModel>();

        return Scaffold(
          appBar: AppBar(
            title: const Text(Strings.ruAppName),
            actions: <Widget>[
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.person),
                tooltip: 'Пользователь',
                onPressed: state.isBusy ?
                  null :
                  () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PersonPage(),
                      fullscreenDialog: true
                    )
                  );
                }
              )
            ]
          ),
          body: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: () async {
              if (vm.state.isBusy) return;

              setPageChangeable(false);
              vm.getData();
              await refresherCompleter.future;
              setPageChangeable(true);

              return;
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 24),
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildInfoCards(context)
                )
              ],
            )
          )
        );
      },
      listener: (context, state) {
        switch (state.status) {
          case InfoStateStatus.startLoad:
            openRefresher();
            break;
          case InfoStateStatus.failure:
          case InfoStateStatus.success:
            Misc.showMessage(context, state.message);
            closeRefresher();
            break;
          default:
            break;
        }
      },
    );
  }

  List<Widget> buildInfoCards(BuildContext context) {
    return <Widget>[
      Card(
        child: ListTile(
          onTap: () => changePage(1),
          isThreeLine: true,
          title: const Text(Strings.partnersPageName),
          subtitle: buildPartnersInfo(context),
        ),
      ),
      Card(
        child: ListTile(
          onTap: () => changePage(2),
          isThreeLine: true,
          title: const Text(Strings.actsPageName),
          subtitle: buildActsInfo(context),
        ),
      ),
      buildInfoCard(context),
    ];
  }

  Widget buildPartnersInfo(BuildContext context) {
    InfoViewModel vm = context.read<InfoViewModel>();

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.grey),
        children: <TextSpan>[
          TextSpan(text: 'Всего: ${vm.state.partners.length}\n', style: const TextStyle(fontSize: 12.0)),
          TextSpan(text: 'Покупателей: ${vm.state.buyers.length}\n', style: const TextStyle(fontSize: 12.0)),
        ]
      )
    );
  }

  Widget buildActsInfo(BuildContext context) {
    InfoViewModel vm = context.read<InfoViewModel>();

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.grey),
        children: <TextSpan>[
          TextSpan(
            text: 'Создано: ${vm.state.acts.length}',
            style: const TextStyle(fontSize: 12.0)
          )
        ]
      )
    );
  }

  Widget buildInfoCard(BuildContext context) {
    InfoViewModel vm = context.read<InfoViewModel>();

    if (!vm.state.newVersionAvailable) return Container();

    return const Card(
      child: ListTile(
        isThreeLine: true,
        title: Text('Информация'),
        subtitle: Text('Доступна новая версия приложения'),
      )
    );
  }
}
