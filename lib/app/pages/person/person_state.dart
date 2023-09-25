part of 'person_page.dart';

enum PersonStateStatus {
  initial,
  dataLoaded,
  inProgress,
  loggedOut,
  failure
}

class PersonState {
  PersonState({
    this.status = PersonStateStatus.initial,
    this.user,
    this.appInfo,
    this.message = '',
  });

  final String message;
  final User? user;
  final AppInfoResult? appInfo;
  final PersonStateStatus status;

  String get username => user?.username ?? '';
  String get salesmanName => user?.salesmanName ?? '';

  PersonState copyWith({
    PersonStateStatus? status,
    User? user,
    AppInfoResult? appInfo,
    String? message
  }) {
    return PersonState(
      status: status ?? this.status,
      user: user ?? this.user,
      appInfo: appInfo ?? this.appInfo,
      message: message ?? this.message,
    );
  }
}
