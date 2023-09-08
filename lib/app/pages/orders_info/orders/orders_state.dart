part of 'orders_page.dart';

enum OrdersStateStatus {
  initial,
  dataLoaded,
  orderAdded
}

class OrdersState {
  OrdersState({
    this.status = OrdersStateStatus.initial,
    this.orderExList = const [],
    this.newOrder
  });

  final OrdersStateStatus status;
  final List<OrderExResult> orderExList;
  final OrderExResult? newOrder;

  List<OrderExResult> get filteredOrderExList => orderExList
    .where((e) => !e.order.isDeleted && e.order.detailedStatus == OrderStatus.deleted)
    .toList();

  OrdersState copyWith({
    OrdersStateStatus? status,
    List<OrderExResult>? orderExList,
    OrderExResult? newOrder
  }) {
    return OrdersState(
      status: status ?? this.status,
      orderExList: orderExList ?? this.orderExList,
      newOrder: newOrder ?? this.newOrder
    );
  }
}
