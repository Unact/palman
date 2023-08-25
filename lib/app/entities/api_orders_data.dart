part of 'entities.dart';

class ApiOrdersData extends Equatable {
  final List<ApiOrder> orders;
  final List<ApiPreOrder> preOrders;

  const ApiOrdersData({
    required this.orders,
    required this.preOrders,
  });

  factory ApiOrdersData.fromJson(Map<String, dynamic> json) {
    List<ApiOrder> orders = json['orders'].map<ApiOrder>((e) => ApiOrder.fromJson(e)).toList();
    List<ApiPreOrder> preOrders = json['preOrders'].map<ApiPreOrder>((e) => ApiPreOrder.fromJson(e)).toList();

    return ApiOrdersData(
      orders: orders,
      preOrders: preOrders
    );
  }

  @override
  List<Object> get props => [
    orders,
    preOrders
  ];
}
