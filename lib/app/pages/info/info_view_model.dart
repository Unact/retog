part of 'info_page.dart';

class InfoViewModel extends PageViewModel<InfoState, InfoStateStatus> {
  final AppRepository appRepository;
  final ReturnsRepository returnsRepository;
  final UsersRepository usersRepository;

  InfoViewModel(
    this.appRepository,
    this.returnsRepository,
    this.usersRepository
  ) : super(InfoState(), [appRepository, returnsRepository, usersRepository]);

  @override
  InfoStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();
    await _checkNeedRefresh();
  }

  @override
  Future<void> loadData() async {
    final newVersionAvailable = await appRepository.newVersionAvailable;
    final user = await usersRepository.getUser();
    final pref = await appRepository.getPref();
    final buyers = await returnsRepository.getBuyers();
    final partners = await returnsRepository.getPartners();
    final acts = await returnsRepository.getActs();

    emit(state.copyWith(
      status: InfoStateStatus.dataLoaded,
      newVersionAvailable: newVersionAvailable,
      user: user,
      pref: pref,
      buyers: buyers,
      partners: partners,
      acts: acts,
    ));
  }

  Future<void> getData() async {
    if (state.isBusy) return;

    emit(state.copyWith(status: InfoStateStatus.inProgress, isBusy: true));

    try {
      await usersRepository.loadUserData();
      await appRepository.loadData();

      emit(state.copyWith(status: InfoStateStatus.success, message: 'Данные успешно обновлены', isBusy: false));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message, isBusy: false));
    }
  }

  Future<void> _checkNeedRefresh() async {
    if (state.isBusy) return;

    if (state.pref?.lastSyncTime == null) {
      emit(state.copyWith(status: InfoStateStatus.startLoad));
      return;
    }

    final lastAttempt = state.pref!.lastSyncTime!;
    final time = DateTime.now();

    if (lastAttempt.year != time.year || lastAttempt.month != time.month || lastAttempt.day != time.day) {
      emit(state.copyWith(status: InfoStateStatus.startLoad));
    }
  }
}
