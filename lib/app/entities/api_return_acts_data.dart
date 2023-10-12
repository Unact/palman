part of 'entities.dart';

class ApiReturnActsData extends Equatable {
  final List<ApiReturnAct> returnActs;

  const ApiReturnActsData({
    required this.returnActs
  });

  factory ApiReturnActsData.fromJson(Map<String, dynamic> json) {
    List<ApiReturnAct> returnActs = json['returnActs'].map<ApiReturnAct>((e) => ApiReturnAct.fromJson(e)).toList();

    return ApiReturnActsData(
      returnActs: returnActs
    );
  }

  @override
  List<Object> get props => [
    returnActs,
  ];
}
