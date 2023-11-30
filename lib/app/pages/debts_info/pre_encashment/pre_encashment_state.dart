part of 'pre_encashment_page.dart';

enum PreEncashmentStateStatus {
  initial,
  dataLoaded,
  encashmentUpdated
}

class PreEncashmentState {
  PreEncashmentState({
    this.status = PreEncashmentStateStatus.initial,
    required this.preEncashmentEx,
    this.message = ''
  });

  final PreEncashmentStateStatus status;
  final PreEncashmentEx preEncashmentEx;
  final String message;

  PreEncashmentState copyWith({
    PreEncashmentStateStatus? status,
    PreEncashmentEx? preEncashmentEx,
    String? message
  }) {
    return PreEncashmentState(
      status: status ?? this.status,
      preEncashmentEx: preEncashmentEx ?? this.preEncashmentEx,
      message: message ?? this.message
    );
  }
}
