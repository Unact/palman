part of 'database.dart';

class Prefs extends Table {
  BoolColumn get showLocalImage => boolean()();
  BoolColumn get showWithPrice => boolean()();
  DateTimeColumn get lastSyncTime => dateTime().nullable()();
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text()();
  TextColumn get salesmanName => text()();
  BoolColumn get preOrderMode => boolean()();
  TextColumn get email => text()();
  TextColumn get version => text()();
}

class Partners extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get factpayment => boolean()();
}

class Buyers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get loadto => text()();
  IntColumn get partnerId => integer()();
  IntColumn get siteId => integer()();
  IntColumn get fridgeSiteId => integer()();
}

class PointFormats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class Locations extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracy => real()();
  RealColumn get altitude => real()();
  RealColumn get heading => real()();
  RealColumn get speed => real()();
  DateTimeColumn get timestamp => dateTime()();
}

class Points extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get buyerName => text()();
  TextColumn get reason => text()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  IntColumn get pointFormat => integer().nullable()();
  IntColumn get numberOfCdesks => integer().nullable()();
  TextColumn get emailOnlineCheck => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phoneOnlineCheck => text().nullable()();
  TextColumn get inn => text().nullable()();
  TextColumn get jur => text().nullable()();
  IntColumn get plong => integer().nullable()();
  IntColumn get maxdebt => integer().nullable()();
  IntColumn get nds10 => integer().nullable()();
  IntColumn get nds20 => integer().nullable()();

  BoolColumn get isBlocked => boolean()();
  TextColumn get guid => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get needSync => boolean()();
}

class PointImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pointId => integer()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracy => real()();
  TextColumn get imageUrl => text()();
  TextColumn get imageKey => text()();

  TextColumn get guid => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get needSync => boolean()();
}

class Encashments extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isCheck => boolean()();
  IntColumn get buyerId => integer()();
  IntColumn get debtId => integer().nullable()();
  IntColumn get depositId => integer().nullable()();
  RealColumn get encSum => real().nullable()();

  TextColumn get guid => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get needSync => boolean()();
}

class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get buyerId => integer()();
  TextColumn get info => text().nullable()();
  RealColumn get debtSum => real()();
  RealColumn get orderSum => real()();
  BoolColumn get isCheck => boolean()();
  DateTimeColumn get dateUntil => dateTime()();
  BoolColumn get overdue => boolean()();
}

class Deposits extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get totalSum => real()();
  RealColumn get checkTotalSum => real()();

  BoolColumn get isBlocked => boolean()();
  TextColumn get guid => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get needSync => boolean()();
}

class Shipments extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get ndoc => text()();
  TextColumn get info => text()();
  TextColumn get status => text()();
  RealColumn get debtSum => real().nullable()();
  RealColumn get shipmentSum => real()();
  IntColumn get buyerId => integer()();
}

class ShipmentLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get shipmentId => integer()();
  IntColumn get goodsId => integer()();
  RealColumn get vol => real()();
  RealColumn get price => real()();
}

class IncRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().nullable()();
  IntColumn get buyerId => integer().nullable()();
  RealColumn get incSum => real().nullable()();
  TextColumn get info => text().nullable()();
  TextColumn get status => text()();

  BoolColumn get isBlocked => boolean()();
  TextColumn get guid => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get needSync => boolean()();
}

@DataClassName('Goods')
class AllGoods extends Table {
  @override
  String get tableName => 'goods';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get imageUrl => text()();
  TextColumn get imageKey => text()();
  IntColumn get categoryId => integer()();
  TextColumn get manufacturer => text().nullable()();
  BoolColumn get isHit => boolean()();
  BoolColumn get isNew => boolean()();
  IntColumn get pricelistSetId => integer()();
  RealColumn get cost => real()();
  RealColumn get minPrice => real()();
  RealColumn get handPrice => real().nullable()();
  TextColumn get extraLabel => text()();
  IntColumn get package => integer()();
  IntColumn get rel => integer()();
  IntColumn get categoryUserPackageRel => integer()();
  IntColumn get categoryPackageRel => integer()();
  IntColumn get categoryBlockRel => integer()();
  RealColumn get weight => real()();
  RealColumn get mcVol => real()();
  BoolColumn get isFridge => boolean()();
  IntColumn get shelfLife => integer()();
  TextColumn get shelfLifeTypeName => text()();
}

class Workdates extends Table {
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {date};
}

class ShopDepartments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get ord => integer()();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get ord => integer()();
  IntColumn get shopDepartmentId => integer()();
  IntColumn get package => integer()();
  IntColumn get userPackage => integer()();
}

class GoodsFilters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get value => text()();
}

class BonusProgramGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class BonusPrograms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get dateFrom => dateTime()();
  DateTimeColumn get dateTo => dateTime()();
  TextColumn get condition => text()();
  TextColumn get present => text()();
  TextColumn get tagText => text()();
  IntColumn get discountPercent => integer().nullable()();
  RealColumn get coef => real()();
  IntColumn get conditionalDiscount => integer()();
  IntColumn get bonusProgramGroupId => integer()();
}

class BuyersSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isForAll => boolean()();
}

class BuyersSetsBonusPrograms extends Table {
  IntColumn get buyersSetId => integer()();
  IntColumn get bonusProgramId => integer()();

  @override
  Set<Column> get primaryKey => {buyersSetId, bonusProgramId};
}

class BuyersSetsBuyers extends Table {
  IntColumn get buyersSetId => integer()();
  IntColumn get buyerId => integer()();

  @override
  Set<Column> get primaryKey => {buyersSetId, buyerId};
}

class GoodsBonusPrograms extends Table {
  IntColumn get bonusProgramId => integer()();
  IntColumn get goodsId => integer()();

  @override
  Set<Column> get primaryKey => {bonusProgramId, goodsId};
}

class GoodsBonusProgramPrices extends Table {
  IntColumn get bonusProgramId => integer()();
  IntColumn get goodsId => integer()();
  RealColumn get price => real()();

  @override
  Set<Column> get primaryKey => {bonusProgramId, goodsId};
}

class Pricelists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get permit => boolean()();
}

@DataClassName('PricelistSetCategory')
class PricelistSetCategories extends Table {
  IntColumn get pricelistSetId => integer()();
  IntColumn get categoryId => integer()();

  @override
  Set<Column> get primaryKey => {pricelistSetId, categoryId};
}

class PartnersPrices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goodsId => integer()();
  IntColumn get partnerId => integer()();
  RealColumn get price => real()();
  DateTimeColumn get dateFrom => dateTime()();
  DateTimeColumn get dateTo => dateTime()();

  BoolColumn get isBlocked => boolean()();
  TextColumn get guid => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get needSync => boolean()();
}

class PricelistPrices extends Table {
  IntColumn get goodsId => integer()();
  IntColumn get pricelistId => integer()();
  RealColumn get price => real()();
  DateTimeColumn get dateFrom => dateTime()();
  DateTimeColumn get dateTo => dateTime()();
}

class PartnersPricelists extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partnerId => integer()();
  IntColumn get pricelistId => integer()();
  IntColumn get pricelistSetId => integer()();
  RealColumn get discount => real()();

  BoolColumn get isBlocked => boolean()();
  TextColumn get guid => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get needSync => boolean()();
}

class GoodsRestrictions extends Table {
  IntColumn get goodsId => integer()();
  IntColumn get buyerId => integer()();

  @override
  Set<Column> get primaryKey => {goodsId, buyerId};
}

class GoodsStocks extends Table {
  IntColumn get goodsId => integer()();
  IntColumn get siteId => integer()();
  BoolColumn get isVollow => boolean()();
  RealColumn get factor => real()();
  RealColumn get vol => real()();

  @override
  Set<Column> get primaryKey => {goodsId, siteId};
}

class GoodsPartnersPricelists extends Table {
  IntColumn get goodsId => integer()();
  IntColumn get partnerPricelistId => integer()();
  IntColumn get pricelistId => integer()();
  RealColumn get discount => real()();

  @override
  Set<Column> get primaryKey => {goodsId, partnerPricelistId, pricelistId};
}

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get status => text()();
  IntColumn get preOrderId => integer().nullable()();
  BoolColumn get needDocs => boolean()();
  BoolColumn get needInc => boolean()();
  BoolColumn get isBonus => boolean()();
  BoolColumn get isPhysical => boolean()();
  IntColumn get buyerId => integer().nullable()();
  TextColumn get info => text().nullable()();
  BoolColumn get needProcessing => boolean()();

  BoolColumn get isBlocked => boolean()();
  BoolColumn get isEditable => boolean()();
  BoolColumn get isDeleted => boolean()();
  TextColumn get guid => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get needSync => boolean()();
}

class OrderLines extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get orderId => integer()();
  IntColumn get goodsId => integer()();
  RealColumn get vol => real()();
  RealColumn get price => real()();
  RealColumn get priceOriginal => real()();
  IntColumn get package => integer()();
  IntColumn get rel => integer()();

  TextColumn get guid => text().nullable()();
  BoolColumn get isDeleted => boolean()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get needSync => boolean()();
}

class PreOrders extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get date => dateTime()();
  IntColumn get buyerId => integer()();
  BoolColumn get needDocs => boolean()();
  TextColumn get info => text().nullable()();
}

class PreOrderLines extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get preOrderId => integer()();
  IntColumn get goodsId => integer()();
  RealColumn get vol => real()();
  RealColumn get price => real()();
  IntColumn get package => integer()();
  IntColumn get rel => integer()();
}

class SeenPreOrders extends Table {
  IntColumn get id => integer().autoIncrement()();
}
