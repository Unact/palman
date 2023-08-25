part of 'entities.dart';

class ApiBonusProgramsData extends Equatable {
  final List<ApiBonusProgramGroup> bonusProgramGroups;
  final List<ApiBonusProgram> bonusPrograms;
  final List<ApiBuyersSet> buyerSets;
  final List<ApiBuyersSetsBonusProgram> buyerSetBonusPrograms;
  final List<ApiBuyersSetsBuyer> buyersSetsBuyers;
  final List<ApiGoodsBonusProgram> goodsBonusPrograms;
  final List<ApiGoodsBonusProgramPrice> goodsBonusProgramPrices;

  const ApiBonusProgramsData({
    required this.bonusProgramGroups,
    required this.bonusPrograms,
    required this.buyerSets,
    required this.buyerSetBonusPrograms,
    required this.buyersSetsBuyers,
    required this.goodsBonusPrograms,
    required this.goodsBonusProgramPrices
  });

  factory ApiBonusProgramsData.fromJson(Map<String, dynamic> json) {
    List<ApiBonusProgramGroup> bonusProgramGroups = json['bonusProgramGroups']
      .map<ApiBonusProgramGroup>((e) => ApiBonusProgramGroup.fromJson(e)).toList();
    List<ApiBonusProgram> bonusPrograms = json['bonusPrograms']
      .map<ApiBonusProgram>((e) => ApiBonusProgram.fromJson(e)).toList();
    List<ApiBuyersSet> buyerSets = json['buyersSets']
      .map<ApiBuyersSet>((e) => ApiBuyersSet.fromJson(e)).toList();
    List<ApiBuyersSetsBonusProgram> buyerSetBonusPrograms = json['buyersSetsBonusPrograms']
      .map<ApiBuyersSetsBonusProgram>((e) => ApiBuyersSetsBonusProgram.fromJson(e)).toList();
    List<ApiBuyersSetsBuyer> buyersSetsBuyers = json['buyersSetsBuyers']
      .map<ApiBuyersSetsBuyer>((e) => ApiBuyersSetsBuyer.fromJson(e)).toList();
    List<ApiGoodsBonusProgram> goodsBonusPrograms = json['goodsBonusPrograms']
      .map<ApiGoodsBonusProgram>((e) => ApiGoodsBonusProgram.fromJson(e)).toList();
    List<ApiGoodsBonusProgramPrice> goodsBonusProgramPrices = json['goodsBonusProgramPrices']
      .map<ApiGoodsBonusProgramPrice>((e) => ApiGoodsBonusProgramPrice.fromJson(e)).toList();

    return ApiBonusProgramsData(
      bonusProgramGroups: bonusProgramGroups,
      bonusPrograms: bonusPrograms,
      buyerSets: buyerSets,
      buyerSetBonusPrograms: buyerSetBonusPrograms,
      buyersSetsBuyers: buyersSetsBuyers,
      goodsBonusPrograms: goodsBonusPrograms,
      goodsBonusProgramPrices: goodsBonusProgramPrices
    );
  }

  @override
  List<Object> get props => [
    bonusProgramGroups,
    bonusPrograms,
    buyerSets,
    buyerSetBonusPrograms,
    buyersSetsBuyers,
    goodsBonusPrograms,
    goodsBonusProgramPrices
  ];
}
