import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/returns_repository.dart';

part 'line_edit_state.dart';
part 'line_edit_view_model.dart';

class LineEditPage extends StatelessWidget {
  final ReturnOrderLineEx returnOrderLineEx;

  LineEditPage({
    required this.returnOrderLineEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LineEditViewModel>(
      create: (context) => LineEditViewModel(
        RepositoryProvider.of<ReturnsRepository>(context),
        returnOrderLineEx: returnOrderLineEx
      ),
      child: _LineEditView(),
    );
  }
}

class _LineEditView extends StatefulWidget {
  @override
  _LineEditViewState createState() => _LineEditViewState();
}

class _LineEditViewState extends State<_LineEditView> {
  final endOfTime = DateTime(9999, 1, 1);
  final startOfTime = DateTime(2015, 8, 1);
  final TextEditingController goodsController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();
  final TextEditingController leftVolumeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LineEditViewModel, LineEditState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Пользователь'),
          ),
          body: buildBody(context)
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case LineEditStateStatus.failure:
            Misc.showMessage(context, state.message);
            break;
          case LineEditStateStatus.showScan:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showScanPage();
            });
            break;
          default:
            break;
        }
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        buildGoodsSearch(context),
        buildTypeDropDown(context),
        buildProductionDate(context),
        buildLeftVolumeField(context),
        buildVolumeField(context)
      ]
    );
  }

  Widget buildGoodsSearch(BuildContext context) {
    final vm = context.read<LineEditViewModel>();
    ThemeData theme = Theme.of(context);

    goodsController.text = vm.state.returnOrderLineEx.goods?.name ?? '';

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        maxLines: 2,
        cursorColor: theme.textSelectionTheme.selectionColor,
        autocorrect: false,
        controller: goodsController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          labelText: 'Товар',
          suffixIcon: IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: vm.tryShowScan
          )
        )
      ),
      errorBuilder: (BuildContext ctx, error) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Произошла ошибка', style: Styles.formStyle.apply(color: theme.colorScheme.error)),
        );
      },
      noItemsFoundBuilder: (BuildContext ctx) {
        return const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Ничего не найдено', style: Styles.formStyle),
        );
      },
      suggestionsCallback: (String value) async {
        return vm.state.goodsList
          .where((Goods goods) => goods.leftVolume > 0)
          .where((Goods goods) => goods.name.toLowerCase().contains(value.toLowerCase())).toList();
      },
      itemBuilder: (BuildContext ctx, Goods suggestion) {
        return ListTile(
          isThreeLine: false,
          title: Text(suggestion.name, style: Styles.formStyle)
        );
      },
      onSuggestionSelected: (Goods suggestion) async {
        goodsController.text = suggestion.name;
        vm.updateGoods(suggestion);
      }
    );
  }

  Widget buildTypeDropDown(BuildContext context) {
    final vm = context.read<LineEditViewModel>();

    return DropdownButtonFormField(
      decoration: const InputDecoration(contentPadding: EdgeInsets.all(8), labelText: 'Состояние'),
      items: <bool>[false, true].map((bool value) {
        return DropdownMenuItem<bool>(
          value: value,
          child: Text(value ? 'Некондиция' : 'Кондиция'),
        );
      }).toList(),
      value: vm.state.returnOrderLineEx.line.isBad,
      onChanged: (bool? value) => vm.updateIsBad(value!)
    );
  }

  Widget buildProductionDate(BuildContext context) {
    final vm = context.read<LineEditViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(Format.dateStr(vm.state.returnOrderLineEx.line.productionDate), style: Styles.formStyle),
        IconButton(
          onPressed: showDateDialog,
          tooltip: 'Указать дату',
          icon: const Icon(Icons.calendar_month)
        )
      ]
    );
  }

  Widget buildLeftVolumeField(BuildContext context) {
    final vm = context.read<LineEditViewModel>();

    leftVolumeController.text = '';

    if (vm.state.returnOrderLineEx.goods != null) {
      final usedVolume = vm.state.exLines
        .where((e) => e.line != vm.state.returnOrderLineEx.line)
        .where((e) => e.goods == vm.state.returnOrderLineEx.goods).fold(0, (prev, e) => prev + (e.line.volume ?? 0));
      leftVolumeController.text = (vm.state.returnOrderLineEx.goods!.leftVolume - usedVolume).toString();
    }

    return TextField(
      controller: leftVolumeController,
      enabled: false,
      decoration: const InputDecoration(contentPadding: EdgeInsets.all(8), labelText: 'Продано')
    );
  }

  Widget buildVolumeField(BuildContext context) {
    final vm = context.read<LineEditViewModel>();

    volumeController.text = vm.state.returnOrderLineEx.line.volume?.toString() ?? '';

    return SizedBox(
      width: 140,
      child: NumTextField(
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        decimal: false,
        controller: volumeController,
        style: Styles.formStyle,
        decoration: const InputDecoration(contentPadding: EdgeInsets.all(8), labelText: 'Кол-во'),
        onTap: () => vm.updateVolume(Parsing.parseDouble(volumeController.text)?.toInt())
      )
    );
  }

  Future<void> showDateDialog() async {
    final vm = context.read<LineEditViewModel>();
    DateTime? result = await showDatePicker(
      context: context,
      firstDate: startOfTime,
      lastDate: endOfTime,
      initialDate: vm.state.returnOrderLineEx.line.productionDate ?? DateTime.now()
    );

    vm.updateProductionDate(result);
  }

  Future<void> showScanPage() async {
    final vm = context.read<LineEditViewModel>();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanView(
        onRead: vm.readCode,
        showScanner: false,
        barcodeMode: true,
        child: const Text('Отсканируйте штрих-код'),
      ))
    );
  }
}
