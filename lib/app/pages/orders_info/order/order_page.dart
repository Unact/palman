import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/orders_repository.dart';
import '/app/repositories/partners_repository.dart';
import '/app/repositories/users_repository.dart';
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
  late final ProgressDialog progressDialog = ProgressDialog(context: context);
  TextEditingController? buyerController;

  Future<void> showDateDialog() async {
    final vm = context.read<OrderViewModel>();
    final firstDate = vm.state.workdates.first.date;
    final lastDate = vm.state.workdates.last.date;
    final initialDate = vm.state.orderEx.order.date ?? firstDate;
    final days = vm.state.workdates.map((e) => e.date).toList();

    DateTime? result = await showDatePicker(
      context: context,
      firstDate: [initialDate, firstDate].min,
      lastDate: lastDate,
      selectableDayPredicate: (day) => days.contains(day) || day == initialDate,
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
              Center(
                child: Badge(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  label: const Text(' '),
                  isLabelVisible: state.needSync,
                  offset: const Offset(-4, 4),
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.save),
                    splashRadius: 12,
                    tooltip: 'Сохранить изменения',
                    onPressed: state.needSync ? vm.save : null
                  )
                ),
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
          case OrderStateStatus.orderCopied:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Misc.showMessage(context, state.message);
              Navigator.of(context).pop();
              openOrderPage(state.newOrder!);
            });
            break;
          case OrderStateStatus.saveInProgress:
            progressDialog.open();
            break;
          case OrderStateStatus.saveFailure:
          case OrderStateStatus.saveSuccess:
            Misc.showMessage(context, state.message);
            progressDialog.close();
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
        onPressed: () async {
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
    final theme = Theme.of(context);

    if (!vm.state.isEditable) {
      return Text(vm.state.orderEx.buyer?.fullname ?? '', style: Styles.formStyle);
    }

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        maxLines: 1,
        style: Styles.formStyle,
        cursorColor: theme.textSelectionTheme.selectionColor,
        autocorrect: false,
        controller: buyerController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          suffixIcon: buyerController!.text == '' ? null : IconButton(
            tooltip: 'Очистить',
            onPressed: () {
              buyerController!.text = '';
              vm.updateBuyer(null);
            },
            icon: const Icon(Icons.clear)
          )
        ),
        onChanged: (value) => value.isEmpty ? vm.updateBuyer(null) : null
      ),
      errorBuilder: (BuildContext ctx, error) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Произошла ошибка', style: Styles.formStyle.apply(color: theme.colorScheme.error)),
        );
      },
      noItemsFoundBuilder: (BuildContext ctx) {
        return const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Ничего не найдено', style: Styles.formStyle),
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
        buyerController!.text = suggestion.fullname;
        vm.updateBuyer(suggestion);
      }
    );
  }

  List<Widget> buildOrderFields(BuildContext context) {
    final vm = context.read<OrderViewModel>();
    final order = vm.state.orderEx.order;

    return [
      InfoRow(
        trailingFlex: 2,
        title: const Text('Статус'),
        trailing: Text(order.detailedStatus.name)
      ),
      !vm.state.orderEx.order.isEditable ? Container() : InfoRow(
        trailingFlex: 2,
        title: const Text('Передан в работу'),
        trailing: Text(order.needProcessing ? 'Да' : 'Нет')
      ),
      InfoRow(
        trailingFlex: 2,
        title: const Text('Клиент'),
        trailing: buildBuyerSearch(context)
      ),
      vm.state.preOrderMode ? Container() : InfoRow(
        title: const Text('Бонусный'),
        trailing: Checkbox(
          value: order.isBonus,
          onChanged: !vm.state.isEditable ? null : (bool? value) => vm.updateIsBonus(value!)
        )
      ),
      vm.state.preOrderMode ? Container() : InfoRow(
        title: const Text('Требуется инкассация'),
        trailing: Checkbox(
          value: order.needInc,
          onChanged: !vm.state.isEditable ? null : (bool? value) => vm.updateNeedInc(value!)
        )
      ),
      InfoRow(
        title: const Text('Нужна счет-фактура'),
        trailing: Checkbox(
          value: order.needDocs,
          onChanged: !vm.state.isEditable ? null : (bool? value) => vm.updateNeedDocs(value!)
        )
      ),
      vm.state.preOrderMode ? Container() : InfoRow(
        title: const Text('Физ. лицо'),
        trailing: Checkbox(
          value: order.isPhysical,
          onChanged: !vm.state.isEditable ? null : (bool? value) => vm.updateIsPhysical(value!)
        )
      ),
      InfoRow(
        trailingFlex: 2,
        title: const Text('Дата доставки'),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(Format.dateStr(order.date), style: Styles.formStyle),
            !vm.state.isEditable || vm.state.workdates.isEmpty ?
              Container() :
              IconButton(
                onPressed: showDateDialog,
                tooltip: 'Указать дату',
                icon: const Icon(Icons.calendar_month)
              )
          ]
        )
      ),
      InfoRow(
        title: const Text('Комментарий'),
        trailing: TextFormField(
          enabled: vm.state.isEditable,
          initialValue: order.info,
          onFieldSubmitted: vm.updateInfo,
          style: Styles.formStyle
        )
      ),
      InfoRow(
        title: const Text('Стоимость'),
        trailing: Text(Format.numberStr(vm.state.orderEx.linesTotal))
      ),
      buildOrderListView(context)
    ];
  }

  Widget buildOrderLineTile(BuildContext context, OrderLineEx orderLineEx) {
    final vm = context.read<OrderViewModel>();
    final tile = ListTile(
      title: Text(orderLineEx.goods.name),
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
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
