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

  Future<void> blockIncRequests(bool block, {List<int>? ids}) async {
    final companion = IncRequestsCompanion(isBlocked: Value(block));

    await (update(incRequests)..where((tbl) => ids != null ? tbl.id.isIn(ids) : const Constant(true))).write(companion);
  }

  Future<void> loadShipments(List<Shipment> list) async {
    await db._loadData(shipments, list);
  }

  Future<void> loadShipmentLines(List<ShipmentLine> list) async {
    await db._loadData(shipmentLines, list);
  }

  Future<void> loadIncRequests(List<IncRequest> list) async {
    await db._loadData(incRequests, list);
  }

  Future<void> updateIncRequest(int id, IncRequestsCompanion updatedIncRequest) async {
    await (update(incRequests)..where((tbl) => tbl.id.equals(id))).write(updatedIncRequest);
  }

  Future<int> addIncRequest(IncRequestsCompanion newIncRequest) async {
    return await into(incRequests).insert(newIncRequest);
  }

  Future<void> deleteIncRequest(int incRequestId) async {
    await (delete(incRequests)..where((tbl) => tbl.id.equals(incRequestId))).go();
  }

  Future<List<IncRequest>> getIncRequestsForSync() async {
    return (
      select(incRequests)
        ..where((tbl) => tbl.needSync.equals(true))
        ..where((tbl) => tbl.isBlocked.equals(false))
    ).get();
  }

  Future<List<IncRequestEx>> getIncRequestExList() async {
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
    ).get();
  }

  Future<IncRequestEx> getIncRequestEx(int id) async {
    final res = select(incRequests)
      .join([
        leftOuterJoin(buyers, buyers.id.equalsExp(incRequests.buyerId)),
      ])
      ..where(incRequests.id.equals(id));

    return res.map(
      (row) => IncRequestEx(
        row.readTable(incRequests),
        row.readTableOrNull(buyers)
      )
    ).getSingle();
  }

  Future<List<ShipmentExResult>> getShipmentExList() async {
    return shipmentEx().get();
  }

  Future<List<GoodsShipmentsResult>> getGoodsShipments({required int buyerId, required int goodsId}) async {
    return goodsShipments(buyerId, goodsId).get();
  }

  Future<List<ShipmentLineEx>> getShipmentLineExList(int shipmentId) async {
    final shipmentLinesQuery = select(shipmentLines)
      .join([
        innerJoin(allGoods, allGoods.id.equalsExp(shipmentLines.goodsId)),
      ])
      ..where(shipmentLines.shipmentId.equals(shipmentId))
      ..orderBy([OrderingTerm(expression: allGoods.name)]);

    return shipmentLinesQuery.map(
      (lineRow) => ShipmentLineEx(lineRow.readTable(shipmentLines), lineRow.readTable(allGoods))
    ).get();
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
