part of 'landing_page.dart';

class LandingViewModel extends PageViewModel<LandingState, LandingStateStatus> {
  final AppRepository appRepository;
  final UsersRepository usersRepository;

  LandingViewModel(this.appRepository, this.usersRepository) : super(LandingState(), [appRepository, usersRepository]);

  @override
  LandingStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final isLoggedIn = usersRepository.isLoggedIn;

    emit(state.copyWith(
      status: LandingStateStatus.dataLoaded,
      isLoggedIn: isLoggedIn
    ));
  }
}
