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
import '/app/repositories/orders_repository.dart';
import '/app/repositories/partners_repository.dart';
import '/app/repositories/prices_repository.dart';
import '/app/repositories/users_repository.dart';
import '/app/widgets/widgets.dart';
import 'goods/goods_page.dart';

part 'order_state.dart';
part 'order_view_model.dart';

class OrderPage extends StatelessWidget {
  final OrderExResult orderEx;

  OrderPage({
    required this.orderEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderViewModel>(
      create: (context) => OrderViewModel(
        orderEx: orderEx,
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<OrdersRepository>(context),
        RepositoryProvider.of<PartnersRepository>(context),
        RepositoryProvider.of<PricesRepository>(context),
        RepositoryProvider.of<UsersRepository>(context)
      ),
      child: _OrderView(),
    );
  }
}

class _OrderView extends StatefulWidget {
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<_OrderView> {
  TextEditingController? buyerController;

  Future<void> showDateDialog() async {
    final vm = context.read<OrderViewModel>();
    final firstDate = vm.state.workdates.first.date;
    final lastDate = vm.state.workdates.last.date;
    final initialDate = vm.state.orderEx.order.date;
    final days = vm.state.workdates.map((e) => e.date).toList();

    DateTime? result = await showDatePicker(
      context: context,
      firstDate: [initialDate, firstDate].nonNulls.min,
      lastDate: lastDate,
      selectableDayPredicate: (day) {
        if (day == initialDate) return true;

        return days.contains(day) && vm.state.orderEx.buyer!.weekdays[day.weekday % 7];
      },
      initialDate: initialDate
    );

    vm.updateDate(result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderViewModel, OrderState>(
      builder: (context, state) {
        final vm = context.read<OrderViewModel>();
        buyerController ??= TextEditingController(
          text: state.orderEx.buyer?.fullname.toString()
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Заказ'),
            actions: [
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.copy),
                splashRadius: 12,
                tooltip: 'Создать дубликат',
                onPressed: state.isEditable ? vm.copy : null
              ),
              SaveButton(
                onSave: vm.syncChanges,
                pendingChanges: state.pendingChanges
              )
            ],
          ),
          floatingActionButton: state.canBeProcessed ? null : FloatingActionButton(
            heroTag: null,
            onPressed: vm.updateNeedProcessing,
            child: Icon(state.orderEx.order.needProcessing ? Icons.undo : Icons.redo)
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView(
              children: buildOrderFields(context)
            )
          ),
        );
      },
      listener: (context, state) {
        switch (state.status) {
          case OrderStateStatus.orderRemoved:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Misc.showMessage(context, 'Заказ не доступен для редактирования');
            });
            break;
          case OrderStateStatus.orderCopied:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Misc.showMessage(context, state.message);
              Navigator.of(context).pop();
              openOrderPage(state.newOrder!);
            });
            break;
          default:
        }
      },
    );
  }

  Widget buildOrderListView(BuildContext context) {
    final vm = context.read<OrderViewModel>();

    return ExpansionTile(
      title: const Text('Позиции'),
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      trailing: IconButton(
        icon: const Icon(Icons.shopping_cart),
        tooltip: 'Добавить',
        onPressed: vm.state.orderEx.buyer == null || vm.state.orderEx.order.date == null ? null : () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => GoodsPage(orderEx: vm.state.orderEx),
              fullscreenDialog: false
            )
          );
        },
      ),
      children: vm.state.filteredOrderLinesExList.map((e) => buildOrderLineTile(context, e)).toList()
    );
  }

  Widget buildBuyerSearch(BuildContext context) {
    final vm = context.read<OrderViewModel>();

    if (!vm.state.isEditable) return Text(vm.state.orderEx.buyer?.fullname ?? '', style: Styles.formStyle);

    return BuyerField(buyerExList: vm.state.buyerExList, onSelect: vm.updateBuyer, controller: buyerController);
  }

  List<Widget> buildOrderFields(BuildContext context) {
    final vm = context.read<OrderViewModel>();
    final order = vm.state.orderEx.order;

    return [
      InfoRow.page(
        title: const Text('Статус', style: Styles.formStyle),
        trailing: Text(order.detailedStatus.name, style: Styles.formStyle)
      ),
      !vm.state.orderEx.order.isEditable ? Container() : InfoRow.page(
        title: const Text('Передан в работу', style: Styles.formStyle),
        trailing: Text(order.needProcessing ? 'Да' : 'Нет', style: Styles.formStyle)
      ),
      InfoRow.page(
        title: const Text('Клиент', style: Styles.formStyle),
        trailing: buildBuyerSearch(context)
      ),
      vm.state.preOrderMode ? Container() : InfoRow.page(
        title: const Text('Бонусный', style: Styles.formStyle),
        trailing: Checkbox(
          value: order.isBonus,
          onChanged: !vm.state.isEditable ? null : (bool? value) => vm.updateIsBonus(value!)
        )
      ),
      vm.state.preOrderMode ? Container() : InfoRow.page(
        title: const Text('Требуется инкассация', style: Styles.formStyle),
        trailing: Checkbox(
          value: order.needInc,
          onChanged: !vm.state.isEditable ? null : (bool? value) => vm.updateNeedInc(value!)
        )
      ),
      InfoRow.page(
        title: const Text('Нужна счет-фактура', style: Styles.formStyle),
        trailing: Checkbox(
          value: order.needDocs,
          onChanged: !vm.state.isEditable ? null : (bool? value) => vm.updateNeedDocs(value!)
        )
      ),
      vm.state.preOrderMode ? Container() : InfoRow.page(
        title: const Text('Физ. лицо', style: Styles.formStyle),
        trailing: Checkbox(
          value: order.isPhysical,
          onChanged: !vm.state.isEditable ? null : (bool? value) => vm.updateIsPhysical(value!)
        )
      ),
      InfoRow.page(
        title: const Text('Дата доставки', style: Styles.formStyle),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(Format.dateStr(order.date), style: Styles.formStyle),
            !vm.state.isEditable || vm.state.workdates.isEmpty ?
              Container() :
              IconButton(
                onPressed: vm.state.orderEx.buyer == null ? null : showDateDialog,
                tooltip: 'Указать дату',
                icon: const Icon(Icons.calendar_month)
              )
          ]
        )
      ),
      InfoRow.page(
        title: const Text('Комментарий', style: Styles.formStyle),
        trailing: TextFormField(
          enabled: vm.state.isEditable,
          initialValue: order.info,
          onFieldSubmitted: vm.updateInfo,
          style: Styles.formStyle
        )
      ),
      InfoRow.page(
        title: const Text('Стоимость', style: Styles.formStyle),
        trailing: Text(Format.numberStr(vm.state.orderEx.linesTotal), style: Styles.formStyle)
      ),
      buildOrderListView(context)
    ];
  }

  Widget buildOrderLineTile(BuildContext context, OrderLineExResult orderLineEx) {
    final vm = context.read<OrderViewModel>();
    final tile = ListTile(
      title: Text(orderLineEx.goodsName, style: Styles.tileTitleText),
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Кол-во: ${orderLineEx.line.vol.toInt()}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Цена: ${Format.numberStr(orderLineEx.line.price)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Стоимость: ${Format.numberStr(orderLineEx.line.total)}\n',
              style: Styles.tileText
            )
          ]
        )
      )
    );

    if (!vm.state.isEditable) return tile;

    return Dismissible(
      key: Key(orderLineEx.hashCode.toString()),
      background: Container(color: Colors.red[500]),
      onDismissed: (direction) => vm.deleteOrderLine(orderLineEx),
      confirmDismiss: (direction) => ConfirmationDialog(
        context: context,
        confirmationText: 'Вы точно хотите удалить позицию?'
      ).open(),
      child: tile
    );
  }

  Future<void> openOrderPage(OrderExResult orderEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OrderPage(orderEx: orderEx),
        fullscreenDialog: false
      )
    );
  }
}
