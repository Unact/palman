import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/debts_repository.dart';
import '/app/utils/format.dart';
import '/app/utils/misc.dart';
import '/app/utils/parsing.dart';
import '/app/widgets/widgets.dart';

part 'encashment_state.dart';
part 'encashment_view_model.dart';

class EncashmentPage extends StatelessWidget {
  final EncashmentEx encashmentEx;

  EncashmentPage({
    required this.encashmentEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EncashmentViewModel>(
      create: (context) => EncashmentViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<DebtsRepository>(context),
        encashmentEx: encashmentEx
      ),
      child: _EncashmentView(),
    );
  }
}

class _EncashmentView extends StatefulWidget {
  @override
  _EncashmentViewState createState() => _EncashmentViewState();
}

class _EncashmentViewState extends State<_EncashmentView> {
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EncashmentViewModel, EncashmentState>(
      builder: (context, state) {
        controller ??= TextEditingController(
          text: state.encashmentEx.encashment.encSum?.toStringAsFixed(2).replaceAll('.', ',')
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(state.encashmentEx.buyer.name)
          ),
          body: buildBody(context)
        );
      }
    );
  }

  Widget buildBody(BuildContext context) {
    final vm = context.read<EncashmentViewModel>();
    final encashmentEx = vm.state.encashmentEx;
    final debt = encashmentEx.debt!;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      child: Column(
        children: [
          InfoRow(trailingFlex: 2, title: const Text('Документ'), trailing: Text(debt.info ?? '')),
          InfoRow(title: const Text('Сумма'), trailing: Text(Format.numberStr(debt.orderSum))),
          InfoRow(title: const Text('Долг'), trailing: Text(Format.numberStr(debt.debtSum))),
          InfoRow(title: const Text('Чек'), trailing: Text(debt.isCheck ? 'Да' : 'Нет')),
          InfoRow(
            title: const Text('Оплата'),
            trailing: !vm.state.isEditable ?
              null :
              NumTextField(
                textAlign: TextAlign.end,
                controller: controller,
                enabled: vm.state.isEditable,
                style: Styles.formStyle,
                decoration: InputDecoration(
                  suffixIcon: (encashmentEx.encashment.encSum ?? 0) != 0 ?
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
                  border: const UnderlineInputBorder(),
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
    final vm = context.read<EncashmentViewModel>();

    controller!.text = Format.numberStr(sum);
    vm.updateEncSum(sum);
    Misc.unfocus(context);
  }
}
