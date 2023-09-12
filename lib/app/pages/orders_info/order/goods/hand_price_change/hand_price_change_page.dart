import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/pages/shared/page_view_model.dart';

part 'hand_price_change_state.dart';
part 'hand_price_change_view_model.dart';

class HandPriceChangePage extends StatelessWidget {
  final double minHandPrice;
  final double handPrice;

  HandPriceChangePage({
    required this.minHandPrice,
    required this.handPrice,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HandPriceChangeViewModel>(
      create: (context) => HandPriceChangeViewModel(
        minHandPrice: minHandPrice,
        handPrice: handPrice
      ),
      child: _HandPriceChangeView(),
    );
  }
}

class _HandPriceChangeView extends StatefulWidget {
  @override
  _HandPriceChangeViewState createState() => _HandPriceChangeViewState();
}

class _HandPriceChangeViewState extends State<_HandPriceChangeView> {
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HandPriceChangeViewModel, HandPriceChangeState>(
      builder: (context, state) {
        controller ??= TextEditingController(text: state.handPrice?.toStringAsFixed(2).replaceAll('.', ','));

        return AlertDialog(
          title: const Text('Изменение цены'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                buildInfoTable(context),
                buildPriceRow(context)
              ]
            )
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                  if (!validHandPrice(state.handPrice)) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Ошибка'),
                        content: const Text('Указана некорректная цена'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text(Strings.ok))
                        ]
                      )
                    );
                    return;
                  }

                  Navigator.of(context).pop(state.handPrice);
                },
              child: const Text(Strings.ok)
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(Strings.cancel)
            )
          ],
        );
      }
    );
  }

  Widget buildInfoTable(BuildContext context) {
    final vm = context.read<HandPriceChangeViewModel>();

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(128),
        1: FixedColumnWidth(64),
        2: FixedColumnWidth(82),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(
          children: <Widget>[
            const Text('Мин. цена', style: Styles.formStyle),
            Text(Format.numberStr(vm.state.minHandPrice), style: Styles.formStyle),
            const SizedBox(height: 32)
          ],
        )
      ],
    );
  }

  Widget buildPriceRow(BuildContext context) {
    final vm = context.read<HandPriceChangeViewModel>();
    final handPrice = vm.state.handPrice ?? 0;

    return InfoRow(
      padding: EdgeInsets.zero,
      trailingFlex: 2,
      title: const Text('Цена', style: Styles.formStyle),
      trailing: SizedBox(
        width: 160,
        child: NumTextField(
          textAlign: TextAlign.center,
          controller: controller,
          style: Styles.formStyle,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Увеличить цену',
              onPressed: validHandPrice(handPrice + vm.state.priceStep) ?
                () => updateHandPriceAndText(handPrice + vm.state.priceStep) :
                null
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.remove),
              tooltip: 'Уменьшить цену',
              onPressed: validHandPrice(handPrice - vm.state.priceStep) ?
                () => updateHandPriceAndText(handPrice - vm.state.priceStep) :
                null
            )
          ),
          onTap: () => vm.updateHandPrice(Parsing.parseDouble(controller!.text))
        )
      )
    );
  }

  void updateHandPriceAndText(double? sum) {
    final vm = context.read<HandPriceChangeViewModel>();

    controller!.text = Format.numberStr(sum);
    vm.updateHandPrice(sum);
    Misc.unfocus(context);
  }

  bool validHandPrice(double? price) {
    final vm = context.read<HandPriceChangeViewModel>();

    if (price == null) return false;

    return price >= vm.state.minHandPrice;
  }
}
