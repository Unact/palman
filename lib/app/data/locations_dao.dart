part of 'database.dart';

@DriftAccessor(tables: [Locations])
class LocationsDao extends DatabaseAccessor<AppDataStore> with _$LocationsDaoMixin {
  LocationsDao(super.db);

  Future<int> insertLocation(LocationsCompanion location) async {
    return await into(locations).insert(location);
  }

  Future<void> updateLocation(String guid, LocationsCompanion updatedLocation) async {
    await (update(locations)..where((tbl) => tbl.guid.equals(guid))).write(updatedLocation);
  }

  Future<void> deleteLocations() async {
    await delete(locations).go();
  }

  Future<List<Location>> getLocationsForSync() async {
    return (select(locations)..where((tbl) => tbl.needSync)).get();
  }

  Stream<List<Location>> watchLocations() {
    return select(locations).watch();
  }
}
