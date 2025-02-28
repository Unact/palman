import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/users_repository.dart';

part 'register_state.dart';
part 'register_view_model.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterViewModel>(
      create: (context) => RegisterViewModel(
        RepositoryProvider.of<UsersRepository>(context),
      ),
      child: _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  late final ProgressDialog progressDialog = ProgressDialog(context: context);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telNumController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    progressDialog.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterViewModel, RegisterState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildRegisterFields(context)
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case RegisterStateStatus.failure:
            Misc.showMessage(context, state.message);
            progressDialog.close();
            break;
          case RegisterStateStatus.success:
            progressDialog.close();
            break;
          case RegisterStateStatus.inProgress:
            await progressDialog.open();
            break;
          default:
        }
      },
    );
  }

  Widget emailField(BuildContext context) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.url,
      decoration: const InputDecoration(labelText: 'Email'),
      style: Styles.formStyle,
    );
  }

  Widget telNumField(BuildContext context) {
    return TextField(
      controller: telNumController,
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

  List<Widget> buildRegisterFields(BuildContext context) {
    final vm = context.read<RegisterViewModel>();

    return [
      emailField(context),
      telNumField(context),
      passwordField(context),
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
                  vm.apiRegister(emailController.text, telNumController.text, passwordController.text);
                },
                child: const Text('Создать', style: Styles.formStyle),
              ),
            )
          ),
        ],
      ),
    ];
  }
}
