import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';

part 'price_change_state.dart';
part 'price_change_view_model.dart';

class PriceChangePage extends StatelessWidget {
  final GoodsExResult goodsEx;
  final GoodsPricelistsResult goodsPricelist;
  final DateTime dateFrom;
  final DateTime dateTo;
  final double? price;

  PriceChangePage({
    required this.price,
    required this.dateFrom,
    required this.dateTo,
    required this.goodsEx,
    required this.goodsPricelist,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PriceChangeViewModel>(
      create: (context) => PriceChangeViewModel(
        goodsEx: goodsEx,
        goodsPricelist: goodsPricelist,
        dateFrom: dateFrom,
        dateTo: dateTo,
        price: price,
      ),
      child: _PriceChangeView(),
    );
  }
}

class _PriceChangeView extends StatefulWidget {
  @override
  _PriceChangeViewState createState() => _PriceChangeViewState();
}

class _PriceChangeViewState extends State<_PriceChangeView> {
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PriceChangeViewModel, PriceChangeState>(
      builder: (context, state) {
        controller ??= TextEditingController(text: state.price?.toStringAsFixed(2).replaceAll('.', ','));

        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 12),
          title: const Text('Изменение цены'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                buildInfoTable(context),
                buildDateTable(context),
                buildPriceTable(context)
              ]
            )
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(Strings.cancel)
            ),
            TextButton(
              onPressed: () {
                  if (!validPrice(state.price)) {
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

                  Navigator.of(context).pop((state.dateFrom, state.dateTo, state.price));
                },
              child: const Text(Strings.ok)
            )
          ],
        );
      }
    );
  }

  Widget buildInfoTable(BuildContext context) {
    final vm = context.read<PriceChangeViewModel>();
    final goodsPricelist = vm.state.goodsPricelist;
    final cost = vm.state.goodsEx.goods.cost;
    final minPrice = vm.state.goodsEx.goods.minPrice;
    final costDiff = (((vm.state.price ?? 0) - cost)/cost*100).roundDigits(1);
    final priceDiff = (((vm.state.price ?? 0) - goodsPricelist.price)/goodsPricelist.price*100).roundDigits(1);

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(148),
        1: FixedColumnWidth(98),
        2: FixedColumnWidth(122),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(
          children: <Widget>[
            const Text('Себестоимость', style: Styles.formStyle),
            Text(Format.numberStr(cost), style: Styles.formStyle),
            SizedBox(
              height: 32,
              child: Text(
                '${Format.numberStr(costDiff)}%',
                style: Styles.formStyle.copyWith(color: Colors.grey)
              )
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            const Text('Мин. розн. цена', style: Styles.formStyle),
            Text(Format.numberStr(minPrice), style: Styles.formStyle),
            const SizedBox(height: 32)
          ],
        ),
        TableRow(
          children: <Widget>[
            Text(goodsPricelist.name, style: Styles.formStyle),
            Text(Format.numberStr(goodsPricelist.price), style: Styles.formStyle),
            SizedBox(
              height: 32,
              child: Text(
                '${Format.numberStr(priceDiff)}%',
                style: Styles.formStyle.copyWith(color: Colors.grey)
              )
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDateTable(BuildContext context) {
    final vm = context.read<PriceChangeViewModel>();

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(118),
        1: FixedColumnWidth(90),
        2: FixedColumnWidth(90),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children:[
        TableRow(
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text('До даты', style: Styles.formStyle)
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(
                Format.dateStr(vm.state.dateTo),
                style: Styles.formStyle
              )
            ),
            IconButton(
              onPressed: () async {
                final newDate = await showDatePicker(
                  context: context,
                  firstDate: vm.state.dateFrom,
                  lastDate: vm.state.maxDateTo,
                  initialDate: vm.state.dateFrom
                );

                if (newDate != null) vm.updateDateTo(newDate);
              },
              tooltip: 'Указать дату',
              icon: const Icon(Icons.calendar_month)
            )
          ]
        )
      ]
    );
  }

  Widget buildPriceTable(BuildContext context) {
    final vm = context.read<PriceChangeViewModel>();
    final price = vm.state.price ?? 0;
    final incrPrice = (price + vm.state.priceStep).ceilDigits(4);
    final decrPrice = (price - vm.state.priceStep).ceilDigits(4);

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(118),
        1: FixedColumnWidth(0),
        2: FixedColumnWidth(180),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            const Text('Цена', style: Styles.formStyle),
            Container(),
            NumTextField(
              textAlign: TextAlign.center,
              controller: controller,
              style: Styles.formStyle,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                suffixIcon: HoldDetector(
                  onHold: () => validPrice(incrPrice) ? updatePriceAndText(incrPrice) : null,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'Увеличить цену',
                    onPressed: validPrice(incrPrice) ? () => updatePriceAndText(incrPrice) : null,
                  )
                ),
                prefixIcon: HoldDetector(
                  onHold: () => validPrice(decrPrice) ? updatePriceAndText(decrPrice) : null,
                  child: IconButton(
                    icon: const Icon(Icons.remove),
                    tooltip: 'Уменьшить цену',
                    onPressed: validPrice(decrPrice) ? () => updatePriceAndText(decrPrice) : null
                  )
                )
              ),
              onChanged: (_) => vm.updatePrice(Parsing.parseDouble(controller!.text))
            )
          ]
        )
      ]
    );
  }

  void updatePriceAndText(double? sum) {
    final vm = context.read<PriceChangeViewModel>();

    controller!.text = Format.numberStr(sum);
    vm.updatePrice(sum);
    Misc.unfocus(context);
  }

  bool validPrice(double? price) {
    final vm = context.read<PriceChangeViewModel>();

    if (price == null) return false;

    return price >= (vm.state.goodsEx.goods.minPrice * 100).truncate()/100;
  }
}
