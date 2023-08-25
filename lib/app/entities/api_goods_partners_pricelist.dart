part of 'entities.dart';

class ApiGoodsPartnersPricelist extends Equatable {
  final int goodsId;
  final int partnerPricelistId;
  final int pricelistId;
  final double discount;

  const ApiGoodsPartnersPricelist({
    required this.goodsId,
    required this.partnerPricelistId,
    required this.pricelistId,
    required this.discount
  });

  factory ApiGoodsPartnersPricelist.fromJson(dynamic json) {
    return ApiGoodsPartnersPricelist(
      goodsId: json['goodsId'],
      partnerPricelistId: json['partnerPricelistId'],
      pricelistId: json['pricelistId'],
      discount: Parsing.parseDouble(json['discount'])!
    );
  }

  GoodsPartnersPricelist toDatabaseEnt() {
    return GoodsPartnersPricelist(
      goodsId: goodsId,
      partnerPricelistId: partnerPricelistId,
      pricelistId: pricelistId,
      discount: discount
    );
  }

  @override
  List<Object> get props => [
    goodsId,
    partnerPricelistId,
    pricelistId,
    discount
  ];
}
