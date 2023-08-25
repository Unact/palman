part of 'inc_requests_page.dart';

enum IncRequestsStateStatus {
  initial,
  dataLoaded,
  incRequestAdded
}

class IncRequestsState {
  IncRequestsState({
    this.status = IncRequestsStateStatus.initial,
    this.buyers = const [],
    this.incRequestExList = const [],
    this.newIncRequest
  });

  final IncRequestsStateStatus status;
  final List<Buyer> buyers;
  final List<IncRequestEx> incRequestExList;
  final IncRequestEx? newIncRequest;

  IncRequestsState copyWith({
    IncRequestsStateStatus? status,
    List<Buyer>? buyers,
    List<IncRequestEx>? incRequestExList,
    IncRequestEx? newIncRequest
  }) {
    return IncRequestsState(
      status: status ?? this.status,
      buyers: buyers ?? this.buyers,
      incRequestExList: incRequestExList ?? this.incRequestExList,
      newIncRequest: newIncRequest ?? this.newIncRequest
    );
  }
}
