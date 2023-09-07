part of 'line_edit_page.dart';

class LineEditViewModel extends PageViewModel<LineEditState, LineEditStateStatus> {
  final ReturnsRepository returnsRepository;

  LineEditViewModel(this.returnsRepository, {required ReturnOrderLineEx returnOrderLineEx}) :
    super(LineEditState(returnOrderLineEx: returnOrderLineEx), [returnsRepository]);

  @override
  LineEditStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final goodsList = await returnsRepository.getGoods();
    final returnOrderLineEx = await returnsRepository.getReturnOrderLineEx(state.returnOrderLineEx.line.id);
    final exLines = await returnsRepository.getReturnOrderLineExList(state.returnOrderLineEx.line.returnOrderId);

    emit(state.copyWith(
      returnOrderLineEx: returnOrderLineEx,
      exLines: exLines,
      goodsList: goodsList,
      status: LineEditStateStatus.dataLoaded,
    ));
  }

  void tryShowScan() async {
    if (!await Permissions.hasCameraPermissions()) {
      emit(state.copyWith(message: 'Не разрешено использование камеры', status: LineEditStateStatus.failure));
      return;
    }

    emit(state.copyWith(status: LineEditStateStatus.showScan));
  }

  Future<void> updateGoods(Goods goods) async {
    await returnsRepository.updateReturnOrderLine(
      state.returnOrderLineEx.line,
      goodsId: Optional.of(goods.id)
    );

    emit(state.copyWith(status: LineEditStateStatus.returnOrderLineUpdated));
  }

  Future<void> updateIsBad(bool isBad) async {
    await returnsRepository.updateReturnOrderLine(
      state.returnOrderLineEx.line,
      isBad: Optional.of(isBad)
    );

    emit(state.copyWith(status: LineEditStateStatus.returnOrderLineUpdated));
  }

  Future<void> updateProductionDate(DateTime? productionDate) async {
    await returnsRepository.updateReturnOrderLine(
      state.returnOrderLineEx.line,
      productionDate: Optional.fromNullable(productionDate)
    );

    emit(state.copyWith(status: LineEditStateStatus.returnOrderLineUpdated));
  }

  Future<void> updateVolume(int? volume) async {
    await returnsRepository.updateReturnOrderLine(
      state.returnOrderLineEx.line,
      volume: Optional.fromNullable(volume)
    );

    emit(state.copyWith(status: LineEditStateStatus.returnOrderLineUpdated));
  }

  Future<void> readCode(String? barcode) async {
    if (barcode == null) return;

    final goodsList = await returnsRepository.getGoodsByBarcode(barcode);

    if (goodsList.isEmpty) {
      emit(state.copyWith(
        status: LineEditStateStatus.failure,
        message: 'Товар не найден'
      ));
      return;
    }

    final buyerGoodsIds = state.goodsList.map((e) => e.id).toList();
    final foundGoods = goodsList.firstWhereOrNull((e) => buyerGoodsIds.contains(e.id));

    if (foundGoods == null) {
      emit(state.copyWith(
        status: LineEditStateStatus.failure,
        message: 'Покупателю указанный товар не отгружался'
      ));
      return;
    }

    await updateGoods(foundGoods);
  }
}
