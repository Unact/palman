part of 'orders_info_page.dart';

enum OrdersInfoStateStatus {
  initial
}

class OrdersInfoState {
  OrdersInfoState({
    this.status = OrdersInfoStateStatus.initial
  });

  final OrdersInfoStateStatus status;

  OrdersInfoState copyWith({
    OrdersInfoStateStatus? status
  }) {
    return OrdersInfoState(
      status: status ?? this.status
    );
  }
}
