part of 'entities.dart';

class ApiPreOrderLine extends Equatable {
  final int id;
  final int goodsId;
  final double vol;
  final double price;
  final int package;
  final int rel;

  const ApiPreOrderLine({
    required this.id,
    required this.goodsId,
    required this.vol,
    required this.price,
    required this.package,
    required this.rel
  });

  factory ApiPreOrderLine.fromJson(dynamic json) {
    return ApiPreOrderLine(
      id: json['id'],
      goodsId: json['goodsId'],
      vol: Parsing.parseDouble(json['vol'])!,
      price: Parsing.parseDouble(json['price'])!,
      package: json['package'],
      rel: json['rel']
    );
  }

  PreOrderLine toDatabaseEnt(int preOrderId) {
    return PreOrderLine(
      id: id,
      preOrderId: preOrderId,
      goodsId: goodsId,
      vol: vol,
      price: price,
      package: package,
      rel: rel
    );
  }

  @override
  List<Object> get props => [
    id,
    goodsId,
    vol,
    price,
    package,
    rel
  ];
}
