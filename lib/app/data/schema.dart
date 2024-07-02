part of 'database.dart';

mixin Syncable on Table {
  TextColumn get guid => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get currentTimestamp => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncTime => dateTime().nullable()();
  BoolColumn get needSync => boolean()
    .generatedAs((isNew & isDeleted.not()) | (isNew.not() & lastSyncTime.isSmallerThan(timestamp)), stored: true)();
  BoolColumn get isNew => boolean().generatedAs(lastSyncTime.isNull())();

  @override
  Set<Column> get primaryKey => {guid};
}

mixin Imageable on Table {
  TextColumn get imageUrl => text()();
  TextColumn get imageKey => text()();
}

mixin Photoable on Table {
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracy => real()();
}

class JsonListConverter<T> extends TypeConverter<EqualList<T>, String> {
  const JsonListConverter();

  @override
  EqualList<T> fromSql(String? fromDb) {
    return EqualList<T>((json.decode(fromDb!) as List).cast<T>());
  }

  @override
  String toSql(EqualList<T>? value) {
    return json.encode(value);
  }
}

class Prefs extends Table {
  BoolColumn get showLocalImage => boolean()();
  BoolColumn get showWithPrice => boolean()();
  DateTimeColumn get lastLoadTime => dateTime().nullable()();
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text()();
  TextColumn get salesmanName => text()();
  BoolColumn get preOrderMode => boolean()();
  BoolColumn get closed => boolean()();
  TextColumn get email => text()();
  TextColumn get version => text()();
}

class Partners extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class Buyers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get loadto => text()();
  IntColumn get partnerId => integer()();
  IntColumn get siteId => integer()();
  IntColumn get pointId => integer().nullable()();
  TextColumn get weekdays => text().map(const JsonListConverter<bool>())();
}

class PointFormats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class Sites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class NtDeptTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class GoodsLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('GoodsListGoods')
class AllGoodsListGoods extends Table {
  @override
  String get tableName => 'goods_list_goods';

  IntColumn get goodsListId => integer()();
  IntColumn get goodsId => integer()();

  @override
  Set<Column> get primaryKey => {goodsListId, goodsId};
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
  IntColumn get batteryLevel => integer()();
  TextColumn get batteryState => text()();
}

class Points extends Table with Syncable {
  IntColumn get id => integer().nullable()();
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
  TextColumn get formsLink => text().nullable()();
  IntColumn get ntDeptTypeId => integer().nullable()();
}

class PointImages extends Table with Syncable, Photoable, Imageable {
  IntColumn get id => integer().nullable()();
  TextColumn get pointGuid => text()
    .references(Points, #guid, onUpdate: KeyAction.cascade, onDelete: KeyAction.cascade)();
}

class PreEncashments extends Table with Syncable {
  IntColumn get id => integer().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get needReceipt => boolean()();
  IntColumn get debtId => integer()();
  IntColumn get buyerId => integer()();
  TextColumn get info => text().nullable()();
  RealColumn get encSum => real().nullable()();
}

class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get buyerId => integer()();
  TextColumn get info => text().nullable()();
  RealColumn get debtSum => real()();
  RealColumn get orderSum => real()();
  BoolColumn get needReceipt => boolean()();
  DateTimeColumn get dateUntil => dateTime()();
  BoolColumn get overdue => boolean()();
}

