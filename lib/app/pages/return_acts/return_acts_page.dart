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
import '/app/repositories/partners_repository.dart';
import '/app/repositories/return_acts_repository.dart';
import '/app/repositories/users_repository.dart';
import '/app/widgets/widgets.dart';
import 'return_act/return_act_page.dart';

part 'return_acts_state.dart';
part 'return_acts_view_model.dart';

class ReturnActsPage extends StatelessWidget {
  ReturnActsPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReturnActsViewModel>(
      create: (context) => ReturnActsViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<PartnersRepository>(context),
        RepositoryProvider.of<ReturnActsRepository>(context),
        RepositoryProvider.of<UsersRepository>(context),
      ),
      child: _ReturnActsView(),
    );
  }
}

class _ReturnActsView extends StatefulWidget {
  @override
  _ReturnActsViewState createState() => _ReturnActsViewState();
}

class _ReturnActsViewState extends State<_ReturnActsView> {
  final TextEditingController buyerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReturnActsViewModel, ReturnActsState>(
      builder: (context, state) {
        final vm = context.read<ReturnActsViewModel>();

        return Scaffold(
          appBar: AppBar(
            title: const Text(Strings.returnActsPageName),
            actions: [
              SaveButton(
                onSave: state.isLoading ? null : vm.syncChanges,
                pendingChanges: vm.state.pendingChanges,
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: vm.addNewReturnAct,
            child: const Icon(Icons.add),
          ),
          body: Refreshable(
            confirmRefresh: vm.state.pendingChanges != 0,
            onRefresh: vm.getData,
            onError: (error, stackTrace) {
              if (error is! AppError) Misc.reportError(error, stackTrace);
            },
            childBuilder: buildReturnActsView
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case ReturnActsStateStatus.returnActAdded:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openReturnActPage(state.newReturnAct!);
            });
            break;
          default:
        }
      },
    );
  }

  Widget buildReturnActsView(BuildContext context, ScrollPhysics physics) {
    return CustomScrollView(
      physics: physics,
      slivers: [
        SliverAppBar(
          centerTitle: true,
          pinned: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: buildReturnActsHeader(context),
        ),
        SliverList(delegate: buildReturnActsListView(context))
      ]
    );
  }

  Widget buildReturnActsHeader(BuildContext context) {
    final vm = context.read<ReturnActsViewModel>();

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: BuyerField(buyerExList: vm.state.buyerExList, onSelect: vm.selectBuyer, controller: buyerController)
    );
  }

  SliverChildDelegate buildReturnActsListView(BuildContext context) {
    final vm = context.read<ReturnActsViewModel>();

    final returnActDate = vm.state.filteredReturnActExList
      .groupFoldBy<DateTime?, List<ReturnActExResult>>((e) => e.returnAct.date, (acc, e) => (acc ?? [])..add(e));
    final returnActDateList = returnActDate.entries.sortedByCompare(
      (e) => e.key,
      (a, b) => a == null ? -1 : b == null ? 1 : b.compareTo(a)
    );

    return SliverChildListDelegate(
      returnActDateList.map((e) => buildReturnActDateTile(context, e.key, e.value)
    ).toList());
  }

  Widget buildReturnActDateTile(BuildContext context, DateTime? date, List<ReturnActExResult> returnActExList) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(date == null ? 'Дата не указана' : Format.dateStr(date)),
      children: returnActExList.map((e) => buildReturnActTile(context, e)).toList()
    );
  }

  Widget buildReturnActTile(BuildContext context, ReturnActExResult returnActEx) {
    final vm = context.read<ReturnActsViewModel>();
    final needSync = returnActEx.returnAct.needSync || returnActEx.linesNeedSync;
    final tile = ListTile(
      title: Text(
        returnActEx.buyer != null ? '${returnActEx.buyer!.fullname}\n' : 'Клиент не указан\n',
        style: Styles.tileTitleText
      ),
      trailing: needSync ? Icon(Icons.sync, color: Theme.of(context).colorScheme.primary) : null,
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: returnActEx.returnAct.number == null ?
                '${returnActEx.returnActTypeName}\n' :
                '${returnActEx.returnActTypeName} ${returnActEx.returnAct.number}\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: 'Сумма: ${Format.numberStr(returnActEx.linesTotal)}\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: 'Позиций: ${returnActEx.linesCount}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: !returnActEx.returnAct.needPickup ? 'Самовывоз\n' : '',
              style: Styles.tileText
            ),
            TextSpan(
              text: returnActEx.returnAct.receptName != null ? 'Накладная: ${returnActEx.returnAct.receptName}\n' : '',
              style: Styles.tileText
            )
          ]
        )
      ),
      dense: false,
      onTap: () => openReturnActPage(returnActEx),
    );

    if (!returnActEx.returnAct.isNew) return tile;

    return Dismissible(
      key: Key(returnActEx.hashCode.toString()),
      background: Container(color: Colors.red[500]),
      onDismissed: (direction) => vm.deleteReturnAct(returnActEx),
      confirmDismiss: (direction) => ConfirmationDialog(
        context: context,
        confirmationText: 'Вы точно хотите удалить возврат?'
      ).open(),
      child: tile
    );
  }

  Future<void> openReturnActPage(ReturnActExResult returnActEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ReturnActPage(returnActEx: returnActEx),
        fullscreenDialog: false
      )
    );
  }
}
