part of 'entities.dart';

class ApiBuyersSetsBonusProgram extends Equatable {
  final int buyersSetId;
  final int bonusProgramId;

  const ApiBuyersSetsBonusProgram({
    required this.buyersSetId,
    required this.bonusProgramId
  });

  factory ApiBuyersSetsBonusProgram.fromJson(dynamic json) {
    return ApiBuyersSetsBonusProgram(
      buyersSetId: json['buyersSetId'],
      bonusProgramId: json['bonusProgramId']
    );
  }

  BuyersSetsBonusProgram toDatabaseEnt() {
    return BuyersSetsBonusProgram(
      buyersSetId: buyersSetId,
      bonusProgramId: bonusProgramId
    );
  }

  @override
  List<Object> get props => [
    buyersSetId,
    bonusProgramId
  ];
}
