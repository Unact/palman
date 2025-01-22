part of 'person_page.dart';

class PersonViewModel extends PageViewModel<PersonState, PersonStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  final PointsRepository pointsRepository;
  final UsersRepository usersRepository;
  StreamSubscription<User>? userSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  PersonViewModel(this.appRepository, this.ordersRepository, this.pointsRepository, this.usersRepository) :
    super(PersonState());

  @override
  PersonStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    userSubscription = usersRepository.watchUser().listen((event) {
      emit(state.copyWith(status: PersonStateStatus.dataLoaded, user: event));
    });
    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: PersonStateStatus.dataLoaded, appInfo: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await userSubscription?.cancel();
    await appInfoSubscription?.cancel();
  }

  Future<void> updateShowLocalImage(bool newValue) async {
    await appRepository.updatePref(showLocalImage: Optional.of(newValue));
  }

  Future<void> updateShowWithPrice(bool newValue) async {
    await appRepository.updatePref(showWithPrice: Optional.of(newValue));
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
}
