part of 'return_order_page.dart';

enum ReturnOrderStateStatus {
  initial,
  dataLoaded,
  returnOrderUpdated,
  returnOrderLineAdded,
  returnOrderSaved,
  success,
  failure,
  inProgress
}

class ReturnOrderState {
  ReturnOrderState({
    this.status = ReturnOrderStateStatus.initial,
    required this.returnOrder,
    this.returnTypes = const [],
    this.recepts = const [],
    this.exLines = const [],
    this.message = '',
    this.addedReturnOrderLineEx,
    this.editable = true
  });

  final String message;
  final ReturnOrder returnOrder;
  final List<ReturnType> returnTypes;
  final List<Recept> recepts;
  final List<ReturnOrderLineEx> exLines;
  final ReturnOrderLineEx? addedReturnOrderLineEx;
  final bool editable;
  final ReturnOrderStateStatus status;

  ReturnOrderState copyWith({
    ReturnOrderStateStatus? status,
    ReturnOrder? returnOrder,
    List<ReturnType>? returnTypes,
    List<Recept>? recepts,
    List<ReturnOrderLineEx>? exLines,
    String? message,
    ReturnOrderLineEx? addedReturnOrderLineEx,
    bool? editable
  }) {
    return ReturnOrderState(
      status: status ?? this.status,
      returnOrder: returnOrder ?? this.returnOrder,
      returnTypes: returnTypes ?? this.returnTypes,
      recepts: recepts ?? this.recepts,
      exLines: exLines ?? this.exLines,
      message: message ?? this.message,
      addedReturnOrderLineEx: addedReturnOrderLineEx ?? this.addedReturnOrderLineEx,
      editable: editable ?? this.editable
    );
  }
}
