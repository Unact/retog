part of 'line_edit_page.dart';

enum LineEditStateStatus {
  initial,
  dataLoaded,
  failure,
  showScan,
  returnOrderLineUpdated
}

class LineEditState {
  LineEditState({
    this.status = LineEditStateStatus.initial,
    required this.returnOrderLineEx,
    this.goodsList = const [],
    this.exLines = const [],
    this.message = '',
  });

  final String message;
  final ReturnOrderLineEx returnOrderLineEx;
  final List<Goods> goodsList;
  final List<ReturnOrderLineEx> exLines;
  final LineEditStateStatus status;

  LineEditState copyWith({
    LineEditStateStatus? status,
    ReturnOrderLineEx? returnOrderLineEx,
    List<Goods>? goodsList,
    List<ReturnOrderLineEx>? exLines,
    String? message
  }) {
    return LineEditState(
      status: status ?? this.status,
      returnOrderLineEx: returnOrderLineEx ?? this.returnOrderLineEx,
      goodsList: goodsList ?? this.goodsList,
      exLines: exLines ?? this.exLines,
      message: message ?? this.message
    );
  }
}
