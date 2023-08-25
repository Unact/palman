part of 'person_page.dart';

class PersonViewModel extends PageViewModel<PersonState, PersonStateStatus> {
  static const String _kManifestRepoUrl = 'https://unact.github.io/mobile_apps/palman';
  static const String _kAppRepoUrl = 'https://github.com/Unact/palman';
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  final PointsRepository pointsRepository;
  final UsersRepository usersRepository;

  PersonViewModel(this.appRepository, this.ordersRepository, this.pointsRepository, this.usersRepository) :
    super(PersonState(), [appRepository, ordersRepository, pointsRepository, usersRepository]);

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

  Future<void> updateShowLocalImage(bool newValue) async {
    await appRepository.updatePref(showLocalImage: Optional.of(newValue));
  }

  Future<void> apiLogout() async {
    emit(state.copyWith(status: PersonStateStatus.inProgress));

    try {
      await usersRepository.logout();
      await pointsRepository.clearFiles();
      await ordersRepository.clearFiles();
      await appRepository.clearData();

      emit(state.copyWith(status: PersonStateStatus.loggedOut));
    } on AppError catch(e) {
      emit(state.copyWith(status: PersonStateStatus.failure, message: e.message));
    }
  }

  Future<void> launchAppUpdate() async {
    final version = state.user!.version;
    final androidUpdateUrl = '$_kAppRepoUrl/releases/download/$version/app-release.apk';
    const iosUpdateUrl = 'itms-services://?action=download-manifest&url=$_kManifestRepoUrl/manifest.plist';
    final uri = Uri.parse(Platform.isIOS ? iosUpdateUrl : androidUpdateUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      emit(state.copyWith(status: PersonStateStatus.failure, message: Strings.genericErrorMsg));
    }
  }
}
