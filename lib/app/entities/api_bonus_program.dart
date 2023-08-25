part of 'entities.dart';

class ApiBonusProgram extends Equatable {
  final int id;
  final String name;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String condition;
  final String present;
  final String tagText;
  final int? discountPercent;
  final double coef;
  final int conditionalDiscount;
  final int bonusProgramGroupId;

  const ApiBonusProgram({
    required this.id,
    required this.name,
    required this.dateFrom,
    required this.dateTo,
    required this.condition,
    required this.present,
    required this.tagText,
    this.discountPercent,
    required this.coef,
    required this.conditionalDiscount,
    required this.bonusProgramGroupId
  });

  factory ApiBonusProgram.fromJson(dynamic json) {
    return ApiBonusProgram(
      id: json['id'],
      name: json['name'],
      dateFrom: Parsing.parseDate(json['dateFrom'])!,
      dateTo: Parsing.parseDate(json['dateTo'])!,
      condition: json['condition'],
      present: json['present'],
      tagText: json['tagText'],
      discountPercent: json['discountPercent'],
      coef: Parsing.parseDouble(json['coef'])!,
      conditionalDiscount: json['conditionalDiscount'],
      bonusProgramGroupId: json['bonusProgramGroupId']
    );
  }

  BonusProgram toDatabaseEnt() {
    return BonusProgram(
      id: id,
      name: name,
      dateFrom: dateFrom,
      dateTo: dateTo,
      condition: condition,
      present: present,
      tagText: tagText,
      discountPercent: discountPercent,
      coef: coef,
      conditionalDiscount: conditionalDiscount,
      bonusProgramGroupId: bonusProgramGroupId
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    dateFrom,
    dateTo,
    condition,
    present,
    tagText,
    discountPercent,
    coef,
    conditionalDiscount,
    bonusProgramGroupId
  ];
}
