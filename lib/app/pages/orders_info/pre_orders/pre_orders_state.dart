part of 'pre_orders_page.dart';

enum PreOrdersStateStatus {
  initial,
  dataLoaded
}

class PreOrdersState {
  PreOrdersState({
    this.status = PreOrdersStateStatus.initial,
    this.preOrderExList = const []
  });

  final PreOrdersStateStatus status;
  final List<PreOrderExResult> preOrderExList;

  PreOrdersState copyWith({
    PreOrdersStateStatus? status,
    List<PreOrderExResult>? preOrderExList,
  }) {
    return PreOrdersState(
      status: status ?? this.status,
      preOrderExList: preOrderExList ?? this.preOrderExList
    );
  }
}
