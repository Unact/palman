part of 'register_page.dart';

enum RegisterStateStatus {
  initial,
  failure,
  inProgress,
  success
}

class RegisterState {
  RegisterState({
    this.status = RegisterStateStatus.initial,
    this.email = '',
    this.telNum = '',
    this.password = '',
    this.message = ''
  });

  final String email;
  final String telNum;
  final String password;
  final RegisterStateStatus status;
  final String message;

  RegisterState copyWith({
    RegisterStateStatus? status,
    String? email,
    String? telNum,
    String? password,
    String? message
  }) {
    return RegisterState(
      status: status ?? this.status,
      email: email ?? this.email,
      telNum: telNum ?? this.telNum,
      password: password ?? this.password,
      message: message ?? this.message
    );
  }
}
