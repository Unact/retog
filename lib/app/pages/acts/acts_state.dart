part of 'acts_page.dart';

enum ActsStateStatus {
  initial,
  dataLoaded
}

class ActsState {
  ActsState({
    this.status = ActsStateStatus.initial,
    this.acts = const [],
    this.returnOrders = const []
  });

  final ActsStateStatus status;
  final List<Act> acts;
  final List<ReturnOrder> returnOrders;

  ActsState copyWith({
    ActsStateStatus? status,
    List<Act>? acts,
    List<ReturnOrder>? returnOrders
  }) {
    return ActsState(
      status: status ?? this.status,
      acts: acts ?? this.acts,
      returnOrders: returnOrders ?? this.returnOrders
    );
  }
}
