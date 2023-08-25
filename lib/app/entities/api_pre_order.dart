part of 'entities.dart';

class ApiPreOrder extends Equatable {
  final int id;
  final DateTime date;
  final int buyerId;
  final bool needDocs;
  final String? info;
  final List<ApiPreOrderLine> lines;

  const ApiPreOrder({
    required this.id,
    required this.date,
    required this.buyerId,
    required this.needDocs,
    this.info,
    required this.lines
  });

  factory ApiPreOrder.fromJson(dynamic json) {
    return ApiPreOrder(
      id: json['id'],
      date: Parsing.parseDate(json['date'])!,
      buyerId: json['buyerId'],
      needDocs: json['needDocs'],
      info: json['info'],
      lines: json['lines'].map<ApiPreOrderLine>((e) => ApiPreOrderLine.fromJson(e)).toList()
    );
  }

  PreOrder toDatabaseEnt() {
    return PreOrder(
      id: id,
      date: date,
      buyerId: buyerId,
      needDocs: needDocs,
      info: info
    );
  }

  @override
  List<Object?> get props => [
    id,
    date,
    buyerId,
    needDocs,
    info,
    lines
  ];
}
