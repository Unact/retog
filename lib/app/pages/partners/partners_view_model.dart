part of 'partners_page.dart';

class PartnersViewModel extends PageViewModel<PartnersState, PartnersStateStatus> {
  final AppRepository appRepository;
  final ReturnsRepository returnsRepository;

  PartnersViewModel(this.appRepository, this.returnsRepository) :
    super(PartnersState(), [appRepository, returnsRepository]);

  @override
  PartnersStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final partners = await returnsRepository.getPartners();

    emit(state.copyWith(
      status: PartnersStateStatus.dataLoaded,
      partners: partners
    ));
  }

  Future<void> selectPartner(Partner partner) async {
    emit(state.copyWith(
      status: PartnersStateStatus.partnerSelected,
      selectedPartner: partner
    ));
  }
}
