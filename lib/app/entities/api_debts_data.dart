part of 'entities.dart';

class ApiDebtsData extends Equatable {
  final List<ApiDebt> debts;
  final List<ApiPreEncashment> preEncashments;
  final List<ApiDeposit> deposits;

  const ApiDebtsData({
    required this.debts,
    required this.preEncashments,
    required this.deposits
  });

  factory ApiDebtsData.fromJson(Map<String, dynamic> json) {
    List<ApiDebt> debts = json['debts'].map<ApiDebt>((e) => ApiDebt.fromJson(e)).toList();
    List<ApiPreEncashment> preEncashments = json['preEncashments'].map<ApiPreEncashment>(
      (e) => ApiPreEncashment.fromJson(e)
    ).toList();
    List<ApiDeposit> deposits = json['deposits'].map<ApiDeposit>((e) => ApiDeposit.fromJson(e)).toList();

    return ApiDebtsData(
      debts: debts,
      preEncashments: preEncashments,
      deposits: deposits
    );
  }

  @override
  List<Object> get props => [
    debts,
    preEncashments,
    deposits
  ];
}
