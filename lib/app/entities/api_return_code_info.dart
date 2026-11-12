part of 'entities.dart';

class ApiReturnCodeInfo extends Equatable {
  final String code;
  final String gtin;
  final int vol;

  const ApiReturnCodeInfo({
    required this.code,
    required this.gtin,
    required this.vol
  });

  factory ApiReturnCodeInfo.fromJson(Map<String, dynamic> json) {
    return ApiReturnCodeInfo(
      code: json['code'],
      gtin: json['gtin'],
      vol: json['vol']
    );
  }

  @override
  List<Object?> get props => [
    code,
    gtin,
    vol
  ];
}
