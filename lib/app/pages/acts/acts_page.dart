import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/pages/return_order/return_order_page.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/returns_repository.dart';

part 'acts_state.dart';
part 'acts_view_model.dart';

class ActsPage extends StatelessWidget {
  ActsPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActsViewModel>(
      create: (context) => ActsViewModel(
        RepositoryProvider.of<ReturnsRepository>(context),
      ),
      child: _ActsView(),
    );
  }
}

class _ActsView extends StatefulWidget {
  @override
  _ActsViewState createState() => _ActsViewState();
}

class _ActsViewState extends State<_ActsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.actsPageName)
      ),
      body: BlocBuilder<ActsViewModel, ActsState>(
        builder: (context, state) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 24),
            children: [
              ...state.returnOrders.map((e) => returnOrderTile(context, e)).toList(),
              ...state.acts.map((e) => actTile(context, e)).toList(),
            ]
          );
        }
      )
    );
  }

  Widget actTile(BuildContext context, Act act) {
    return ListTile(
      title: Text('${act.typeName} № ${act.number}', style: const TextStyle(fontSize: 14.0)),
      subtitle: Text('Позиций: ${act.goodsCnt}'),
    );
  }

  Widget returnOrderTile(BuildContext context, ReturnOrder returnOrder) {
    return ListTile(
      title: const Text('Черновик', style: TextStyle(fontSize: 16.0)),
      trailing: const Icon(Icons.edit),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReturnOrderPage(returnOrder: returnOrder))
        );
      }
    );
  }
}
