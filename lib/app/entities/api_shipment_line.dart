part of 'entities.dart';

class ApiShipmentLine extends Equatable {
  final int id;
  final int goodsId;
  final double price;
  final double vol;

  const ApiShipmentLine({
    required this.id,
    required this.goodsId,
    required this.price,
    required this.vol
  });

  factory ApiShipmentLine.fromJson(dynamic json) {
    return ApiShipmentLine(
      id: json['id'],
      goodsId: json['goodsId'],
      price: Parsing.parseDouble(json['price'])!,
      vol: Parsing.parseDouble(json['vol'])!
    );
  }

  ShipmentLine toDatabaseEnt(int shipmentId) {
    return ShipmentLine(
      id: id,
      shipmentId: shipmentId,
      goodsId: goodsId,
      price: price,
      vol: vol
    );
  }

  @override
  List<Object?> get props => [
    id,
    goodsId,
    price,
    vol
  ];
}
