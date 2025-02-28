import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/constants/styles.dart';
import '/app/constants/strings.dart';
import '/app/pages/home/home_page.dart';
import '/app/pages/login/login_page.dart';
import '/app/pages/register/register_page.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/users_repository.dart';

part 'landing_state.dart';
part 'landing_view_model.dart';

class LandingPage extends StatelessWidget {
  LandingPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LandingViewModel>(
      create: (context) => LandingViewModel(
        RepositoryProvider.of<UsersRepository>(context),
      ),
      child: _LandingView(),
    );
  }
}

class _LandingView extends StatefulWidget {
  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<_LandingView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingViewModel, LandingState>(
      builder: (context, state) {
        if (state.isLoggedIn) return HomePage();

        switch (state.currentUserView) {
          case UserView.none:
            return buildUserNoneView(context);
          case UserView.login:
            return buildUserLoginView(context);
          case UserView.register:
            return buildUserRegisterView(context);
        }
      }
    );
  }

  Widget buildUserLoginView(BuildContext context) {
    final vm = context.read<LandingViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Войти в приложение'),
        leading: BackButton(onPressed: () => vm.changeCurrentUserView(UserView.none))
      ),
      resizeToAvoidBottomInset: false,
      body: LoginPage()
    );
  }

  Widget buildUserRegisterView(BuildContext context) {
    final vm = context.read<LandingViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        leading: BackButton(onPressed: () => vm.changeCurrentUserView(UserView.none))
      ),
      resizeToAvoidBottomInset: false,
      body: RegisterPage()
    );
  }

  Widget buildUserNoneView(BuildContext context) {
    final vm = context.read<LandingViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.ruAppName),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => vm.changeCurrentUserView(UserView.login),
                    child: const Text('Войти', style: Styles.formStyle),
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => vm.changeCurrentUserView(UserView.register),
                    child: const Text('Зарегистрироваться', style: Styles.formStyle),
                  ),
                )
              ),
            ],
          )
        ],
      )
    );
  }
}
