part of 'info_page.dart';

enum InfoStateStatus {
  initial,
  startLoad,
  dataLoaded,
  success,
  failure,
  inProgress,
  saveInProgress,
  saveSuccess,
  saveFailure,
  syncInProgress,
  syncSuccess,
  syncFailure,
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial,
    this.newVersionAvailable = false,
    this.message = '',
    this.syncMessage = '',
    this.isBusy = false,
    this.appInfo
  });

  final InfoStateStatus status;
  final bool newVersionAvailable;
  final String message;
  final String syncMessage;
  final bool isBusy;
  final AppInfoResult? appInfo;

  int get pendingChanges => appInfo == null ? 0 : appInfo!.syncTotal;
  bool get hasPendingChanges => pendingChanges != 0;

  int get encashmentsTotal => appInfo == null ? 0 : appInfo!.encashmentsTotal;
  int get ordersTotal => appInfo == null ? 0 : appInfo!.ordersTotal;
  int get preOrdersTotal => appInfo == null ? 0 : appInfo!.preOrdersTotal;
  int get shipmentsTotal => appInfo == null ? 0 : appInfo!.shipmentsTotal;
  int get pointsTotal => appInfo == null ? 0 : appInfo!.pointsTotal;

  InfoState copyWith({
    InfoStateStatus? status,
    bool? newVersionAvailable,
    String? message,
    String? syncMessage,
    bool? isBusy,
    AppInfoResult? appInfo
  }) {
    return InfoState(
      status: status ?? this.status,
      newVersionAvailable: newVersionAvailable ?? this.newVersionAvailable,
      message: message ?? this.message,
      syncMessage: syncMessage ?? this.syncMessage,
      isBusy: isBusy ?? this.isBusy,
      appInfo: appInfo ?? this.appInfo
    );
  }
}
