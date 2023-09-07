part of 'info_page.dart';

enum InfoStateStatus {
  initial,
  startLoad,
  dataLoaded,
  success,
  failure,
  inProgress
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial,
    this.newVersionAvailable = false,
    this.message = '',
    this.user,
    this.pref,
    this.buyers = const [],
    this.partners = const [],
    this.acts = const [],
    this.isBusy = false
  });

  final InfoStateStatus status;
  final List<Buyer> buyers;
  final List<Partner> partners;
  final List<Act> acts;
  final bool newVersionAvailable;
  final String message;
  final User? user;
  final Pref? pref;
  final bool isBusy;

  InfoState copyWith({
    InfoStateStatus? status,
    bool? newVersionAvailable,
    String? message,
    User? user,
    Pref? pref,
    List<Buyer>? buyers,
    List<Partner>? partners,
    List<Act>? acts,
    bool? isBusy
  }) {
    return InfoState(
      status: status ?? this.status,
      newVersionAvailable: newVersionAvailable ?? this.newVersionAvailable,
      message: message ?? this.message,
      user: user ?? this.user,
      pref: pref ?? this.pref,
      buyers: buyers ?? this.buyers,
      partners: partners ?? this.partners,
      acts: acts ?? this.acts,
      isBusy: isBusy ?? this.isBusy
    );
  }
}
