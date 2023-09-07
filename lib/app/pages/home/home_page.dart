import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/constants/strings.dart';
import '/app/pages/acts/acts_page.dart';
import '/app/pages/info/info_page.dart';
import '/app/pages/partners/partners_page.dart';
import '/app/pages/shared/page_view_model.dart';

part 'home_state.dart';
part 'home_view_model.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeViewModel>(
      create: (context) => HomeViewModel(),
      child: _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: buildBottomNavigationBar(context),
          body: IndexedStack(
            index: state.currentIndex,
            children: <Widget>[
              InfoPage(),
              PartnersPage(),
              ActsPage()
            ],
          ),
        );
      }
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    HomeViewModel vm = context.read<HomeViewModel>();

    return BottomNavigationBar(
      currentIndex: vm.state.currentIndex,
      onTap: vm.state.pageChangeable ? vm.setCurrentIndex : null,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: Strings.infoPageName),
        BottomNavigationBarItem(icon: Icon(Icons.local_grocery_store), label: Strings.partnersPageName),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: Strings.actsPageName)
      ],
    );
  }
}
