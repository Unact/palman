part of 'home_page.dart';

class HomeViewModel extends PageViewModel<HomeState, HomeStateStatus> {
  HomeViewModel() : super(HomeState());

  @override
  HomeStateStatus get status => state.status;

  void setCurrentIndex(int currentIndex) {
    if (!state.pageChangeable) return;

    emit(state.copyWith(currentIndex: currentIndex));
  }

  void setPageChangeable(bool pageChangeable) {
    emit(state.copyWith(pageChangeable: pageChangeable));
  }
}
