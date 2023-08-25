part of 'entities.dart';

class ApiPricesData extends Equatable {
  final List<ApiPartnersPrice> partnersPrices;
  final List<ApiPricelistPrice> pricelistPrices;
  final List<ApiPartnersPricelist> partnersPricelists;
  final List<ApiGoodsPartnersPricelist> goodsPartnersPricelists;

  const ApiPricesData({
    required this.partnersPrices,
    required this.pricelistPrices,
    required this.partnersPricelists,
    required this.goodsPartnersPricelists
  });

  factory ApiPricesData.fromJson(Map<String, dynamic> json) {
    List<ApiPartnersPrice> partnerPrices = json['partnersPrices']
      .map<ApiPartnersPrice>((e) => ApiPartnersPrice.fromJson(e)).toList();
    List<ApiPricelistPrice> pricelistPrices = json['pricelistPrices']
      .map<ApiPricelistPrice>((e) => ApiPricelistPrice.fromJson(e)).toList();
    List<ApiPartnersPricelist> partnersPricelists = json['partnersPricelists']
      .map<ApiPartnersPricelist>((e) => ApiPartnersPricelist.fromJson(e)).toList();
    List<ApiGoodsPartnersPricelist> goodsPartnersPricelists = json['goodsPartnersPricelists']
      .map<ApiGoodsPartnersPricelist>((e) => ApiGoodsPartnersPricelist.fromJson(e)).toList();

    return ApiPricesData(
      partnersPrices: partnerPrices,
      pricelistPrices: pricelistPrices,
      partnersPricelists: partnersPricelists,
      goodsPartnersPricelists: goodsPartnersPricelists
    );
  }

  @override
  List<Object> get props => [
    partnersPrices,
    pricelistPrices,
    partnersPricelists,
    goodsPartnersPricelists
  ];
}
