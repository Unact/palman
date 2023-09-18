import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/orders_repository.dart';
import '/app/repositories/points_repository.dart';
import '/app/repositories/users_repository.dart';

part 'person_state.dart';
part 'person_view_model.dart';

class PersonPage extends StatelessWidget {
  PersonPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonViewModel>(
      create: (context) => PersonViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<OrdersRepository>(context),
        RepositoryProvider.of<PointsRepository>(context),
        RepositoryProvider.of<UsersRepository>(context),
      ),
      child: _PersonView(),
    );
  }
}

class _PersonView extends StatefulWidget {
  @override
  _PersonViewState createState() => _PersonViewState();
}

class _PersonViewState extends State<_PersonView> {
  late final ProgressDialog progressDialog = ProgressDialog(context: context);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonViewModel, PersonState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Пользователь'),
          ),
          body: buildBody(context)
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case PersonStateStatus.inProgress:
            await progressDialog.open();
            break;
          case PersonStateStatus.failure:
            Misc.showMessage(context, state.message);
            break;
          case PersonStateStatus.loggedOut:
            progressDialog.close();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            break;
          default:
        }
      },
    );
  }

  Widget buildBody(BuildContext context) {
    final vm = context.read<PersonViewModel>();
    final state = vm.state;

    return ListView(
      padding: const EdgeInsets.only(top: 24, bottom: 24),
      children: [
        InfoRow(title: const Text('Логин'), trailing: Text(state.username)),
        InfoRow(title: const Text('Торговый представитель'), trailing: Text(state.salesmanName)),
        InfoRow(
          title: const Text('Данные загружены'),
          trailing: Text(
            state.pref?.lastSyncTime != null ?
              Format.dateTimeStr(state.pref?.lastSyncTime!) :
              'Загрузка не проводилась'
          )
        ),
        InfoRow(
          title: const Text('Отображать фото локально'),
          trailing: state.pref == null ? null : Checkbox(
            value: state.pref!.showLocalImage,
            onChanged: (newValue) => vm.updateShowLocalImage(newValue!)
          )
        ),
        InfoRow(
          title: const Text('Показывать нулевые цены'),
          trailing: state.pref == null ? null : Checkbox(
            value: !state.pref!.showWithPrice,
            onChanged: (newValue) => vm.updateShowWithPrice(!newValue!)
          )
        ),
        InfoRow(title: const Text('Версия'), trailing: Text(state.fullVersion)),
        !state.newVersionAvailable ? Container() : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  backgroundColor: Theme.of(context).colorScheme.primary
                ),
                onPressed: vm.launchAppUpdate,
                child: const Text('Обновить приложение'),
              )
            ],
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  backgroundColor: Theme.of(context).colorScheme.primary
                ),
                onPressed: vm.apiLogout,
                child: const Text('Выйти', style: TextStyle(color: Colors.white)),
              )
            ]
          )
        )
      ]
    );
  }
}
