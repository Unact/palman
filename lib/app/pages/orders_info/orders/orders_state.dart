part of 'orders_page.dart';

enum OrdersStateStatus {
  initial,
  dataLoaded,
  orderAdded,
  loadInProgress,
  loadConfirmation,
  loadDeclined,
  loadFailure,
  loadSuccess
}

class OrdersState {
  OrdersState({
    this.status = OrdersStateStatus.initial,
    this.orderExList = const [],
    this.newOrder,
    this.message = ''
  });

  final OrdersStateStatus status;
  final List<OrderExResult> orderExList;
  final OrderExResult? newOrder;
  final String message;

  List<OrderExResult> get filteredOrderExList => orderExList
    .where((e) => !e.order.isDeleted && e.order.detailedStatus != OrderStatus.deleted)
    .toList();

  OrdersState copyWith({
    OrdersStateStatus? status,
    List<OrderExResult>? orderExList,
    OrderExResult? newOrder,
    String? message
  }) {
    return OrdersState(
      status: status ?? this.status,
      orderExList: orderExList ?? this.orderExList,
      newOrder: newOrder ?? this.newOrder,
      message: message ?? this.message
    );
  }
}
