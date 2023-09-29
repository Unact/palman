import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/pages/home/home_page.dart';
import '/app/pages/login/login_page.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/users_repository.dart';

part 'landing_state.dart';
part 'landing_view_model.dart';

class LandingPage extends StatelessWidget {
  LandingPage({
    Key? key
  }) : super(key: key);

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

class _LandingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingViewModel, LandingState>(
      builder: (context, state) {
        return state.isLoggedIn ? HomePage() : LoginPage();
      }
    );
  }
}
