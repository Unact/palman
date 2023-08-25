part of 'home_page.dart';

enum HomeStateStatus {
  initial,
}

class HomeState {
  HomeState({
    this.status = HomeStateStatus.initial,
    this.currentIndex = 0,
    this.pageChangeable = true
  });

  final HomeStateStatus status;
  final int currentIndex;
  final bool pageChangeable;

  HomeState copyWith({
    HomeStateStatus? status,
    int? currentIndex,
    bool? pageChangeable
  }) {
    return HomeState(
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      pageChangeable: pageChangeable ?? this.pageChangeable
    );
  }
}
