import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/constants/strings.dart';
import '/app/pages/shared/page_view_model.dart';
import 'inc_requests/inc_requests_page.dart';
import 'orders/orders_page.dart';
import 'pre_orders/pre_orders_page.dart';
import 'shipments/shipments_page.dart';

part 'orders_info_state.dart';
part 'orders_info_view_model.dart';

class OrdersInfoPage extends StatelessWidget {
  OrdersInfoPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersInfoViewModel>(
      create: (context) => OrdersInfoViewModel(),
      child: _OrdersInfoView(),
    );
  }
}

class _OrdersInfoView extends StatefulWidget {
  @override
  _OrdersInfoViewState createState() => _OrdersInfoViewState();
}

class _OrdersInfoViewState extends State<_OrdersInfoView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersInfoViewModel, OrdersInfoState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(Strings.ordersInfoPageName),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Заказы'),
                  Tab(text: 'Заявки'),
                  Tab(text: 'Отгрузки'),
                  Tab(text: 'Предзаказы ТП'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                OrdersPage(),
                IncRequestsPage(),
                ShipmentsPage(),
                PreOrdersPage(),
              ],
            ),
          ),
        );
      }
    );
  }
}
