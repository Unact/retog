import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/pages/return_order/return_order_page.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/returns_repository.dart';

part 'buyers_state.dart';
part 'buyers_view_model.dart';

class BuyersPage extends StatelessWidget {
  final Partner partner;

  BuyersPage({
    required this.partner,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BuyersViewModel>(
      create: (context) => BuyersViewModel(
        RepositoryProvider.of<ReturnsRepository>(context),
        partner: partner
      ),
      child: _BuyersView(),
    );
  }
}

class _BuyersView extends StatefulWidget {
  @override
  _BuyersViewState createState() => _BuyersViewState();
}

class _BuyersViewState extends State<_BuyersView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BuyersViewModel, BuyersState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text(Strings.buyersPageName)),
          body: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 24),
            children: [
              ...state.buyers.map((e) => buyerTile(context, e)).toList(),
            ]
          )
        );
      },
      listener: (context, state) {
        switch (state.status) {
          case BuyersStateStatus.returnOrderCreated:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReturnOrderPage(returnOrder: state.returnOrder!))
              );
            });
            break;
          default:
            break;
        }
      }
    );
  }

  Widget buyerTile(BuildContext context, Buyer buyer) {
    final vm = context.read<BuyersViewModel>();

    return ListTile(
      title: Text(buyer.name, style: const TextStyle(fontSize: 14.0)),
      onTap: () => vm.createReturn(buyer)
    );
  }
}
