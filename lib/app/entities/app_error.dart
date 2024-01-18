part of 'entities.dart';

class AppError implements Exception {
  final String message;

  AppError(this.message);

  @override
  String toString() => message;
}
