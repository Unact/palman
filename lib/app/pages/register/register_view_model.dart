part of 'register_page.dart';

class RegisterViewModel extends PageViewModel<RegisterState, RegisterStateStatus> {
  final UsersRepository usersRepository;

  RegisterViewModel(this.usersRepository) : super(RegisterState());

  @override
  RegisterStateStatus get status => state.status;

  Future<void> apiRegister(String email, String telNum, String password) async {
    if (email == '') {
      emit(state.copyWith(status: RegisterStateStatus.failure, message: 'Не заполнено поле с email'));
      return;
    }

    if (telNum == '') {
      emit(state.copyWith(status: RegisterStateStatus.failure, message: 'Не заполнено поле с телефоном'));
      return;
    }

    if (password == '') {
      emit(state.copyWith(status: RegisterStateStatus.failure, message: 'Не заполнено поле с паролем'));
      return;
    }

    emit(state.copyWith(
      email: email,
      password: password,
      telNum: telNum,
      status: RegisterStateStatus.inProgress
    ));

    try {
      await usersRepository.register(const String.fromEnvironment('PALMAN_RENEW_URL'), email, telNum, password);

      emit(state.copyWith(status: RegisterStateStatus.success));
    } on AppError catch(e) {
      emit(state.copyWith(status: RegisterStateStatus.failure, message: e.message));
    }
  }
}
