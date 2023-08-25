part of 'encashment_page.dart';

enum EncashmentStateStatus {
  initial,
  dataLoaded,
  encashmentUpdated
}

class EncashmentState {
  EncashmentState({
    this.status = EncashmentStateStatus.initial,
    required this.encashmentEx,
    this.message = ''
  });

  final EncashmentStateStatus status;
  final EncashmentEx encashmentEx;
  final String message;

  bool get isEditable => encashmentEx.deposit == null;

  EncashmentState copyWith({
    EncashmentStateStatus? status,
    EncashmentEx? encashmentEx,
    String? message
  }) {
    return EncashmentState(
      status: status ?? this.status,
      encashmentEx: encashmentEx ?? this.encashmentEx,
      message: message ?? this.message
    );
  }
}
