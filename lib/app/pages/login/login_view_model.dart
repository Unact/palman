part of 'login_page.dart';

class LoginViewModel extends PageViewModel<LoginState, LoginStateStatus> {
  final UsersRepository usersRepository;

  LoginViewModel(this.usersRepository) : super(LoginState());

  @override
  LoginStateStatus get status => state.status;

  Future<void> apiLogin(String login, String password) async {
    login = _formatLogin(login);

    if (login == '') {
      emit(state.copyWith(status: LoginStateStatus.failure, message: 'Не заполнено поле с логином'));
      return;
    }

    if (password == '') {
      emit(state.copyWith(status: LoginStateStatus.failure, message: 'Не заполнено поле с паролем'));
      return;
    }

    emit(state.copyWith(
      login: login,
      password: password,
      status: LoginStateStatus.inProgress
    ));

    try {
      await usersRepository.login(login, password);

      emit(state.copyWith(status: LoginStateStatus.success));
    } on AppError catch(e) {
      emit(state.copyWith(status: LoginStateStatus.failure, message: e.message));
    }
  }

  Future<void> getNewPassword(String login) async {
    login = _formatLogin(login);

    if (login == '') {
      emit(state.copyWith(status: LoginStateStatus.failure, message: 'Не заполнено поле с логином'));
      return;
    }

    emit(state.copyWith(
      login: login,
      password: '',
      status: LoginStateStatus.inProgress
    ));

    try {
      await usersRepository.resetPassword(login);
      emit(state.copyWith(status: LoginStateStatus.passwordSent, message: 'Пароль отправлен на почту'));
    } on AppError catch(e) {
      emit(state.copyWith(status: LoginStateStatus.failure, message: e.message));
    }
  }

  String _formatLogin(String login) {
    return login.replaceAll(RegExp(r'[+\s\(\)-]'), '').replaceFirst('7', '8');
  }
}
