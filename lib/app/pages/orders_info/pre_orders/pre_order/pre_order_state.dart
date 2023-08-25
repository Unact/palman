part of 'pre_order_page.dart';

enum PreOrderStateStatus {
  initial,
  dataLoaded,
  orderCreated
}

class PreOrderState {
  PreOrderState({
    this.status = PreOrderStateStatus.initial,
    required this.preOrderEx,
    this.linesExList = const [],
    this.newOrder
  });

  final PreOrderStateStatus status;

  final PreOrderExResult preOrderEx;
  final List<PreOrderLineEx> linesExList;
  final OrderExResult? newOrder;

  PreOrderState copyWith({
    PreOrderStateStatus? status,
    PreOrderExResult? preOrderEx,
    List<PreOrderLineEx>? linesExList,
    OrderExResult? newOrder
  }) {
    return PreOrderState(
      status: status ?? this.status,
      preOrderEx: preOrderEx ?? this.preOrderEx,
      linesExList: linesExList ?? this.linesExList,
      newOrder: newOrder ?? this.newOrder
    );
  }
}
