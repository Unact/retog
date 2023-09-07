part of 'acts_page.dart';

class ActsViewModel extends PageViewModel<ActsState, ActsStateStatus> {
  final ReturnsRepository returnsRepository;

  ActsViewModel(this.returnsRepository) : super(ActsState(), [returnsRepository]);

  @override
  ActsStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final acts = await returnsRepository.getActs();
    final returnOrders = await returnsRepository.getReturnOrders();

    emit(state.copyWith(
      status: ActsStateStatus.dataLoaded,
      acts: acts,
      returnOrders: returnOrders
    ));
  }
}
