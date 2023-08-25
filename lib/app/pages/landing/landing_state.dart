part of 'landing_page.dart';

enum LandingStateStatus {
  initial,
  dataLoaded
}

class LandingState {
  LandingState({
    this.status = LandingStateStatus.initial,
    this.isLoggedIn = false
  });

  final bool isLoggedIn;
  final LandingStateStatus status;

  LandingState copyWith({
    LandingStateStatus? status,
    bool? isLoggedIn
  }) {
    return LandingState(
      status: status ?? this.status,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn
    );
  }
}
