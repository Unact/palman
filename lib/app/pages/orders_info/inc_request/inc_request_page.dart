import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/partners_repository.dart';
import '/app/repositories/shipments_repository.dart';
import '/app/widgets/widgets.dart';

part 'inc_request_state.dart';
part 'inc_request_view_model.dart';

class IncRequestPage extends StatelessWidget {
  final IncRequestEx incRequestEx;

  IncRequestPage({
    required this.incRequestEx,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IncRequestViewModel>(
      create: (context) => IncRequestViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<PartnersRepository>(context),
        RepositoryProvider.of<ShipmentsRepository>(context),
        incRequestEx: incRequestEx
      ),
      child: _IncRequestView(),
    );
  }
}

class _IncRequestView extends StatefulWidget {
  @override
  _IncRequestViewState createState() => _IncRequestViewState();
}

class _IncRequestViewState extends State<_IncRequestView> {
  TextEditingController? buyerController;
  TextEditingController? sumController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncRequestViewModel, IncRequestState>(
      builder: (context, state) {
        buyerController ??= TextEditingController(text: state.incRequestEx.buyer?.fullname.toString());
        sumController ??= TextEditingController(
          text: state.incRequestEx.incRequest.incSum?.toStringAsFixed(2).replaceAll('.', ',')
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Заявка')
          ),
          body: buildBody(context)
        );
      }
    );
  }

  Future<void> showDateDialog() async {
    final vm = context.read<IncRequestViewModel>();
    final firstDate = vm.state.workdates.first.date;
    final lastDate = vm.state.workdates.last.date;
    final initialDate = vm.state.incRequestEx.incRequest.date;
    final days = vm.state.workdates.map((e) => e.date).toList();

    DateTime? result = await showDatePicker(
      context: context,
      firstDate: [initialDate, firstDate].nonNulls.min,
      lastDate: lastDate,
      selectableDayPredicate: (day) {
        if (day == initialDate) return true;

        return days.contains(day) && vm.state.incRequestEx.buyer!.weekdays[day.weekday % 7];
      }
    );

    vm.updateDate(result);
  }

  Widget buildBody(BuildContext context) {
    final vm = context.read<IncRequestViewModel>();
    final incRequestEx = vm.state.incRequestEx;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      child: Column(
        children: [
          InfoRow.page(
            title: const Text('Клиент', style: Styles.formStyle),
            trailing: buildBuyerSearch(context)
          ),
          InfoRow.page(
            title: const Text('Дата', style: Styles.formStyle),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(Format.dateStr(incRequestEx.incRequest.date), style: Styles.formStyle),
                !vm.state.isEditable || vm.state.workdates.isEmpty ?
                  Container() :
                  IconButton(
                    onPressed: incRequestEx.buyer == null ? null : showDateDialog,
                    tooltip: 'Указать дату',
                    icon: const Icon(Icons.calendar_month),
                    constraints: const BoxConstraints()
                  )
              ]
            )
          ),
          InfoRow.page(
            title: const Text('Сумма', style: Styles.formStyle),
            trailing: !vm.state.isEditable ?
              Text(Format.numberStr(incRequestEx.incRequest.incSum), style: Styles.formStyle) :
              NumTextField(
                textAlign: TextAlign.start,
                controller: sumController,
                enabled: vm.state.isEditable,
                style: Styles.formStyle,
                onTap: () => vm.updateIncSum(Parsing.parseDouble(sumController!.text))
              )
          ),
          InfoRow.page(
            title: const Text('Комментарий', style: Styles.formStyle),
            trailing: !vm.state.isEditable ?
              Text(incRequestEx.incRequest.info ?? '', style: Styles.formStyle) :
              TextFormField(
                textAlign: TextAlign.start,
                initialValue: incRequestEx.incRequest.info,
                maxLines: 1,
                style: Styles.formStyle,
                onChanged: vm.updateInfo
              )
          )
        ]
      )
    );
  }

  Widget buildBuyerSearch(BuildContext context) {
    final vm = context.read<IncRequestViewModel>();

    if (!vm.state.isEditable) return Text(vm.state.incRequestEx.buyer?.fullname ?? '', style: Styles.formStyle);

    return BuyerField(buyerExList: vm.state.buyerExList, onSelect: vm.updateBuyer, controller: buyerController);
  }
}
