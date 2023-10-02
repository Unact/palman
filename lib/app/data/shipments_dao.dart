part of 'database.dart';

@DriftAccessor(
  tables: [
    Buyers,
    Shipments,
    ShipmentLines,
    IncRequests,
    AllGoods,
    Workdates,
  ],
  queries: {
    'shipmentEx': '''
      SELECT
        shipments.** AS "shipment",
        buyers.** AS "buyer",
        (SELECT COUNT(*) FROM shipment_lines where shipments.id = shipment_lines.shipment_id) AS "lines_count"
      FROM shipments
      JOIN buyers on buyers.id = shipments.buyer_id
      ORDER BY shipments.date DESC, buyers.name
    ''',
    'goodsShipments': '''
      SELECT
        shipments.date,
        shipment_lines.vol,
        shipment_lines.price
      FROM shipments
      JOIN shipment_lines ON shipment_lines.shipment_id = shipments.id
      WHERE shipments.buyer_id = :buyer_id AND shipment_lines.goods_id = :goods_id
      ORDER BY shipments.date DESC
    '''
  }
)
class ShipmentsDao extends DatabaseAccessor<AppDataStore> with _$ShipmentsDaoMixin {
  ShipmentsDao(AppDataStore db) : super(db);

  Future<void> regenerateIncRequestsGuid() async {
    await db._regenerateGuid(incRequests);
  }

  Future<void> loadShipments(List<Shipment> list) async {
    await db._loadData(shipments, list);
  }

  Future<void> loadShipmentLines(List<ShipmentLine> list) async {
    await db._loadData(shipmentLines, list);
  }

  Future<void> loadIncRequests(List<IncRequest> list, [bool clearTable = true]) async {
    await db._loadData(incRequests, list, clearTable);
  }

  Future<void> updateIncRequest(String guid, IncRequestsCompanion updatedIncRequest) async {
    await (update(incRequests)..where((tbl) => tbl.guid.equals(guid))).write(updatedIncRequest);
  }

  Future<void> addIncRequest(IncRequestsCompanion newIncRequest) async {
    await into(incRequests).insert(newIncRequest);
  }

  Future<List<IncRequest>> getIncRequestsForSync() async {
    return (select(incRequests)..where((tbl) => tbl.needSync.equals(true))).get();
  }

  Stream<List<IncRequestEx>> watchIncRequestExList() {
    final res = select(incRequests)
      .join([
        leftOuterJoin(buyers, buyers.id.equalsExp(incRequests.buyerId)),
      ])
      ..orderBy([
        OrderingTerm(expression: incRequests.date, mode: OrderingMode.desc),
        OrderingTerm(expression: buyers.name)
      ]);

    return res.map(
      (row) => IncRequestEx(
        row.readTable(incRequests),
        row.readTableOrNull(buyers)
      )
    ).watch();
  }

  Future<IncRequestEx> getIncRequestEx(String guid) async {
    final res = select(incRequests)
      .join([
        leftOuterJoin(buyers, buyers.id.equalsExp(incRequests.buyerId)),
      ])
      ..where(incRequests.guid.equals(guid));

    return res.map(
      (row) => IncRequestEx(
        row.readTable(incRequests),
        row.readTableOrNull(buyers)
      )
    ).getSingle();
  }

  Stream<List<ShipmentExResult>> watchShipmentExList() {
    return shipmentEx().watch();
  }

  Stream<List<GoodsShipmentsResult>> watchGoodsShipments({required int buyerId, required int goodsId}) {
    return goodsShipments(buyerId, goodsId).watch();
  }

  Stream<List<ShipmentLineEx>> watchShipmentLineExList(int shipmentId) {
    final shipmentLinesQuery = select(shipmentLines)
      .join([
        innerJoin(allGoods, allGoods.id.equalsExp(shipmentLines.goodsId)),
      ])
      ..where(shipmentLines.shipmentId.equals(shipmentId))
      ..orderBy([OrderingTerm(expression: allGoods.name)]);

    return shipmentLinesQuery.map(
      (lineRow) => ShipmentLineEx(lineRow.readTable(shipmentLines), lineRow.readTable(allGoods))
    ).watch();
  }
}

class ShipmentLineEx {
  final ShipmentLine line;
  final Goods goods;

  double get total => line.vol * line.price;

  ShipmentLineEx(this.line, this.goods);
}

class IncRequestEx {
  final IncRequest incRequest;
  final Buyer? buyer;

  IncRequestEx(this.incRequest, this.buyer);
}
