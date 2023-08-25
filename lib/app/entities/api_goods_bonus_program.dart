part of 'entities.dart';

class ApiGoodsBonusProgram extends Equatable {
  final int bonusProgramId;
  final int goodsId;

  const ApiGoodsBonusProgram({
    required this.bonusProgramId,
    required this.goodsId,
  });

  factory ApiGoodsBonusProgram.fromJson(dynamic json) {
    return ApiGoodsBonusProgram(
      bonusProgramId: json['bonusProgramId'],
      goodsId: json['goodsId']
    );
  }

  GoodsBonusProgram toDatabaseEnt() {
    return GoodsBonusProgram(
      bonusProgramId: bonusProgramId,
      goodsId: goodsId
    );
  }

  @override
  List<Object> get props => [
    bonusProgramId,
    goodsId
  ];
}
