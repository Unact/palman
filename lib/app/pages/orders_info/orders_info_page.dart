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
import '/app/entities/entities.dart';
import '/app/pages/home/home_page.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/orders_repository.dart';
import '/app/repositories/partners_repository.dart';
import '/app/repositories/shipments_repository.dart';
import 'inc_requests/inc_request/inc_request_page.dart';
import 'order/order_page.dart';
import 'pre_orders/pre_order/pre_order_page.dart';
import 'shipments/shipment/shipment_page.dart';

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
        RepositoryProvider.of<ShipmentsRepository>(context)
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
  Completer<IndicatorResult> refresherCompleter = Completer();

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
                  const Tab(text: 'Заказы'),
                  const Tab(text: 'Заявки'),
                  const Tab(text: 'Отгрузки'),
                  Tab(
                    child: Badge(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      label: Text(state.notSeenCnt.toString()),
                      isLabelVisible: state.notSeenCnt != 0,
                      offset: const Offset(12, -12),
                      child: const Text('Предзаказы других ТП', overflow: TextOverflow.fade, softWrap: false),
                    )
                  )
                ]
              )
            ),
            body: EasyRefresh.builder(
              header: ClassicHeader(
                dragText: 'Потяните чтобы обновить',
                armedText: 'Отпустите чтобы обновить',
                readyText: 'Загрузка',
                processingText: 'Загрузка',
                messageText: 'Последнее обновление: %T',
                failedText: state.message,
                processedText: 'Данные успешно обновлены',
                noMoreText: 'Идет сохранение данных',
                clamping: true,
                position: IndicatorPosition.locator,
              ),
              onRefresh: () async {
                setPageChangeable(false);
                vm.tryGetData();
                final result = await refresherCompleter.future;
                setPageChangeable(true);

                return result;
              },
              childBuilder: (context, physics) {
                return NestedScrollView(
                  physics: physics,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      const HeaderLocator.sliver(clearExtent: false),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      buildOrdersView(context, physics),
                      buildIncRequestsView(context, physics),
                      buildShipmentsView(context, physics),
                      buildPreOrdersView(context, physics),
                    ]
                  )
                );
              }
            )
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case OrdersInfoStateStatus.loadConfirmation:
            showConfirmationDialog();
            break;
          case OrdersInfoStateStatus.loadDeclined:
            closeRefresher(IndicatorResult.fail);
            break;
          case OrdersInfoStateStatus.loadFailure:
            closeRefresher(IndicatorResult.fail);
            break;
          case OrdersInfoStateStatus.loadSuccess:
            closeRefresher(IndicatorResult.success);
            break;
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
    final orderDateList = orderDate.entries.toList();

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
        children: vm.state.incRequestExList.map((e) => buildIncRequestTile(context, e)).toList()
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

  void setPageChangeable(bool pageChangeable) {
    final homeVm = context.read<HomeViewModel>();

    homeVm.setPageChangeable(pageChangeable);
  }

  void closeRefresher(IndicatorResult result) {
    refresherCompleter.complete(result);
    refresherCompleter = Completer();
  }

  Future<void> showConfirmationDialog() async {
    final vm = context.read<OrdersInfoViewModel>();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Внимание'),
          content: const SingleChildScrollView(child: Text('Присутствуют не сохраненные изменения. Продолжить?')),
          actions: <Widget>[
            TextButton(child: const Text(Strings.cancel), onPressed: () => Navigator.of(context).pop(true)),
            TextButton(child: const Text(Strings.ok), onPressed: () => Navigator.of(context).pop(false))
          ],
        );
      }
    ) ?? true;

    await vm.getData(result);
  }

  Widget buildOrderTile(BuildContext context, OrderExResult orderEx) {
    final vm = context.read<OrdersInfoViewModel>();
    final tile = ListTile(
      title: Text(orderEx.buyer != null ? '${orderEx.buyer!.fullname}\n' : 'Клиент не указан\n'),
      trailing: orderEx.order.needSync ? Icon(Icons.sync, color: Theme.of(context).colorScheme.primary) : null,
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
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

  Widget buildIncRequestTile(BuildContext context, IncRequestEx incRequestEx) {
    final vm = context.read<OrdersInfoViewModel>();
    final tile = ListTile(
      title: Text(Format.dateStr(incRequestEx.incRequest.date)),
      trailing: incRequestEx.incRequest.needSync ?
        Icon(Icons.sync, color: Theme.of(context).colorScheme.primary) :
        null,
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
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
              style: Styles.tileText.copyWith(color: Colors.blue)
            )
          ]
        )
      ),
      dense: false,
      onTap: () => openIncRequestPage(incRequestEx),
    );

    if (incRequestEx.incRequest.guid != null) return tile;

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

  Future<void> openIncRequestPage(IncRequestEx incRequestEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => IncRequestPage(incRequestEx: incRequestEx),
        fullscreenDialog: false
      )
    );
  }

  Widget buildPreOrderTile(BuildContext context, PreOrderExResult preOrderEx) {
    return ListTile(
      title: Text(Format.dateStr(preOrderEx.preOrder.date)),
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
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
              style: Styles.tileText.copyWith(color: Colors.blue)
            )
          ]
        )
      ),
      dense: false,
      onTap: () => openPreOrderPage(preOrderEx)
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

  Widget buildShipmentsView(BuildContext context, ScrollPhysics physics) {
    return CustomScrollView(
      physics: physics,
      slivers: [
        SliverAppBar(
          centerTitle: true,
          pinned: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: buildHeader(context),
        ),
        SliverList(delegate: buildShipmentListView(context))
      ]
    );
  }

  Widget buildHeader(BuildContext context) {
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
          child: Text('Произошла ошибка', style: TextStyle(color: theme.colorScheme.error)),
        );
      },
      noItemsFoundBuilder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Ничего не найдено',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.disabledColor, fontSize: 14.0),
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
          title: Text(suggestion.fullname)
        );
      },
      onSuggestionSelected: (Buyer suggestion) async {
        buyerController.text = suggestion.fullname;
        vm.selectBuyer(suggestion);
      }
    );
  }

  SliverChildDelegate buildShipmentListView(BuildContext context) {
    final vm = context.read<OrdersInfoViewModel>();

    final shipmentDate = vm.state.filteredShipmentExList
      .groupFoldBy<DateTime, List<ShipmentExResult>>((e) => e.shipment.date, (acc, e) => (acc ?? [])..add(e));
    final shipmentDateList = shipmentDate.entries.toList();

    return SliverChildBuilderDelegate(
      (BuildContext context, int idx) {
        return buildShipmentDateTile(context, shipmentDateList[idx].key, shipmentDateList[idx].value);
      },
      childCount: shipmentDateList.length
    );
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
      title: Text(shipmentEx.buyer.fullname),
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
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
                    style: Styles.tileText.copyWith(fontWeight: FontWeight.bold, color: Colors.grey)
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

  Future<void> openShipmentPage(ShipmentExResult shipmentEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ShipmentPage(shipmentEx: shipmentEx),
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
