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
    this.pref,
    this.fullVersion = '',
    this.newVersionAvailable = false,
    this.message = '',
  });

  final String message;
  final User? user;
  final Pref? pref;
  final String fullVersion;
  final bool newVersionAvailable;
  final PersonStateStatus status;

  String get username => user?.username ?? '';
  String get salesmanName => user?.salesmanName ?? '';

  PersonState copyWith({
    PersonStateStatus? status,
    User? user,
    Pref? pref,
    String? fullVersion,
    bool? newVersionAvailable,
    String? message
  }) {
    return PersonState(
      status: status ?? this.status,
      user: user ?? this.user,
      pref: pref ?? this.pref,
      fullVersion: fullVersion ?? this.fullVersion,
      newVersionAvailable: newVersionAvailable ?? this.newVersionAvailable,
      message: message ?? this.message,
    );
  }
}
