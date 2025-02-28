import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/users_repository.dart';

part 'login_state.dart';
part 'login_view_model.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginViewModel>(
      create: (context) => LoginViewModel(
        RepositoryProvider.of<UsersRepository>(context),
      ),
      child: _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  late final ProgressDialog progressDialog = ProgressDialog(context: context);
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final TextEditingController urlController = TextEditingController(
    text: context.read<LoginViewModel>().state.url
  );

  @override
  void dispose() {
    progressDialog.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginViewModel, LoginState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildLoginFields(context)
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case LoginStateStatus.urlFieldActivated:
            loginController.text = '';
            passwordController.text = '';
            break;
          case LoginStateStatus.passwordSent:
          case LoginStateStatus.failure:
            Misc.showMessage(context, state.message);
            progressDialog.close();
            break;
          case LoginStateStatus.loggedIn:
            progressDialog.close();
            break;
          case LoginStateStatus.inProgress:
            await progressDialog.open();
            break;
          default:
        }
      },
    );
  }

  Widget loginField(BuildContext context) {
    final vm = context.read<LoginViewModel>();

    if (vm.state.optsEnabled) {
      return TextField(
        controller: loginController,
        keyboardType: TextInputType.url,
        decoration: const InputDecoration(labelText: 'Телефон или e-mail или login'),
        style: Styles.formStyle,
      );
    }

    return TextField(
      controller: loginController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Телефон',
        hintText: '+7 (###) ###-##-##'
      ),
      inputFormatters: [
        MaskTextInputFormatter(
          mask: '+7 (###) ###-##-##',
          filter: { "#": RegExp(r'[0-9]') },
          type: MaskAutoCompletionType.lazy
        )
      ],
      style: Styles.formStyle,
    );
  }

  Widget passwordField(BuildContext context) {
    return TextField(
      controller: passwordController,
      keyboardType: TextInputType.number,
      obscureText: true,
      style: Styles.formStyle,
      decoration: const InputDecoration(labelText: 'Пароль')
    );
  }

  Widget urlField(BuildContext context) {
    final vm = context.read<LoginViewModel>();

    if (vm.state.optsEnabled) {
      return TextField(
        controller: urlController,
        keyboardType: TextInputType.url,
        style: Styles.formStyle,
        decoration: const InputDecoration(labelText: 'Url')
      );
    }

    return Container();
  }

  List<Widget> buildLoginFields(BuildContext context) {
    final vm = context.read<LoginViewModel>();

    return [
      loginField(context),
      passwordField(context),
      urlField(context),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  Misc.unfocus(context);
                  vm.apiLogin(urlController.text, loginController.text, passwordController.text);
                },
                child: const Text('Войти', style: Styles.formStyle),
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  Misc.unfocus(context);
                  vm.getNewPassword(urlController.text, loginController.text);
                },
                child: const Text('Получить пароль', textAlign: TextAlign.center, style: Styles.formStyle),
              ),
            )
          ),
        ],
      ),
    ];
  }
}
