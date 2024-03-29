part of 'person_page.dart';

class PersonViewModel extends PageViewModel<PersonState, PersonStateStatus> {
  final AppRepository appRepository;
  final UsersRepository usersRepository;

  PersonViewModel(this.appRepository, this.usersRepository) : super(PersonState(), [appRepository, usersRepository]);

  @override
  PersonStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final user = await usersRepository.getUser();
    final pref = await appRepository.getPref();
    final fullVersion = await appRepository.fullVersion;
    final newVersionAvailable = await appRepository.newVersionAvailable;

    emit(state.copyWith(
      status: PersonStateStatus.dataLoaded,
      user: user,
      pref: pref,
      fullVersion: fullVersion,
      newVersionAvailable: newVersionAvailable
    ));
  }

  Future<void> apiLogout() async {
    emit(state.copyWith(status: PersonStateStatus.inProgress));

    try {
      await usersRepository.logout();
      await appRepository.clearData();

      emit(state.copyWith(status: PersonStateStatus.loggedOut));
    } on AppError catch(e) {
      emit(state.copyWith(status: PersonStateStatus.failure, message: e.message));
    }
  }

  Future<void> launchAppUpdate() async {
    Misc.launchAppUpdate(
      repoName: Strings.repoName,
      version: state.user!.version,
      onError: () => emit(state.copyWith(status: PersonStateStatus.failure, message: Strings.genericErrorMsg))
    );
  }
}
