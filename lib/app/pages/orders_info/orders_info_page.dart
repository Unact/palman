import 'dart:async';

import 'package:collection/collection.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/orders_repository.dart';
import '/app/repositories/partners_repository.dart';
import '/app/repositories/prices_repository.dart';
import '/app/repositories/shipments_repository.dart';
import '/app/repositories/users_repository.dart';
import '/app/widgets/widgets.dart';
import 'inc_request/inc_request_page.dart';
import 'order/order_page.dart';
import 'pre_order/pre_order_page.dart';
import 'shipment/shipment_page.dart';

part 'orders_info_state.dart';
part 'orders_info_view_model.dart';

class OrdersInfoPage extends StatelessWidget {
  OrdersInfoPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersInfoViewModel>(
      create: (context) => OrdersInfoViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<OrdersRepository>(context),
        RepositoryProvider.of<PartnersRepository>(context),
        RepositoryProvider.of<PricesRepository>(context),
        RepositoryProvider.of<ShipmentsRepository>(context),
        RepositoryProvider.of<UsersRepository>(context)
      ),
      child: _OrdersInfoView(),
    );
  }
}

class _OrdersInfoView extends StatefulWidget {
  @override
  _OrdersInfoViewState createState() => _OrdersInfoViewState();
}

class _OrdersInfoViewState extends State<_OrdersInfoView> with SingleTickerProviderStateMixin {
  final TextEditingController buyerController = TextEditingController();
  late final ProgressDialog progressDialog = ProgressDialog(context: context);
  Completer<IndicatorResult> refresherCompleter = Completer();

  @override
  void dispose() {
    progressDialog.close();
    super.dispose();
  }

  void closeRefresher(IndicatorResult result) {
    refresherCompleter.complete(result);
    refresherCompleter = Completer();
  }

  Future<void> openIncRequestPage(IncRequestEx incRequestEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => IncRequestPage(incRequestEx: incRequestEx),
        fullscreenDialog: false
      )
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

