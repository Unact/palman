import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/orders_repository.dart';

part 'bonus_programs_state.dart';
part 'bonus_programs_view_model.dart';

class BonusProgramsPage extends StatelessWidget {
  final DateTime date;
  final Buyer buyer;
  final CategoriesExResult? categoryEx;
  final GoodsExResult? goodsEx;

  BonusProgramsPage({
    required this.date,
    required this.buyer,
    required this.categoryEx,
    required this.goodsEx,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BonusProgramsViewModel>(
      create: (context) => BonusProgramsViewModel(
        date: date,
        buyer: buyer,
        categoryEx: categoryEx,
        goodsEx: goodsEx,
        RepositoryProvider.of<OrdersRepository>(context),
      ),
      child: _BonusProgramsView(),
    );
  }
}

class _BonusProgramsView extends StatefulWidget {
  @override
  _BonusProgramsViewState createState() => _BonusProgramsViewState();
}

class _BonusProgramsViewState extends State<_BonusProgramsView> {
  late final ProgressDialog progressDialog = ProgressDialog(context: context);

  @override
  void dispose() {
    progressDialog.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BonusProgramsViewModel, BonusProgramsState>(
      builder: (context, state) {
        final vm = context.read<BonusProgramsViewModel>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Выберите акцию'),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(72.0),
              child: buildHeader(context)
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.only(top: 8),
            children: vm.state.bonusPrograms.map((e) => buildBonusProgramTile(context, e)).toList()
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case BonusProgramsStateStatus.searchStarted:
            await progressDialog.open();
            break;
          case BonusProgramsStateStatus.searchFinished:
            progressDialog.close();
            break;
          default:
        }
      }
    );
  }

  Widget buildBonusProgramTile(BuildContext context, FilteredBonusProgramsResult bonusProgram) {
    return ListTile(
      title: Text(bonusProgram.name, style: Styles.tileTitleText),
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Выполни: ${bonusProgram.condition}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Получи: ${bonusProgram.present}\n',
              style: Styles.tileText
            ),
          ]
        )
      ),
      onTap: () {
        Navigator.of(context).pop(bonusProgram);
      },
    );
  }

  Widget buildHeader(BuildContext context) {
    final vm = context.read<BonusProgramsViewModel>();

    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 144,
            child: CheckboxListTile(
              title: const Text('Группа', style: Styles.formStyle),
              value: vm.state.filterByCategory,
              onChanged: vm.changeFilterByCategory
            )
          ),
          SizedBox(
            width: 156,
            child: DropdownButton<BonusProgramGroup?>(
              isExpanded: true,
              style: Theme.of(context).textTheme.titleMedium!.merge(Styles.formStyle),
              value: vm.state.selectedBonusProgramGroup,
              items: [
                const DropdownMenuItem<BonusProgramGroup?>(value: null, child: Text('Все')),
                ...vm.state.bonusProgramGroups.map<DropdownMenuItem<BonusProgramGroup>>((BonusProgramGroup v) {
                  return DropdownMenuItem<BonusProgramGroup>(value: v, child: Text(v.name, softWrap: false));
                })
              ],
              onChanged: vm.changeSelectedBonusProgramGroup
            )
          )
        ],
      ),
    );
  }
}
