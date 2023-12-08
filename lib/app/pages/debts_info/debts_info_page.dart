import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/debts_repository.dart';
import '/app/repositories/users_repository.dart';
import '/app/widgets/widgets.dart';
import 'pre_encashment/pre_encashment_page.dart';

part 'debts_info_state.dart';
part 'debts_info_view_model.dart';

class DebtsInfoPage extends StatelessWidget {
  DebtsInfoPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DebtsInfoViewModel>(
      create: (context) => DebtsInfoViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<DebtsRepository>(context),
        RepositoryProvider.of<UsersRepository>(context)
      ),
      child: _DebtsInfoView(),
    );
  }
}

class _DebtsInfoView extends StatefulWidget {
  @override
  _DebtsInfoViewState createState() => _DebtsInfoViewState();
}

class _DebtsInfoViewState extends State<_DebtsInfoView> {
  late final progressDialog = ProgressDialog(context: context);

  @override
  void dispose() {
    progressDialog.close();
    super.dispose();
  }

  Future<void> showDepositConfirmationDialog() async {
    final vm = context.read<DebtsInfoViewModel>();
    final total = vm.state.filteredPreEncashmentExList
      .where((e) => !e.preEncashment.isNew)
      .fold<double>(0, (acc, e) => acc + (e.preEncashment.encSum ?? 0));
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Предупреждение'),
          content: SingleChildScrollView(child: ListBody(children: <Widget>[
            Text('Сдать инкассации на сумму ${Format.numberStr(total)} рублей?')
          ])),
          actions: <Widget>[
            TextButton(child: const Text(Strings.cancel), onPressed: () => Navigator.of(context).pop(false)),
            TextButton(child: const Text(Strings.ok), onPressed: () => Navigator.of(context).pop(true))
          ],
        );
      }
    ) ?? false;

    if (result) await vm.deposit();
  }

  Future<void> showCreatePreEncashmentConfirmationDialog(DebtEx debtEx) async {
    final vm = context.read<DebtsInfoViewModel>();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Внимание'),
          content: const SingleChildScrollView(child: ListBody(children: <Widget>[
            Text('Уже есть созданная инкассация по этому документу. Вы уверены, что хотите создать еще одну?')
          ])),
          actions: <Widget>[
            TextButton(child: const Text(Strings.no), onPressed: () => Navigator.of(context).pop(false)),
            TextButton(child: const Text(Strings.yes), onPressed: () => Navigator.of(context).pop(true))
          ],
        );
      }
    ) ?? false;

    if (result) await vm.createPreEncashment(debtEx);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DebtsInfoViewModel, DebtsInfoState>(
      builder: (context, state) {
        final vm = context.read<DebtsInfoViewModel>();

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(Strings.debtsInfoPageName),
              actions: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.money),
                  tooltip: 'Сдать выручку',
                  onPressed: state.canDeposit ? showDepositConfirmationDialog : null
                ),
                SaveButton(
                  onSave: state.isLoading ? null : vm.syncChanges,
                  pendingChanges: vm.state.pendingChanges,
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(child: Text('Долги', style: Styles.tabStyle, softWrap: false)),
                  Tab(child: Text('Инкассации', style: Styles.tabStyle, softWrap: false)),
                  Tab(child: Text('Передачи', style: Styles.tabStyle, softWrap: false)),
                ],
              ),
            ),
            body: Refreshable(
              pendingChanges: vm.state.pendingChanges,
              onRefresh: vm.getData,
              childBuilder: (context, physics) => TabBarView(
                children: [
                  buildDebtListView(context, physics),
                  buildEncashmentListView(context, physics),
                  buildDepositListView(context, physics)
                ],
              ),
            ),
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case DebtsInfoStateStatus.encashmentCreateConfirmation:
          WidgetsBinding.instance.addPostFrameCallback((_) {
              showCreatePreEncashmentConfirmationDialog(state.newPreEncashmentDebtEx!);
            });
            break;
          case DebtsInfoStateStatus.encashmentAdded:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openPreEncashmentPage(state.newPreEncashment!);
            });
            break;
          case DebtsInfoStateStatus.depositInProgress:
            progressDialog.open();
            break;
          case DebtsInfoStateStatus.depositSuccess:
          case DebtsInfoStateStatus.depositFailure:
            progressDialog.close();
            Misc.showMessage(context, state.message);
            break;
          default:
        }
      },
    );
  }

  Widget buildDepositListView(BuildContext context, ScrollPhysics physics) {
    final vm = context.read<DebtsInfoViewModel>();

    return ListView(
      physics: physics,
      padding: const EdgeInsets.only(top: 16),
      children: vm.state.deposits.map((e) => buildDepositTile(context, e)).toList()
    );
  }

  Widget buildEncashmentListView(BuildContext context, ScrollPhysics physics) {
    final vm = context.read<DebtsInfoViewModel>();

    return ListView(
      physics: physics,
      children: vm.state.filteredPreEncashmentExList.map((e) => buildEncashmentTile(context, e)).toList()
    );
  }

  Widget buildDebtListView(BuildContext context, ScrollPhysics physics) {
    final vm = context.read<DebtsInfoViewModel>();

    final partnerDebt = vm.state.debtExList
      .groupFoldBy<Partner, List<DebtEx>>((e) => e.partner, (acc, e) => (acc ?? [])..add(e));

    return ListView(
      physics: physics,
      children: partnerDebt.entries.map((e) => buildDebtPartnerTile(context, e.key, e.value)).toList()
    );
  }

  Widget buildDepositTile(BuildContext context, Deposit deposit) {
    return ListTile(
      title: Text(Format.dateStr(deposit.date), style: Styles.tileTitleText),
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Выручка всего: ${Format.numberStr(deposit.totalSum)}\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: 'Выручка ККМ: ${Format.numberStr(deposit.checkTotalSum)}\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            )
          ]
        )
      ),
      dense: false,
    );
  }

  Widget buildEncashmentTile(BuildContext context, PreEncashmentEx preEncashmentEx) {
    final vm = context.read<DebtsInfoViewModel>();

    return Dismissible(
      key: Key(preEncashmentEx.hashCode.toString()),
      background: Container(color: Colors.red[500]),
      onDismissed: (direction) => vm.deletePreEncashment(preEncashmentEx),
      confirmDismiss: (direction) => ConfirmationDialog(
        context: context,
        confirmationText: 'Вы точно хотите удалить инкассацию?'
      ).open(),
      child: ListTile(
        title: Text(preEncashmentEx.buyer.name, style: Styles.tileTitleText),
        subtitle: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Документ: ${preEncashmentEx.debt.info}\n',
                style: Styles.tileText
              ),
              TextSpan(
                text: 'Дата: ${Format.dateStr(preEncashmentEx.preEncashment.date)}\n',
                style: Styles.tileText
              ),
              TextSpan(
                text: 'Сумма: ${Format.numberStr(preEncashmentEx.preEncashment.encSum)}\n',
                style: Styles.tileText
              )
            ]
          )
        ),
        dense: false,
        onTap: () => openPreEncashmentPage(preEncashmentEx)
      )
    );
  }

  Widget buildDebtTile(BuildContext context, DebtEx debtEx) {
    final vm = context.read<DebtsInfoViewModel>();

    return ListTile(
      title: Text(Format.dateStr(debtEx.debt.date), style: Styles.tileTitleText),
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Документ: ${debtEx.debt.info}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Сумма: ${Format.numberStr(debtEx.debt.orderSum)}\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: 'Задолженность: ${Format.numberStr(debtEx.debt.debtSum)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Оплата до: ${Format.dateStr(debtEx.debt.dateUntil)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: debtEx.debt.overdue ? 'Просрочено\n' : '',
              style: Styles.tileText.copyWith(color: Colors.red)
            )
          ]
        )
      ),
      dense: false,
      onTap: debtEx.debt.debtSum > 0 ? () => vm.tryCreatePreEncashment(debtEx) : null,
    );
  }

  Widget buildDebtPartnerTile(BuildContext context, Partner partner, List<DebtEx> debtExList) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(partner.name, style: const TextStyle(color: Colors.black)),
      children: debtExList.map((e) => buildDebtTile(context, e)).toList()
    );
  }

  Future<void> openPreEncashmentPage(PreEncashmentEx preEncashmentEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PreEncashmentPage(preEncashmentEx: preEncashmentEx),
        fullscreenDialog: false
      )
    );
  }
}
