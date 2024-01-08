part of 'return_act_page.dart';

enum ReturnActStateStatus {
  initial,
  dataLoaded,
  returnActUpdated,
  returnActCopied,
  returnActLineDeleted,
  returnActRemoved,
  inProgress,
  success,
  failure
}

class ReturnActState {
  ReturnActState({
    this.status = ReturnActStateStatus.initial,
    required this.returnActEx,
    this.user,
    this.message = '',
    this.linesExList = const [],
    this.workdates = const [],
    this.buyerExList = const [],
    this.newReturnAct,
    this.appInfo,
    this.returnActTypes = const [],
    this.receptExList = const []
  });

  final ReturnActStateStatus status;

  final User? user;
  final ReturnActExResult returnActEx;
  final String message;
  final List<ReturnActLineExResult> linesExList;
  final List<Workdate> workdates;
  final List<BuyerEx> buyerExList;
  final List<ReceptExResult> receptExList;
  final ReturnActExResult? newReturnAct;
  final AppInfoResult? appInfo;
  final List<ReturnActType> returnActTypes;

  bool get isEditable => returnActEx.returnAct.isNew;
  bool get isLineEditable => returnActEx.returnAct.returnActTypeId != null && isEditable;

  List<ReturnActLineExResult> get filteredReturnActLinesExList => linesExList.where((e) => !e.line.isDeleted).toList();

  bool get returnactNeedSync => returnActEx.returnAct.needSync || linesExList.any((e) => e.line.needSync);

  int get pendingChanges => appInfo == null ?
    0 :
    (returnactNeedSync ? 1 : 0) +
    appInfo!.partnerPricesToSync +
    appInfo!.partnersPricelistsToSync;

  ReturnActState copyWith({
    ReturnActStateStatus? status,
    User? user,
    String? message,
    ReturnActExResult? returnActEx,
    List<ReturnActLineExResult>? linesExList,
    List<Workdate>? workdates,
    List<BuyerEx>? buyerExList,
    ReturnActExResult? newReturnAct,
    AppInfoResult? appInfo,
    List<ReturnActType>? returnActTypes,
    List<ReceptExResult>? receptExList
  }) {
    return ReturnActState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
      returnActEx: returnActEx ?? this.returnActEx,
      linesExList: linesExList ?? this.linesExList,
      workdates: workdates ?? this.workdates,
      buyerExList: buyerExList ?? this.buyerExList,
      newReturnAct: newReturnAct ?? this.newReturnAct,
      appInfo: appInfo ?? this.appInfo,
      returnActTypes: returnActTypes ?? this.returnActTypes,
      receptExList: receptExList ?? this.receptExList
    );
  }
}
