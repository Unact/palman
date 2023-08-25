part of 'orders_info_page.dart';

class OrdersInfoViewModel extends PageViewModel<OrdersInfoState, OrdersInfoStateStatus> {
  OrdersInfoViewModel() : super(OrdersInfoState(), []);

  @override
  OrdersInfoStateStatus get status => state.status;

  @override
  Future<void> loadData() async {}
}