class Deposits extends Table {
  IntColumn get id => integer()();
  DateTimeColumn get date => dateTime()();
  RealColumn get totalSum => real()();
  RealColumn get checkTotalSum => real()();
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

class IncRequests extends Table with Syncable {
  IntColumn get id => integer().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  IntColumn get buyerId => integer().nullable()();
  RealColumn get incSum => real().nullable()();
  TextColumn get info => text().nullable()();
  TextColumn get status => text()();
}

@DataClassName('Goods')
class AllGoods extends Table with Imageable {
  @override
  String get tableName => 'goods';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get categoryId => integer()();
  TextColumn get manufacturer => text().nullable()();
  BoolColumn get isLatest => boolean()();
  BoolColumn get isOrderable => boolean()();
  IntColumn get pricelistSetId => integer()();
  RealColumn get cost => real()();
  RealColumn get minPrice => real()();
  TextColumn get extraLabel => text()();
  IntColumn get orderRel => integer()();
  IntColumn get orderPackage => integer()();
  IntColumn get categoryBoxRel => integer()();
  IntColumn get categoryBlockRel => integer()();
  RealColumn get weight => real()();
  RealColumn get volume => real()();
  BoolColumn get forPhysical => boolean()();
  BoolColumn get onlyWithDocs => boolean()();
  IntColumn get shelfLife => integer()();
  TextColumn get shelfLifeTypeName => text()();
  TextColumn get barcodes => text().map(const JsonListConverter<String>())();
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

class PartnersPrices extends Table with Syncable {
  IntColumn get id => integer().nullable()();
  IntColumn get goodsId => integer()();
  IntColumn get partnerId => integer()();
  RealColumn get price => real()();
  DateTimeColumn get dateFrom => dateTime()();
  DateTimeColumn get dateTo => dateTime()();
}

class PricelistPrices extends Table {
  IntColumn get goodsId => integer()();
  IntColumn get pricelistId => integer()();
  RealColumn get price => real()();
  DateTimeColumn get dateFrom => dateTime()();
  DateTimeColumn get dateTo => dateTime()();
}

class PartnersPricelists extends Table with Syncable {
  IntColumn get id => integer().nullable()();
  IntColumn get partnerId => integer()();
  IntColumn get pricelistId => integer()();
  IntColumn get pricelistSetId => integer()();
  RealColumn get discount => real()();
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
  IntColumn get vol => integer()();
  IntColumn get minVol => integer()();

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

class Orders extends Table with Syncable {
  IntColumn get id => integer().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get status => text()();
  IntColumn get preOrderId => integer().nullable()();
  BoolColumn get needDocs => boolean()();
  BoolColumn get needInc => boolean()();
  BoolColumn get isPhysical => boolean()();
  IntColumn get buyerId => integer().nullable()();
  TextColumn get info => text().nullable()();
  BoolColumn get needProcessing => boolean()();
  BoolColumn get isEditable => boolean()();
}

class OrderLines extends Table with Syncable {
  IntColumn get id => integer().nullable()();
  TextColumn get orderGuid => text()
    .references(Orders, #guid, onUpdate: KeyAction.cascade, onDelete: KeyAction.cascade)();
  IntColumn get goodsId => integer()();
  RealColumn get vol => real()();
  RealColumn get price => real()();
  RealColumn get priceOriginal => real()();
  IntColumn get package => integer()();
  IntColumn get rel => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [{orderGuid, goodsId}];
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

class GoodsReturnStocks extends Table {
  IntColumn get goodsId => integer()();
  IntColumn get returnActTypeId => integer()();
  IntColumn get buyerId => integer()();
  RealColumn get vol => real()();
  IntColumn get receptId => integer()();
  IntColumn get receptSubid => integer()();
  DateTimeColumn get receptDate => dateTime()();
  TextColumn get receptNdoc => text()();

  @override
  Set<Column> get primaryKey => {goodsId, receptId, receptSubid, returnActTypeId};
}

class ReturnActs extends Table with Syncable {
  IntColumn get id => integer().nullable()();

  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get number => text().nullable()();
  IntColumn get buyerId => integer().nullable()();
  BoolColumn get needPickup => boolean()();
  IntColumn get returnActTypeId => integer().nullable()();
  IntColumn get receptId => integer().nullable()();
  TextColumn get receptNdoc => text().nullable()();
  DateTimeColumn get receptDate => dateTime().nullable()();
}

class ReturnActLines extends Table with Syncable {
  IntColumn get id => integer().nullable()();

  TextColumn get returnActGuid => text()
    .references(ReturnActs, #guid, onUpdate: KeyAction.cascade, onDelete: KeyAction.cascade)();
  IntColumn get goodsId => integer()();
  RealColumn get vol => real()();
  RealColumn get price => real()();
  DateTimeColumn get productionDate => dateTime().nullable()();
  BoolColumn get isBad => boolean().nullable()();
  IntColumn get rel => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [{returnActGuid, goodsId}];
}

class ReturnActTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class PartnersReturnActTypes extends Table {
  IntColumn get returnActTypeId => integer()();
  IntColumn get partnerId => integer()();

  @override
  Set<Column> get primaryKey => {returnActTypeId, partnerId};
}

class RoutePoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get buyerId => integer()();
  BoolColumn get visited => boolean().nullable()();
}

class VisitSkipReasons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class Visits extends Table with Syncable {
  IntColumn get id => integer().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get buyerId => integer()();
  IntColumn get routePointId => integer().nullable()();
  IntColumn get visitSkipReasonId => integer().nullable()();
  BoolColumn get needCheckGL => boolean()();
  BoolColumn get needTakePhotos => boolean()();
  BoolColumn get needFillSoftware => boolean()();
  BoolColumn get needDetails => boolean().generatedAs(needCheckGL | needTakePhotos | needFillSoftware)();

  BoolColumn get visited => boolean().generatedAs(visitSkipReasonId.isNull())();
}

class VisitImages extends Table with Photoable, Imageable, Syncable {
  IntColumn get id => integer()();
  TextColumn get visitGuid => text()
    .references(Visits, #guid, onUpdate: KeyAction.cascade, onDelete: KeyAction.cascade)();
}

class VisitSoftwares extends Table with Photoable, Imageable, Syncable {
  IntColumn get id => integer()();
  TextColumn get visitGuid => text()
    .references(Visits, #guid, onUpdate: KeyAction.cascade, onDelete: KeyAction.cascade)();
}

class VisitGoodsLists extends Table with Syncable {
  IntColumn get id => integer().nullable()();
  IntColumn get goodsListId => integer()();
  TextColumn get visitGuid => text()
    .references(Visits, #guid, onUpdate: KeyAction.cascade, onDelete: KeyAction.cascade)();
}

@DataClassName('VisitGoodsListGoods')
class AllVisitGoodsListGoods extends Table with Syncable {
  @override
  String get tableName => 'visit_goods_list_goods';

  IntColumn get id => integer().nullable()();
  IntColumn get goodsId => integer()();
  TextColumn get visitGoodsListGuid => text()
    .references(VisitGoodsLists, #guid, onUpdate: KeyAction.cascade, onDelete: KeyAction.cascade)();
}
