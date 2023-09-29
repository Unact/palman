part of 'home_page.dart';

class HomeViewModel extends PageViewModel<HomeState, HomeStateStatus> {
  HomeViewModel() : super(HomeState());

  @override
  HomeStateStatus get status => state.status;

  void setCurrentIndex(int currentIndex) {
    emit(state.copyWith(currentIndex: currentIndex));
  }
}
