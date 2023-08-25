part of 'entities.dart';

class ApiDebtsData extends Equatable {
  final List<ApiDebt> debts;
  final List<ApiEncashment> encashments;
  final List<ApiDeposit> deposits;

  const ApiDebtsData({
    required this.debts,
    required this.encashments,
    required this.deposits
  });

  factory ApiDebtsData.fromJson(Map<String, dynamic> json) {
    List<ApiDebt> debts = json['debts'].map<ApiDebt>((e) => ApiDebt.fromJson(e)).toList();
    List<ApiEncashment> encashments = json['encashments'].map<ApiEncashment>((e) => ApiEncashment.fromJson(e)).toList();
    List<ApiDeposit> deposits = json['deposits'].map<ApiDeposit>((e) => ApiDeposit.fromJson(e)).toList();

    return ApiDebtsData(
      debts: debts,
      encashments: encashments,
      deposits: deposits
    );
  }

  @override
  List<Object> get props => [
    debts,
    encashments,
    deposits
  ];
}
