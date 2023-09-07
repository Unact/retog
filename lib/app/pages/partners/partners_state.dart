part of 'partners_page.dart';

enum PartnersStateStatus {
  initial,
  dataLoaded,
  partnerSelected
}

class PartnersState {
  PartnersState({
    this.status = PartnersStateStatus.initial,
    this.partners = const [],
    this.selectedPartner
  });

  final PartnersStateStatus status;
  final List<Partner> partners;
  final Partner? selectedPartner;

  PartnersState copyWith({
    PartnersStateStatus? status,
    List<Partner>? partners,
    Partner? selectedPartner
  }) {
    return PartnersState(
      status: status ?? this.status,
      partners: partners ?? this.partners,
      selectedPartner: selectedPartner ?? this.selectedPartner
    );
  }
}
