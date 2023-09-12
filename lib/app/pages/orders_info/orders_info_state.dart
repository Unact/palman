part of 'orders_info_page.dart';

enum OrdersInfoStateStatus {
  initial,
  dataLoaded
}

class OrdersInfoState {
  OrdersInfoState({
    this.status = OrdersInfoStateStatus.initial,
    this.preOrderExList = const []
  });

  final OrdersInfoStateStatus status;
  final List<PreOrderExResult> preOrderExList;

  int get notSeenCnt => preOrderExList.where((e) => !e.wasSeen).length;

  OrdersInfoState copyWith({
    OrdersInfoStateStatus? status,
    List<PreOrderExResult>? preOrderExList,
  }) {
    return OrdersInfoState(
      status: status ?? this.status,
      preOrderExList: preOrderExList ?? this.preOrderExList
    );
  }
}
