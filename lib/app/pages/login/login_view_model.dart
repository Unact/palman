part of 'login_page.dart';

class LoginViewModel extends PageViewModel<LoginState, LoginStateStatus> {
  final UsersRepository usersRepository;

  LoginViewModel(this.usersRepository) : super(LoginState());

  @override
  LoginStateStatus get status => state.status;

  Future<void> apiLogin(String url, String login, String password) async {
    if (!state.optsEnabled) login = _formatLogin(login);

    if (password == Strings.optsPasswordKeyword && login == Strings.optsLoginKeyword) {
      emit(state.copyWith(
        status: LoginStateStatus.urlFieldActivated,
        optsEnabled: true
      ));

      return;
    }

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
      url: url,
      status: LoginStateStatus.inProgress
    ));

    try {
      await usersRepository.login(url, login, password);

      emit(state.copyWith(status: LoginStateStatus.success));
    } on AppError catch(e) {
      emit(state.copyWith(status: LoginStateStatus.failure, message: e.message));
    }
  }

  Future<void> getNewPassword(String url, String login) async {
    if (!state.optsEnabled) login = _formatLogin(login);

    if (login == '') {
      emit(state.copyWith(status: LoginStateStatus.failure, message: 'Не заполнено поле с логином'));
      return;
    }

    emit(state.copyWith(
      login: login,
      password: '',
      url: url,
      status: LoginStateStatus.inProgress
    ));

    try {
      await usersRepository.resetPassword(url, login);
      emit(state.copyWith(status: LoginStateStatus.passwordSent, message: 'Пароль отправлен на почту'));
    } on AppError catch(e) {
      emit(state.copyWith(status: LoginStateStatus.failure, message: e.message));
    }
  }

  String _formatLogin(String login) {
    return login.replaceAll(RegExp(r'[+\s\(\)-]'), '').replaceFirst('7', '8');
  }
}
