part of 'landing_page.dart';

class LandingViewModel extends PageViewModel<LandingState, LandingStateStatus> {
  final UsersRepository usersRepository;
  StreamSubscription<bool>? isLoggedInSubscription;

  LandingViewModel(this.usersRepository) : super(LandingState());

  @override
  LandingStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    isLoggedInSubscription = usersRepository.isLoggedIn.listen((event) {
      emit(state.copyWith(status: LandingStateStatus.dataLoaded, isLoggedIn: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await isLoggedInSubscription?.cancel();
  }
}
