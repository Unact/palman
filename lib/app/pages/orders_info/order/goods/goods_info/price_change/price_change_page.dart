import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final DateTime? dateTo;
  final double? price;

  PriceChangePage({
    required this.price,
    required this.dateFrom,
    required this.dateTo,
    required this.goodsEx,
    required this.goodsPricelist,
    Key? key
  }) : super(key: key);

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
  final endOfTime = DateTime(9999, 1, 1);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PriceChangeViewModel, PriceChangeState>(
      builder: (context, state) {
        controller ??= TextEditingController(text: state.price?.toStringAsFixed(2).replaceAll('.', ','));

        return AlertDialog(
          title: const Text('Изменение цены'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                buildInfoTable(context),
                buildDateRow(context),
                buildPriceRow(context)
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

                  Navigator.of(context).pop((state.dateFrom, state.dateTo ?? endOfTime, state.price));
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
    final curGoodsPricelist = vm.state.goodsPricelist;
    final cost = vm.state.goodsEx.goods.cost;
    final minPrice = vm.state.goodsEx.goods.minPrice;
    final costDiff = (((vm.state.price ?? 0) - cost)/cost*100).roundDigits(1);
    final priceDiff = (((vm.state.price ?? 0) - curGoodsPricelist.price)/curGoodsPricelist.price*100).roundDigits(1);

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
            Text(curGoodsPricelist.name, style: Styles.formStyle),
            Text(Format.numberStr(curGoodsPricelist.price), style: Styles.formStyle),
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

  Widget buildDateRow(BuildContext context) {
    final vm = context.read<PriceChangeViewModel>();

    return InfoRow(
      padding: EdgeInsets.zero,
      trailingFlex: 2,
      title: const Text('До даты', style: Styles.formStyle),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(vm.state.dateTo != null ? Format.dateStr(vm.state.dateTo!) : 'Бессрочно', style: Styles.formStyle),
          IconButton(
            onPressed: () async {
              final newDate = await showDatePicker(
                context: context,
                firstDate: vm.state.dateFrom,
                lastDate: endOfTime,
                initialDate: vm.state.dateFrom
              );

              if (newDate != null) vm.updateDateTo(newDate);
            },
            tooltip: 'Указать дату',
            icon: const Icon(Icons.calendar_month)
          ),
          IconButton(
            icon: const Icon(Icons.hourglass_full_sharp),
            tooltip: 'Бессрочно',
            onPressed: () => vm.updateDateTo(null)
          )
        ]
      )
    );
  }

  Widget buildPriceRow(BuildContext context) {
    final vm = context.read<PriceChangeViewModel>();
    final price = vm.state.price ?? 0;

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
              onPressed: validPrice(price + vm.state.priceStep) ?
                () => updatePriceAndText(price + vm.state.priceStep) :
                null
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.remove),
              tooltip: 'Уменьшить цену',
              onPressed: validPrice(price - vm.state.priceStep) ?
                () => updatePriceAndText(price - vm.state.priceStep) :
                null
            )
          ),
          onTap: () => vm.updatePrice(Parsing.parseDouble(controller!.text))
        )
      )
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

    return price >= vm.state.goodsEx.goods.minPrice && price != vm.state.goodsPricelist.price;
  }
}
