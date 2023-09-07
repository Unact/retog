part of 'buyers_page.dart';

class BuyersViewModel extends PageViewModel<BuyersState, BuyersStateStatus> {
  final ReturnsRepository returnsRepository;

  BuyersViewModel(this.returnsRepository, {required Partner partner}) :
    super(BuyersState(partner: partner), [returnsRepository]);

  @override
  BuyersStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final buyers = (await returnsRepository.getBuyers()).where((e) => e.partnerId == state.partner.id).toList();

    emit(state.copyWith(
      status: BuyersStateStatus.dataLoaded,
      buyers: buyers
    ));
  }

  Future<void> createReturn(Buyer buyer) async {
    final returnOrder = await returnsRepository.addReturnOrder(buyer: buyer);

    emit(state.copyWith(
      status: BuyersStateStatus.returnOrderCreated,
      returnOrder: returnOrder
    ));
  }
}
