part of 'landing_page.dart';

enum LandingStateStatus {
  initial,
  dataLoaded,
  viewChanged
}

enum UserView {
  login,
  register,
  none
}

class LandingState {
  LandingState({
    this.status = LandingStateStatus.initial,
    this.isLoggedIn = false,
    this.currentUserView = UserView.none
  });

  final bool isLoggedIn;
  final LandingStateStatus status;
  final UserView currentUserView;


  LandingState copyWith({
    LandingStateStatus? status,
    bool? isLoggedIn,
    UserView? currentUserView
  }) {
    return LandingState(
      status: status ?? this.status,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      currentUserView: currentUserView ?? this.currentUserView
    );
  }
}
