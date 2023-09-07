import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/returns_repository.dart';
import 'line_edit/line_edit_page.dart';

part 'return_order_state.dart';
part 'return_order_view_model.dart';

class ReturnOrderPage extends StatelessWidget {
  final ReturnOrder returnOrder;

  ReturnOrderPage({
    required this.returnOrder,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReturnOrderViewModel>(
      create: (context) => ReturnOrderViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<ReturnsRepository>(context),
        returnOrder: returnOrder
      ),
      child: _ReturnOrderView(),
    );
  }
}

class _ReturnOrderView extends StatefulWidget {
  @override
  _ReturnOrderViewState createState() => _ReturnOrderViewState();
}

class _ReturnOrderViewState extends State<_ReturnOrderView> {
  final double tileTextWidth = 92;
  late final ProgressDialog progressDialog = ProgressDialog(context: context);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReturnOrderViewModel, ReturnOrderState>(
      builder: (context, state) {
        final vm = context.read<ReturnOrderViewModel>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Акт возврата'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(168),
              child: buildHeader(context)
            )
          ),
          body: buildBody(context),
          persistentFooterButtons: <Widget>[
            TextButton(
              onPressed: state.editable ? vm.clear : null,
              child: const Text('Очистить')
            ),
            const SizedBox(width: 24),
            TextButton(
              onPressed: state.editable ? vm.addReturnOrderLine : null,
              child: const Text('Добавить')
            ),
            TextButton(
              onPressed: state.editable ? vm.save : null,
              child: const Text('Сохранить')
            ),
          ],
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case ReturnOrderStateStatus.returnOrderLineAdded:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openLineEditPage(state.addedReturnOrderLineEx!);
            });
            break;
          case ReturnOrderStateStatus.inProgress:
            await progressDialog.open();
            break;
          case ReturnOrderStateStatus.returnOrderSaved:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              progressDialog.close();
              Misc.showMessage(context, state.message);
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
            break;
          case ReturnOrderStateStatus.success:
          case ReturnOrderStateStatus.failure:
            progressDialog.close();
            Misc.showMessage(context, state.message);
            break;
          default:
            break;
        }
      },
    );
  }

  Widget buildBody(BuildContext context) {
    final vm = context.read<ReturnOrderViewModel>();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: vm.state.exLines.map((e) => buildReturnOrderLineTile(context, e)).toList()
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          buildPickupCheckBox(context),
          buildTypeDropdown(context),
          buildReceptDropdown(context),
        ],
      )
    );
  }

  Widget buildPickupCheckBox(BuildContext context) {
    final vm = context.read<ReturnOrderViewModel>();
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: <Widget>[
          Expanded(child: Text('Самовывоз', style: TextStyle(color: theme.disabledColor, fontSize: 16.0))),
          Checkbox(
            value: !vm.state.returnOrder.needPickup,
            onChanged: !vm.state.editable ? null : (bool? value) => vm.updateNeedPickup(!value!)
          ),
        ]
      )
    );
  }

  Widget buildTypeDropdown(BuildContext context) {
    final vm = context.read<ReturnOrderViewModel>();

    return DropdownButtonFormField(
      decoration: const InputDecoration(contentPadding: EdgeInsets.all(8), labelText: 'Тип'),
      value: vm.state.returnOrder.returnTypeId,
      items: vm.state.returnTypes.map((ReturnType returnType) {
        return DropdownMenuItem<int>(
          value: returnType.id,
          child: Text(returnType.name)
        );
      }).toList(),
      onChanged: !vm.state.editable ? null : (int? value) => vm.updateReturnType(value!)
    );
  }

  Widget buildReceptDropdown(BuildContext context) {
    final vm = context.read<ReturnOrderViewModel>();

    return DropdownButtonFormField(
      decoration: const InputDecoration(contentPadding: EdgeInsets.all(8), labelText: 'Накладная'),
      value: vm.state.returnOrder.receptId,
      items: vm.state.recepts.map((Recept recept) {
        return DropdownMenuItem<int>(
          value: recept.id,
          child: Text(recept.name)
        );
      }).toList(),
      onChanged: !vm.state.editable ? null : (int? value) => vm.updateRecept(value!)
    );
  }

  Widget buildReturnOrderLineTile(BuildContext context, ReturnOrderLineEx returnOrderLineEx) {
    final vm = context.read<ReturnOrderViewModel>();
    final line = returnOrderLineEx.line;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              SizedBox(width: tileTextWidth, child: const Text('Товар', style: TextStyle(color: Colors.grey))),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Text(returnOrderLineEx.goods?.name ?? '')
                  ]
                )
              )
            ]),
            const SizedBox(height: 8),
            Row(children: <Widget>[
              SizedBox(width: tileTextWidth, child: const Text('Состояние', style: TextStyle(color: Colors.grey))),
              Text(line.isBad == null ? '' : line.isBad! ? 'Некондиция' : 'Кондиция')
            ]),
            const SizedBox(height: 8),
            Row(children: <Widget>[
              SizedBox(width: tileTextWidth, child: const Text('Дата', style: TextStyle(color: Colors.grey))),
              Text(Format.dateStr(line.productionDate))
            ]),
            const SizedBox(height: 8),
            Row(children: <Widget>[
              SizedBox(width: tileTextWidth, child: const Text('Кол-во', style: TextStyle(color: Colors.grey))),
              Text(line.volume?.toString() ?? ''),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: !vm.state.editable ? null : () => openLineEditPage(returnOrderLineEx)
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: !vm.state.editable ? null : () => vm.deleteReturnOrderLine(returnOrderLineEx)
                )
              ],
            )
          ],
        ),
      )
    );
  }

  Future<void> openLineEditPage(ReturnOrderLineEx returnOrderLineEx) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LineEditPage(returnOrderLineEx: returnOrderLineEx))
    );
  }
}
