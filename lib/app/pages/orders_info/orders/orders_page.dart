import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/orders_repository.dart';
import '../order/order_page.dart';

part 'orders_state.dart';
part 'orders_view_model.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersViewModel>(
      create: (context) => OrdersViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<OrdersRepository>(context),
      ),
      child: _OrdersView(),
    );
  }
}

class _OrdersView extends StatefulWidget {
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<_OrdersView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersViewModel, OrdersState>(
      builder: (context, state) {
        final vm = context.read<OrdersViewModel>();
        final orderDate = state.filteredOrderExList
          .groupFoldBy<DateTime?, List<OrderExResult>>((e) => e.order.date, (acc, e) => (acc ?? [])..add(e));
        final orderDateList = orderDate.entries.toList();

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: vm.addNewOrder,
            child: const Icon(Icons.add)
          ),
          body: ListView.builder(
            itemCount: orderDateList.length,
            itemBuilder: (context, idx) => buildOrderDateTile(context, orderDateList[idx].key, orderDateList[idx].value)
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case OrdersStateStatus.orderAdded:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openOrderPage(state.newOrder!);
            });
            break;
          default:
        }
      },
    );
  }

  Widget buildOrderTile(BuildContext context, OrderExResult orderEx) {
    final vm = context.read<OrdersViewModel>();
    final tile = ListTile(
      title: Text(orderEx.buyer != null ? '${orderEx.buyer!.fullname}\n' : 'Клиент не указан\n'),
      trailing: orderEx.order.needSync ? const Icon(Icons.sync, color: Colors.red) : null,
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
          children: <TextSpan>[
            TextSpan(
              text: 'Сумма: ${Format.numberStr(orderEx.linesTotal)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Позиций: ${orderEx.linesCount}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Статус: ${orderEx.order.detailedStatus.name}\n',
              style: Styles.tileText.copyWith(color: _statusColor(orderEx))
            ),
            TextSpan(
              text: orderEx.order.isBonus ? 'Бонусный\n' : '',
              style: Styles.tileText
            ),
            TextSpan(
              text: orderEx.order.needInc ? 'Требуется инкассация\n' : '',
              style: Styles.tileText
            ),
            TextSpan(
              text: orderEx.order.needDocs ? 'Нужна счет-фактура\n' : '',
              style: Styles.tileText
            ),
            TextSpan(
              text: orderEx.order.isPhysical ? 'Физ. лицо\n' : '',
              style: Styles.tileText
            ),
            TextSpan(
              text: orderEx.order.info,
              style: Styles.tileText
            )
          ]
        )
      ),
      dense: false,
      onTap: () => openOrderPage(orderEx),
    );

    if (!orderEx.order.isEditable) return tile;

    return Dismissible(
      key: Key(orderEx.hashCode.toString()),
      background: Container(color: Colors.red[500]),
      onDismissed: (direction) => vm.deleteOrder(orderEx),
      confirmDismiss: (direction) => ConfirmationDialog(
        context: context,
        confirmationText: 'Вы точно хотите удалить заказ?'
      ).open(),
      child: tile
    );
  }

  Widget buildOrderDateTile(BuildContext context, DateTime? date, List<OrderExResult> orderExList) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(Format.dateStr(date)),
      children: orderExList.map((e) => buildOrderTile(context, e)).toList()
    );
  }

  Future<void> openOrderPage(OrderExResult orderEx) async {
    if (orderEx.order.isBlocked) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OrderPage(orderEx: orderEx),
        fullscreenDialog: false
      )
    );
  }

  Color _statusColor(OrderExResult orderEx) {
    switch (orderEx.order.detailedStatus) {
      case OrderStatus.deleted: return Colors.red;
      case OrderStatus.draft: return Colors.blue;
      case OrderStatus.upload: return Colors.grey[700]!;
      case OrderStatus.processing: return Colors.brown;
      case OrderStatus.done: return Colors.green;
      case OrderStatus.onhold: return Colors.red;
      case OrderStatus.unknown: return Colors.black;
    }
  }
}