  Future<void> openPreOrderPage(PreOrderExResult preOrderEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PreOrderPage(preOrderEx: preOrderEx),
        fullscreenDialog: false
      )
    );
  }

  Future<void> openShipmentPage(ShipmentExResult shipmentEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ShipmentPage(shipmentEx: shipmentEx),
        fullscreenDialog: false
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersInfoViewModel, OrdersInfoState>(
      builder: (context, state) {
        final vm = context.read<OrdersInfoViewModel>();

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(Strings.ordersInfoPageName),
              bottom: TabBar(
                tabs: [
                  const Tab(child: Text('Заказы', style: Styles.tabStyle, softWrap: false)),
                  const Tab(child: Text('Заявки', style: Styles.tabStyle, softWrap: false)),
                  const Tab(child: Text('Отгрузки', style: Styles.tabStyle, softWrap: false)),
                  Tab(
                    child: Badge(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      label: Text(state.notSeenCnt.toString()),
                      isLabelVisible: state.notSeenCnt != 0,
                      offset: const Offset(12, -12),
                      child: const Text('Предзаказы других ТП', style: Styles.tabStyle, softWrap: false),
                    )
                  )
                ]
              ),
              actions: <Widget>[
                SaveButton(
                  onSave: state.isLoading ? null : vm.syncChanges,
                  pendingChanges: vm.state.pendingChanges,
                ),
              ]
            ),
            body: Refreshable(
              pendingChanges: vm.state.pendingChanges,
              onRefresh: vm.getData,
              childBuilder: (context, physics) {
                return TabBarView(
                  children: [
                    buildOrdersView(context, physics),
                    buildIncRequestsView(context, physics),
                    buildShipmentsView(context, physics),
                    buildPreOrdersView(context, physics),
                  ]
                );
              }
            )
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case OrdersInfoStateStatus.orderAdded:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openOrderPage(state.newOrder!);
            });
            break;
          case OrdersInfoStateStatus.incRequestAdded:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openIncRequestPage(state.newIncRequest!);
            });
            break;
          default:
        }
      }
    );
  }

  Widget buildOrdersView(BuildContext context, ScrollPhysics physics) {
    final vm = context.read<OrdersInfoViewModel>();
    final orderDate = vm.state.filteredOrderExList
      .groupFoldBy<DateTime?, List<OrderExResult>>((e) => e.order.date, (acc, e) => (acc ?? [])..add(e));
    final orderDateList = orderDate.entries.sortedByCompare(
      (e) => e.key,
      (a, b) => a == null ? -1 : b == null ? 1 : b.compareTo(a)
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: vm.addNewOrder,
        child: const Icon(Icons.add)
      ),
      body: ListView.builder(
        physics: physics,
        itemCount: orderDateList.length,
        itemBuilder: (context, idx) => buildOrderDateTile(
          context,
          orderDateList[idx].key,
          orderDateList[idx].value
        )
      )
    );
  }

  Widget buildIncRequestsView(BuildContext context, ScrollPhysics physics) {
    final vm = context.read<OrdersInfoViewModel>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: vm.addNewIncRequest,
        child: const Icon(Icons.add)
      ),
      body: ListView(
        physics: physics,
        padding: const EdgeInsets.only(top: 16),
        children: vm.state.filteredIncRequestExList.map((e) => buildIncRequestTile(context, e)).toList()
      )
    );
  }

  Widget buildPreOrdersView(BuildContext context, ScrollPhysics physics) {
    final vm = context.read<OrdersInfoViewModel>();

    return Scaffold(
      body: ListView(
        physics: physics,
        padding: const EdgeInsets.only(top: 16),
        children: vm.state.preOrderExList.map((e) => buildPreOrderTile(context, e)).toList()
      )
    );
  }

  Widget buildOrderTile(BuildContext context, OrderExResult orderEx) {
    final vm = context.read<OrdersInfoViewModel>();
    final tile = ListTile(
      title: Text(
        orderEx.buyer != null ? '${orderEx.buyer!.fullname}\n' : 'Клиент не указан\n',
        style: Styles.tileTitleText
      ),
      trailing: orderEx.order.needSync ? Icon(Icons.sync, color: Theme.of(context).colorScheme.primary) : null,
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Сумма: ${Format.numberStr(orderEx.linesTotal)}\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
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
      title: Text(date == null ? 'Дата не указана' : Format.dateStr(date)),
      children: orderExList.map((e) => buildOrderTile(context, e)).toList()
    );
  }

  Widget buildIncRequestTile(BuildContext context, IncRequestEx incRequestEx) {
    final vm = context.read<OrdersInfoViewModel>();
    final tile = ListTile(
      title: Text(
        incRequestEx.incRequest.date == null ? 'Дата не указана' : Format.dateStr(incRequestEx.incRequest.date),
        style: Styles.tileTitleText
      ),
      trailing: incRequestEx.incRequest.needSync ?
        Icon(Icons.sync, color: Theme.of(context).colorScheme.primary) :
        null,
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: incRequestEx.buyer != null ?
                '${incRequestEx.buyer!.fullname}\n' :
                'Клиент не указан\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: 'Сумма: ${Format.numberStr(incRequestEx.incRequest.incSum)}\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: 'Комментарий: ${incRequestEx.incRequest.info ?? ''}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Статус: ${incRequestEx.incRequest.status}\n',
              style: Styles.tileText.copyWith(color: Styles.blueColor)
            )
          ]
        )
      ),
      dense: false,
      onTap: () => openIncRequestPage(incRequestEx),
    );

    if (!incRequestEx.incRequest.isNew) return tile;

    return Dismissible(
      key: Key(incRequestEx.hashCode.toString()),
      background: Container(color: Colors.red[500]),
      onDismissed: (direction) => vm.deleteIncRequest(incRequestEx),
      confirmDismiss: (direction) => ConfirmationDialog(
        context: context,
        confirmationText: 'Вы точно хотите удалить заявку?'
      ).open(),
      child: tile
    );
  }

  Widget buildPreOrderTile(BuildContext context, PreOrderExResult preOrderEx) {
    return ListTile(
      title: Text(Format.dateStr(preOrderEx.preOrder.date), style: Styles.tileTitleText),
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: preOrderEx.wasSeen ? '' : 'Новый!\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold, color: Colors.red)
            ),
            TextSpan(
              text: '${preOrderEx.buyer.fullname}\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: 'Сумма: ${Format.numberStr(preOrderEx.linesTotal)}\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: 'Позиций: ${preOrderEx.linesCount}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: preOrderEx.preOrder.info != null ? '${preOrderEx.preOrder.info}\n' : '',
              style: Styles.tileText
            ),
            TextSpan(
              text: preOrderEx.hasOrder ? 'Создан заказ' : 'Заказ не создан',
              style: Styles.tileText.copyWith(color: Styles.blueColor)
            )
          ]
        )
      ),
      dense: false,
      onTap: () => openPreOrderPage(preOrderEx)
    );
  }

  Widget buildShipmentsView(BuildContext context, ScrollPhysics physics) {
    return CustomScrollView(
      physics: physics,
      slivers: [
        SliverAppBar(
          centerTitle: true,
          pinned: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: buildShipmentsHeader(context),
        ),
        SliverList(delegate: buildShipmentsListView(context))
      ]
    );
  }

  Widget buildShipmentsHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: buildBuyerSearch(context)
    );
  }

  Widget buildBuyerSearch(BuildContext context) {
    final vm = context.read<OrdersInfoViewModel>();
    final theme = Theme.of(context);

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        maxLines: 1,
        cursorColor: theme.textSelectionTheme.selectionColor,
        autocorrect: false,
        controller: buyerController,
        style: Styles.formStyle,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          labelText: 'Клиент',
          suffixIcon: buyerController.text == '' ? null : IconButton(
            tooltip: 'Очистить',
            onPressed: () {
              buyerController.text = '';
              vm.selectBuyer(null);
            },
            icon: const Icon(Icons.clear)
          )
        ),
        onChanged: (value) => value.isEmpty ? vm.selectBuyer(null) : null
      ),
      errorBuilder: (BuildContext ctx, error) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Произошла ошибка', style: Styles.formStyle.copyWith(color: theme.colorScheme.error))
        );
      },
      noItemsFoundBuilder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Ничего не найдено',
            textAlign: TextAlign.center,
            style: Styles.formStyle.copyWith(color: theme.disabledColor),
          ),
        );
      },
      suggestionsCallback: (String value) async {
        return vm.state.buyers.
          where((Buyer buyer) => buyer.name.toLowerCase().contains(value.toLowerCase())).toList();
      },
      itemBuilder: (BuildContext ctx, Buyer suggestion) {
        return ListTile(
          isThreeLine: false,
          title: Text(suggestion.fullname, style: Styles.formStyle)
        );
      },
      onSuggestionSelected: (Buyer suggestion) async {
        buyerController.text = suggestion.fullname;
        vm.selectBuyer(suggestion);
      }
    );
  }

  SliverChildDelegate buildShipmentsListView(BuildContext context) {
    final vm = context.read<OrdersInfoViewModel>();

    final shipmentDate = vm.state.filteredShipmentExList
      .groupFoldBy<DateTime, List<ShipmentExResult>>((e) => e.shipment.date, (acc, e) => (acc ?? [])..add(e));
    final shipmentDateList = shipmentDate.entries.toList();

    return SliverChildListDelegate(
      shipmentDateList.map((e) => buildShipmentDateTile(context, e.key, e.value)
    ).toList());
  }

  Widget buildShipmentDateTile(BuildContext context, DateTime date, List<ShipmentExResult> shipmentExList) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(Format.dateStr(date)),
      children: shipmentExList.map((e) => buildShipmentTile(context, e)).toList()
    );
  }

  Widget buildShipmentTile(BuildContext context, ShipmentExResult shipmentEx) {
     return ListTile(
      title: Text('${shipmentEx.buyer.fullname}\n', style: Styles.tileTitleText),
      subtitle: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: 'Номер: ${shipmentEx.shipment.ndoc}\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: 'Статус: ${shipmentEx.shipment.status}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: shipmentEx.shipment.info.isNotEmpty ? 'Примечание: ${shipmentEx.shipment.info}\n' : '',
              style: Styles.tileText
            ),
            shipmentEx.shipment.debtSum == null ?
              const TextSpan() :
              TextSpan(
                text: 'Задолженность: ${Format.numberStr(shipmentEx.shipment.debtSum)}\n',
                style: Styles.tileText
              ),
            WidgetSpan(child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    'Сумма: ${Format.numberStr(shipmentEx.shipment.shipmentSum)}',
                    style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
                  ),
                ),
                Text('Позиций: ${shipmentEx.linesCount}\n', style: Styles.tileText)
              ],
            ))
          ]
        )
      ),
      dense: false,
      onTap: () => openShipmentPage(shipmentEx)
    );
  }

  Color _statusColor(OrderExResult orderEx) {
    switch (orderEx.order.detailedStatus) {
      case OrderStatus.deleted: return Styles.redColor;
      case OrderStatus.draft: return Styles.blueColor;
      case OrderStatus.upload: return Styles.greyColor;
      case OrderStatus.processing: return Styles.brownColor;
      case OrderStatus.done: return Styles.greenColor;
      case OrderStatus.onhold: return Styles.redColor;
      case OrderStatus.unknown: return Styles.blackColor;
    }
  }
}
