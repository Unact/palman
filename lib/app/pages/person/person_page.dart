import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
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
    super.key
  });

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
  void dispose() {
    progressDialog.close();
    super.dispose();
  }

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
          case PersonStateStatus.success:
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
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 24, bottom: 24),
      children: [
        InfoRow.page(
          title: const Text('Логин', style: Styles.formStyle),
          trailing: Text(state.username, style: Styles.formStyle)
        ),
        InfoRow.page(
          title: const Text('Торговый представитель', style: Styles.formStyle),
          trailing: Text(state.salesmanName, style: Styles.formStyle)
        ),
        InfoRow.page(
          title: const Text('Данные загружены', style: Styles.formStyle),
          trailing: Text(
            state.appInfo?.lastLoadTime != null ?
              Format.dateTimeStr(state.appInfo?.lastLoadTime!) :
              'Загрузка не проводилась',
            style: Styles.formStyle
          )
        ),
        InfoRow.page(
          title: const Text('Отображать фото локально', style: Styles.formStyle),
          trailing: state.appInfo == null ? null : Checkbox(
            value: state.appInfo!.showLocalImage,
            onChanged: (newValue) => vm.updateShowLocalImage(newValue!)
          )
        ),
        InfoRow.page(
          title: const Text('Показывать нулевые цены', style: Styles.formStyle),
          trailing: state.appInfo == null ? null : Checkbox(
            value: !state.appInfo!.showWithPrice,
            onChanged: (newValue) => vm.updateShowWithPrice(!newValue!)
          )
        ),
        InfoRow.page(
          title: const Text('Версия', style: Styles.formStyle),
          trailing: FutureBuilder(
            future: Misc.fullVersion,
            builder: (context, snapshot) => Text(snapshot.data ?? '', style: Styles.formStyle),
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
                onPressed: vm.apiUnregister,
                child: const Text('Удалить аккаунт', style: Styles.formStyle),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  backgroundColor: Theme.of(context).colorScheme.primary
                ),
                onPressed: vm.apiLogout,
                child: const Text('Выйти', style: Styles.formStyle),
              )
            ]
          )
        )
      ]
    );
  }
}
