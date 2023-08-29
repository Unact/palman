import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/debts_repository.dart';
import '/app/utils/format.dart';
import '/app/utils/extensions.dart';
import 'encashment/encashment_page.dart';

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
  Future<void> showDepositConfirmationDialog() async {
    final vm = context.read<DebtsInfoViewModel>();
    final encWithoutDeposit = vm.state.encashmentExList.where((e) => e.deposit == null);
    final total = encWithoutDeposit.fold<double>(0, (acc, e) => acc + (e.encashment.encSum ?? 0));
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
            TextButton(child: const Text(Strings.ok), onPressed: () => Navigator.of(context).pop(true)),
            TextButton(child: const Text(Strings.cancel), onPressed: () => Navigator.of(context).pop(false))
          ],
        );
      }
    ) ?? false;

    if (result) await vm.createDeposit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DebtsInfoViewModel, DebtsInfoState>(
      builder: (context, state) {
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
                )
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Долги'),
                  Tab(text: 'Инкассации'),
                  Tab(text: 'Передачи'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                buildDebtListView(context),
                buildEncashmentListView(context),
                buildDepositListView(context)
              ],
            ),
          ),
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case DebtsInfoStateStatus.encashmentAdded:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openEncashmentPage(state.newEncashment!);
            });
            break;
          default:
        }
      },
    );
  }

  Widget buildDepositListView(BuildContext context) {
    final vm = context.read<DebtsInfoViewModel>();

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: vm.state.deposits.map((e) => buildDepositTile(context, e)).toList()
    );
  }

  Widget buildEncashmentListView(BuildContext context) {
    final vm = context.read<DebtsInfoViewModel>();
    final List<Widget> children = [];

    if (vm.state.encWithoutDeposit.isNotEmpty) {
      children.add(ExpansionTile(
        initiallyExpanded: true,
        title: const Text('Не сдано'),
        children: vm.state.encWithoutDeposit.map((e) => buildEncashmentTile(context, e)).toList()
      ));
    }

    if (vm.state.encWithDeposit.isNotEmpty) {
      children.add(ExpansionTile(
        initiallyExpanded: true,
        title: const Text('Сдано'),
        children: vm.state.encWithDeposit.map((e) => buildEncashmentTile(context, e)).toList()
      ));
    }

    return ListView(children: children);
  }

  Widget buildDebtListView(BuildContext context) {
    final vm = context.read<DebtsInfoViewModel>();

    final partnerDebt = vm.state.debtExList
      .groupFoldBy<Partner, List<DebtEx>>((e) => e.partner, (acc, e) => (acc ?? [])..add(e));

    return ListView(
      children: partnerDebt.entries.map((e) => buildDebtPartnerTile(context, e.key, e.value)).toList()
    );
  }

  Widget buildDepositTile(BuildContext context, Deposit deposit) {
    return ListTile(
      title: Text(Format.dateStr(deposit.date)),
      trailing: deposit.needSync ? const Icon(Icons.sync, color: Colors.red) : null,
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
          children: <TextSpan>[
            TextSpan(
              text: 'Выручка всего: ${Format.numberStr(deposit.totalSum)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Выручка ККМ: ${Format.numberStr(deposit.checkTotalSum)}\n',
              style: Styles.tileText
            )
          ]
        )
      ),
      dense: false,
    );
  }

  Widget buildEncashmentTile(BuildContext context, EncashmentEx encashmentEx) {
    return encashmentEx.deposit == null ?
      buildEncashmentWithoutDepositTile(context, encashmentEx) :
      buildEncashmentWithDepositTile(context, encashmentEx);
  }

  Widget buildEncashmentWithDepositTile(BuildContext context, EncashmentEx encashmentEx) {
    return ListTile(
      title: Text(encashmentEx.buyer.name),
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
          children: <TextSpan>[
            TextSpan(
              text: 'Дата: ${Format.dateStr(encashmentEx.encashment.date)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Сумма: ${Format.numberStr(encashmentEx.encashment.encSum)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Сдана: ${Format.dateStr(encashmentEx.deposit!.date)}\n',
              style: Styles.tileText.copyWith(color: Colors.green)
            ),
          ]
        )
      ),
      dense: false
    );
  }

  Widget buildEncashmentWithoutDepositTile(BuildContext context, EncashmentEx encashmentEx) {
    final vm = context.read<DebtsInfoViewModel>();

    return Dismissible(
      key: Key(encashmentEx.hashCode.toString()),
      background: Container(color: Colors.red[500]),
      onDismissed: (direction) => vm.deleteEncashment(encashmentEx),
      child: ListTile(
        title: Text(encashmentEx.buyer.name),
        subtitle: RichText(
          text: TextSpan(
            style: Styles.defaultTextSpan,
            children: <TextSpan>[
              TextSpan(
                text: 'Дата: ${Format.dateStr(encashmentEx.encashment.date)}\n',
                style: Styles.tileText
              ),
              TextSpan(
                text: 'Сумма: ${Format.numberStr(encashmentEx.encashment.encSum)}\n',
                style: Styles.tileText
              )
            ]
          )
        ),
        dense: false,
        onTap: () => openEncashmentPage(encashmentEx)
      )
    );
  }

  Widget buildDebtTile(BuildContext context, DebtEx debtEx) {
    final vm = context.read<DebtsInfoViewModel>();

    return ListTile(
      title: Text(Format.dateStr(debtEx.debt.date)),
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
          children: <TextSpan>[
            TextSpan(
              text: 'Документ: ${debtEx.debt.info}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Сумма: ${Format.numberStr(debtEx.debt.orderSum)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Задолженность: ${Format.numberStr(debtEx.debt.debtSum)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Оплата до: ${Format.dateStr(debtEx.debt.dateUntil)}\n',
              style: Styles.tileText
            )
          ]
        )
      ),
      dense: false,
      onTap: debtEx.debt.debtSum > 0 ? () => vm.createEncashment(debtEx) : null,
    );
  }

  Widget buildDebtPartnerTile(BuildContext context, Partner partner, List<DebtEx> debtExList) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(partner.name),
      children: debtExList.map((e) => buildDebtTile(context, e)).toList()
    );
  }

  Future<void> openEncashmentPage(EncashmentEx encashmentEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => EncashmentPage(encashmentEx: encashmentEx),
        fullscreenDialog: false
      )
    );
  }
}
