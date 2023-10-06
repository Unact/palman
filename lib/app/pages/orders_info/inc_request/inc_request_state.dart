part of 'inc_request_page.dart';

enum IncRequestStateStatus {
  initial,
  dataLoaded,
  incRequestUpdated
}

class IncRequestState {
  IncRequestState({
    this.status = IncRequestStateStatus.initial,
    required this.incRequestEx,
    this.message = '',
    this.workdates = const [],
    this.buyerExList = const []
  });

  final IncRequestStateStatus status;
  final IncRequestEx incRequestEx;
  final List<Workdate> workdates;
  final List<BuyerEx> buyerExList;
  final String message;

  bool get isEditable => incRequestEx.incRequest.isNew;

  IncRequestState copyWith({
    IncRequestStateStatus? status,
    IncRequestEx? incRequestEx,
    String? message,
    List<Workdate>? workdates,
    List<BuyerEx>? buyerExList
  }) {
    return IncRequestState(
      status: status ?? this.status,
      incRequestEx: incRequestEx ?? this.incRequestEx,
      message: message ?? this.message,
      workdates: workdates ?? this.workdates,
      buyerExList: buyerExList ?? this.buyerExList
    );
  }
}
