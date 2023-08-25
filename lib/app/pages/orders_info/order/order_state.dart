part of 'order_page.dart';

enum OrderStateStatus {
  initial,
  dataLoaded,
  orderUpdated
}

class OrderState {
  OrderState({
    this.status = OrderStateStatus.initial,
    required this.orderEx,
    this.user,
    this.linesExList = const [],
    this.workdates = const [],
    this.buyers = const []
  });

  final OrderStateStatus status;

  final User? user;
  final OrderExResult orderEx;
  final List<OrderLineEx> linesExList;
  final List<Workdate> workdates;
  final List<Buyer> buyers;

  bool get canAddLines => orderEx.order.isEditable && orderEx.buyer != null && orderEx.order.date != null;
  List<OrderLineEx> get filteredOrderLinesExList => linesExList.where((e) => !e.line.isDeleted).toList();

  bool get preOrderMode => user?.preOrderMode ?? false;

  OrderState copyWith({
    OrderStateStatus? status,
    User? user,
    OrderExResult? orderEx,
    List<OrderLineEx>? linesExList,
    List<Workdate>? workdates,
    List<Buyer>? buyers
  }) {
    return OrderState(
      status: status ?? this.status,
      user: user ?? this.user,
      orderEx: orderEx ?? this.orderEx,
      linesExList: linesExList ?? this.linesExList,
      workdates: workdates ?? this.workdates,
      buyers: buyers ?? this.buyers
    );
  }
}
