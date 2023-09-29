part of 'home_page.dart';

enum HomeStateStatus {
  initial,
}

class HomeState {
  HomeState({
    this.status = HomeStateStatus.initial,
    this.currentIndex = 0
  });

  final HomeStateStatus status;
  final int currentIndex;

  HomeState copyWith({
    HomeStateStatus? status,
    int? currentIndex
  }) {
    return HomeState(
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex
    );
  }
}
