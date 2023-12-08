import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/debts_repository.dart';

part 'pre_encashment_state.dart';
part 'pre_encashment_view_model.dart';

class PreEncashmentPage extends StatelessWidget {
  final PreEncashmentEx preEncashmentEx;

  PreEncashmentPage({
    required this.preEncashmentEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PreEncashmentViewModel>(
      create: (context) => PreEncashmentViewModel(
        RepositoryProvider.of<DebtsRepository>(context),
        preEncashmentEx: preEncashmentEx
      ),
      child: _PreEncashmentView(),
    );
  }
}

class _PreEncashmentView extends StatefulWidget {
  @override
  _PreEncashmentViewState createState() => _PreEncashmentViewState();
}

class _PreEncashmentViewState extends State<_PreEncashmentView> {
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreEncashmentViewModel, PreEncashmentState>(
      builder: (context, state) {
        controller ??= TextEditingController(
          text: state.preEncashmentEx.preEncashment.encSum?.toStringAsFixed(2).replaceAll('.', ',')
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(state.preEncashmentEx.buyer.name)
          ),
          body: buildBody(context)
        );
      }
    );
  }

  Widget buildBody(BuildContext context) {
    final vm = context.read<PreEncashmentViewModel>();
    final preEncashmentEx = vm.state.preEncashmentEx;
    final debt = preEncashmentEx.debt;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      child: Column(
        children: [
          InfoRow.page(
            title: const Text('Документ', style: Styles.formStyle),
            trailing: Text(debt.info ?? '', style: Styles.formStyle)
          ),
          InfoRow.page(
            title: const Text('Сумма', style: Styles.formStyle),
            trailing: Text(Format.numberStr(debt.orderSum), style: Styles.formStyle)
          ),
          InfoRow.page(
            title: const Text('Долг', style: Styles.formStyle),
            trailing: Text(Format.numberStr(debt.debtSum), style: Styles.formStyle)
          ),
          InfoRow.page(
            title: const Text('Чек', style: Styles.formStyle),
            trailing: Text(debt.needReceipt ? 'Да' : 'Нет', style: Styles.formStyle)
          ),
          InfoRow.page(
            title: const Text('Оплата', style: Styles.formStyle),
            trailing: NumTextField(
              textAlign: TextAlign.start,
              controller: controller,
              style: Styles.formStyle,
              decoration: InputDecoration(
                suffixIcon: (preEncashmentEx.preEncashment.encSum ?? 0) != 0 ?
                  IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Очистить',
                    onPressed: () => updateEncSumAndText(null)
                  ) :
                  IconButton(
                    icon: const Icon(Icons.price_change),
                    tooltip: 'Указать весь долг',
                    onPressed: () => updateEncSumAndText(debt.debtSum)
                  ),
                labelText: '',
                contentPadding: const EdgeInsets.only(),
                errorMaxLines: 2,
                isDense: true
              ),
              onTap: () => vm.updateEncSum(Parsing.parseDouble(controller!.text))
            )
          )
        ],
      )
    );
  }

  void updateEncSumAndText(double? sum) {
    final vm = context.read<PreEncashmentViewModel>();

    controller!.text = Format.numberStr(sum);
    vm.updateEncSum(sum);
    Misc.unfocus(context);
  }
}
