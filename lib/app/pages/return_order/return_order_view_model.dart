part of 'return_order_page.dart';

class ReturnOrderViewModel extends PageViewModel<ReturnOrderState, ReturnOrderStateStatus> {
  final AppRepository appRepository;
  final ReturnsRepository returnsRepository;

  ReturnOrderViewModel(this.appRepository, this.returnsRepository, {required ReturnOrder returnOrder}) :
    super(ReturnOrderState(returnOrder: returnOrder), [appRepository, returnsRepository]);

  @override
  ReturnOrderStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final returnTypes = await returnsRepository.getReturnTypesByBuyer(state.returnOrder.buyerId);
    final recepts = await returnsRepository.getRecepts();
    final returnOrder = await returnsRepository.getReturnOrder(state.returnOrder.id);
    final exLines = await returnsRepository.getReturnOrderLineExList(state.returnOrder.id);

    emit(state.copyWith(
      returnOrder: returnOrder,
      recepts: recepts,
      returnTypes: returnTypes,
      exLines: exLines,
      status: ReturnOrderStateStatus.dataLoaded,
    ));
  }

  Future<void> updateNeedPickup(bool needPickup) async {
    await returnsRepository.updateReturnOrder(
      state.returnOrder,
      needPickup: Optional.of(needPickup)
    );

    emit(state.copyWith(status: ReturnOrderStateStatus.returnOrderUpdated));
  }

  Future<void> updateReturnType(int returnTypeId) async {
    await returnsRepository.updateReturnOrder(
      state.returnOrder,
      returnTypeId: Optional.of(returnTypeId),
      receptId: const Optional.fromNullable(null)
    );

    for (var exLine in state.exLines) {
      await returnsRepository.deleteReturnOrderLine(exLine.line);
    }

    emit(state.copyWith(status: ReturnOrderStateStatus.inProgress));

    try {
      await returnsRepository.loadBuyerData(state.returnOrder.buyerId, returnTypeId);

      emit(state.copyWith(
        status: ReturnOrderStateStatus.success,
        message: 'Загружены товары покупателя',
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: ReturnOrderStateStatus.failure, message: e.message));
    }
  }

  Future<void> updateRecept(int receptId) async {
    await returnsRepository.updateReturnOrder(
      state.returnOrder,
      receptId: Optional.of(receptId)
    );

    for (var exLine in state.exLines) {
      await returnsRepository.deleteReturnOrderLine(exLine.line);
    }

    emit(state.copyWith(status: ReturnOrderStateStatus.inProgress));

    try {
      await returnsRepository.loadReceptData(state.returnOrder.buyerId, state.returnOrder.returnTypeId!, receptId);

      emit(state.copyWith(
        status: ReturnOrderStateStatus.success,
        message: 'Загружены товары накладной',
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: ReturnOrderStateStatus.failure, message: e.message));
    }
  }

  Future<void> clear() async {
    await returnsRepository.updateReturnOrder(
      state.returnOrder,
      needPickup: Optional.of(false),
      returnTypeId: const Optional.fromNullable(null),
      receptId: const Optional.fromNullable(null)
    );

    for (var exLine in state.exLines) {
      await returnsRepository.deleteReturnOrderLine(exLine.line);
    }

    await returnsRepository.clearBuyerData();
  }

  Future<void> addReturnOrderLine() async {
    final returnOrderLineEx = await returnsRepository.addReturnOrderLine(state.returnOrder);

    emit(state.copyWith(
      status: ReturnOrderStateStatus.returnOrderLineAdded,
      addedReturnOrderLineEx: returnOrderLineEx
    ));
  }

  Future<void> save() async {
    if (state.exLines.isEmpty) {
      emit(state.copyWith(
        status: ReturnOrderStateStatus.failure,
        message: 'Нет позиций для возврата'
      ));
      return;
    }

    if (state.exLines.any((e) => e.goods == null)) {
      emit(state.copyWith(
        status: ReturnOrderStateStatus.failure,
        message: 'Есть позиции без указанного товара'
      ));
      return;
    }

    final incorrectIsBad = state.exLines.firstWhereOrNull((e) => e.line.isBad == null);
    if (incorrectIsBad != null) {
      emit(state.copyWith(
        status: ReturnOrderStateStatus.failure,
        message: 'Для позиции ${incorrectIsBad.goods!.name} не указано состояние'
      ));
      return;
    }

    final incorrectVolume = state.exLines.firstWhereOrNull((e) => (e.line.volume ?? 0) == 0);
    if (incorrectVolume != null) {
      emit(state.copyWith(
        status: ReturnOrderStateStatus.failure,
        message: 'Для позиции ${incorrectVolume.goods!.name} не корректно указано кол-во'
      ));
      return;
    }

    final usedVolumes = state.exLines.groupFoldBy<Goods, int>((e) => e.goods!, (p, e) => (p ?? 0) + e.line.volume!);
    final incorrectUsedVolume = usedVolumes.entries.firstWhereOrNull((e) => e.key.leftVolume < e.value);

    if (incorrectUsedVolume != null) {
      emit(state.copyWith(
        status: ReturnOrderStateStatus.failure,
        message: 'Для позиции ${incorrectUsedVolume.key.name} возвращаемое кол-во больше проданного кол-ва'
      ));
      return;
    }

    emit(state.copyWith(status: ReturnOrderStateStatus.inProgress));

    try {
      await returnsRepository.saveReturnOrder(state.returnOrder, state.exLines);
      await appRepository.loadData();

      emit(state.copyWith(
        status: ReturnOrderStateStatus.returnOrderSaved,
        message: 'Возвраты успешно созданы',
        editable: false
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: ReturnOrderStateStatus.failure, message: e.message));
    }
  }

  Future<void> deleteReturnOrderLine(ReturnOrderLineEx returnOrderLineEx) async {
    await returnsRepository.deleteReturnOrderLine(returnOrderLineEx.line);
  }
}
