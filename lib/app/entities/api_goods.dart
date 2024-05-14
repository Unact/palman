part of 'entities.dart';

class ApiGoods extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final String imageKey;
  final int categoryId;
  final String? manufacturer;
  final bool isLatest;
  final int pricelistSetId;
  final double cost;
  final double minPrice;
  final String extraLabel;
  final int orderRel;
  final int orderPackage;
  final int categoryBoxRel;
  final int categoryBlockRel;
  final double weight;
  final double volume;
  final int shelfLife;
  final String shelfLifeTypeName;
  final EqualList<String> barcodes;
  final bool isOrderable;
  final bool forPhysical;
  final bool onlyWithDocs;

  const ApiGoods({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.imageKey,
    required this.categoryId,
    this.manufacturer,
    required this.isLatest,
    required this.pricelistSetId,
    required this.cost,
    required this.minPrice,
    required this.extraLabel,
    required this.orderRel,
    required this.orderPackage,
    required this.categoryBoxRel,
    required this.categoryBlockRel,
    required this.weight,
    required this.volume,
    required this.shelfLife,
    required this.shelfLifeTypeName,
    required this.barcodes,
    required this.isOrderable,
    required this.forPhysical,
    required this.onlyWithDocs
  });

  factory ApiGoods.fromJson(dynamic json) {
    return ApiGoods(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      imageKey: json['imageKey'],
      categoryId: json['categoryId'],
      manufacturer: json['manufacturer'],
      isLatest: json['isLatest'],
      pricelistSetId: json['pricelistSetId'],
      cost: Parsing.parseDouble(json['cost'])!,
      minPrice: Parsing.parseDouble(json['minPrice'])!,
      extraLabel: json['extraLabel'],
      orderRel: json['orderRel'],
      orderPackage: json['orderPackage'],
      categoryBoxRel: json['categoryBoxRel'],
      categoryBlockRel: json['categoryBlockRel'],
      weight: Parsing.parseDouble(json['weight'])!,
      volume: Parsing.parseDouble(json['volume'])!,
      shelfLife: json['shelfLife'],
      shelfLifeTypeName: json['shelfLifeTypeName'],
      barcodes: EqualList(json['barcodes'].cast<String>()),
      isOrderable: json['isOrderable'],
      forPhysical: json['forPhysical'],
      onlyWithDocs: json['onlyWithDocs']
    );
  }

  Goods toDatabaseEnt() {
    return Goods(
      id: id,
      name: name,
      imageUrl: imageUrl,
      imageKey: imageKey,
      categoryId: categoryId,
      manufacturer: manufacturer,
      isLatest: isLatest,
      pricelistSetId: pricelistSetId,
      cost: cost,
      minPrice: minPrice,
      extraLabel: extraLabel,
      orderRel: orderRel,
      orderPackage: orderPackage,
      categoryBoxRel: categoryBoxRel,
      categoryBlockRel: categoryBlockRel,
      weight: weight,
      volume: volume,
      shelfLife: shelfLife,
      shelfLifeTypeName: shelfLifeTypeName,
      barcodes: EqualList(barcodes),
      isOrderable: isOrderable,
      forPhysical: forPhysical,
      onlyWithDocs: onlyWithDocs
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    imageKey,
    categoryId,
    manufacturer,
    isLatest,
    pricelistSetId,
    cost,
    minPrice,
    extraLabel,
    orderRel,
    orderPackage,
    categoryBoxRel,
    categoryBlockRel,
    weight,
    volume,
    shelfLife,
    shelfLifeTypeName,
    barcodes,
    isOrderable,
    forPhysical,
    onlyWithDocs
  ];
}
