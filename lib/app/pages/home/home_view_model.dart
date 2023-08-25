part of 'home_page.dart';

class HomeViewModel extends PageViewModel<HomeState, HomeStateStatus> {
  HomeViewModel() : super(HomeState());

  @override
  HomeStateStatus get status => state.status;

  @override
  Future<void> loadData() async {}

  void setCurrentIndex(int currentIndex) {
    if (!state.pageChangeable) return;

    emit(state.copyWith(currentIndex: currentIndex));
  }

  void setPageChangeable(bool pageChangeable) {
    emit(state.copyWith(pageChangeable: pageChangeable));
  }
}
