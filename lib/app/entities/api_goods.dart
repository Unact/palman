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
  final double? handPrice;
  final String extraLabel;
  final int rel;
  final int package;
  final int categoryUserPackageRel;
  final int categoryPackageRel;
  final int categoryBlockRel;
  final double weight;
  final double volume;
  final bool isFridge;
  final int shelfLife;
  final String shelfLifeTypeName;
  final List<String> barcodes;
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
    this.handPrice,
    required this.extraLabel,
    required this.rel,
    required this.package,
    required this.categoryUserPackageRel,
    required this.categoryPackageRel,
    required this.categoryBlockRel,
    required this.weight,
    required this.volume,
    required this.isFridge,
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
      handPrice: Parsing.parseDouble(json['handPrice']),
      extraLabel: json['extraLabel'],
      rel: json['rel'],
      package: json['package'],
      categoryUserPackageRel: json['categoryUserPackageRel'],
      categoryPackageRel: json['categoryPackageRel'],
      categoryBlockRel: json['categoryBlockRel'],
      weight: Parsing.parseDouble(json['weight'])!,
      volume: Parsing.parseDouble(json['volume'])!,
      isFridge: json['isFridge'],
      shelfLife: json['shelfLife'],
      shelfLifeTypeName: json['shelfLifeTypeName'],
      barcodes: json['barcodes'].cast<String>(),
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
      handPrice: handPrice,
      extraLabel: extraLabel,
      rel: rel,
      package: package,
      categoryUserPackageRel: categoryUserPackageRel,
      categoryPackageRel: categoryPackageRel,
      categoryBlockRel: categoryBlockRel,
      weight: weight,
      volume: volume,
      isFridge: isFridge,
      shelfLife: shelfLife,
      shelfLifeTypeName: shelfLifeTypeName,
      barcodes: barcodes,
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
    handPrice,
    extraLabel,
    rel,
    package,
    categoryUserPackageRel,
    categoryPackageRel,
    categoryBlockRel,
    weight,
    volume,
    isFridge,
    shelfLife,
    shelfLifeTypeName,
    barcodes,
    isOrderable,
    forPhysical,
    onlyWithDocs
  ];
}
