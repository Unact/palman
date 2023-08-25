import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/orders_repository.dart';
import '/app/repositories/prices_repository.dart';
import '/app/utils/format.dart';
import '../../order/order_page.dart';

part 'pre_order_state.dart';
part 'pre_order_view_model.dart';

class PreOrderPage extends StatelessWidget {
  final PreOrderExResult preOrderEx;

  PreOrderPage({
    required this.preOrderEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PreOrderViewModel>(
      create: (context) => PreOrderViewModel(
        preOrderEx: preOrderEx,
        RepositoryProvider.of<OrdersRepository>(context),
        RepositoryProvider.of<PricesRepository>(context)
      ),
      child: _PreOrderView(),
    );
  }
}

class _PreOrderView extends StatefulWidget {
  @override
  _PreOrderViewState createState() => _PreOrderViewState();
}

class _PreOrderViewState extends State<_PreOrderView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreOrderViewModel, PreOrderState>(
      builder: (context, state) {
        final vm = context.read<PreOrderViewModel>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Предзаказ'),
          ),
          body: buildPreOrderListView(context),
          floatingActionButton: state.preOrderEx.hasOrder ? null : FloatingActionButton(
            heroTag: null,
            onPressed: vm.createOrder,
            child: const Icon(Icons.add_shopping_cart)
          ),
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case PreOrderStateStatus.orderCreated:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
              openOrderPage(state.newOrder!);
            });
            break;
          default:
        }
      }
    );
  }

  Widget buildPreOrderListView(BuildContext context) {
    final vm = context.read<PreOrderViewModel>();

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: vm.state.linesExList.map((e) => buildPreOrderLineTile(context, e)).toList()
    );
  }

  Widget buildPreOrderLineTile(BuildContext context, PreOrderLineEx preorderLineEx) {
    return ListTile(
      title: Text(preorderLineEx.goods.name),
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
          children: <TextSpan>[
            TextSpan(
              text: 'Кол-во: ${preorderLineEx.line.vol.toInt()}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Цена: ${Format.numberStr(preorderLineEx.line.price)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Стоимость: ${Format.numberStr(preorderLineEx.line.total)}\n',
              style: Styles.tileText
            )
          ]
        )
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
}
