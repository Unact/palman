part of 'entities.dart';

class ApiPricelistSetCategory extends Equatable {
  final int pricelistSetId;
  final int categoryId;

  const ApiPricelistSetCategory({
    required this.pricelistSetId,
    required this.categoryId
  });

  factory ApiPricelistSetCategory.fromJson(dynamic json) {
    return ApiPricelistSetCategory(
      pricelistSetId: json['pricelistSetId'],
      categoryId: json['categoryId']
    );
  }

  PricelistSetCategory toDatabaseEnt() {
    return PricelistSetCategory(
      pricelistSetId: pricelistSetId,
      categoryId: categoryId
    );
  }

  @override
  List<Object> get props => [
    pricelistSetId,
    categoryId
  ];
}
