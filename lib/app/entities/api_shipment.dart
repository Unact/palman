part of 'entities.dart';

class ApiShipment extends Equatable {
  final int id;
  final DateTime date;
  final String ndoc;
  final String info;
  final String status;
  final double? debtSum;
  final double shipmentSum;
  final int buyerId;
  final List<ApiShipmentLine> lines;

  const ApiShipment({
    required this.id,
    required this.date,
    required this.ndoc,
    required this.info,
    required this.status,
    this.debtSum,
    required this.shipmentSum,
    required this.buyerId,
    required this.lines
  });

  factory ApiShipment.fromJson(dynamic json) {
    return ApiShipment(
      id: json['id'],
      date: Parsing.parseDate(json['date'])!,
      ndoc: json['ndoc'],
      info: json['info'],
      status: json['status'],
      debtSum: Parsing.parseDouble(json['debtSum']),
      shipmentSum: Parsing.parseDouble(json['shipmentSum'])!,
      buyerId: json['buyerId'],
      lines: json['lines'].map<ApiShipmentLine>((e) => ApiShipmentLine.fromJson(e)).toList()
    );
  }

  Shipment toDatabaseEnt() {
    return Shipment(
      id: id,
      date: date,
      ndoc: ndoc,
      info: info,
      status: status,
      debtSum: debtSum,
      shipmentSum: shipmentSum,
      buyerId: buyerId
    );
  }

  @override
  List<Object?> get props => [
    id,
    date,
    ndoc,
    info,
    status,
    debtSum,
    shipmentSum,
    buyerId,
    lines
  ];
}
