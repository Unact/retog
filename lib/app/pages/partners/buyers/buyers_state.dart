
part of 'buyers_page.dart';

enum BuyersStateStatus {
  initial,
  dataLoaded,
  returnOrderCreated
}

class BuyersState {
  BuyersState({
    this.status = BuyersStateStatus.initial,
    this.buyers = const [],
    required this.partner,
    this.returnOrder
  });

  final BuyersStateStatus status;
  final List<Buyer> buyers;
  final Partner partner;
  final ReturnOrder? returnOrder;

  BuyersState copyWith({
    BuyersStateStatus? status,
    List<Buyer>? buyers,
    Partner? partner,
    ReturnOrder? returnOrder
  }) {
    return BuyersState(
      status: status ?? this.status,
      buyers: buyers ?? this.buyers,
      partner: partner ?? this.partner,
      returnOrder: returnOrder ?? this.returnOrder
    );
  }
}
