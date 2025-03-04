import 'package:drift/drift.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/palman_api.dart';

class LocationsRepository extends BaseRepository {
  static const int kMinLocationPoint = 10;

  LocationsRepository(super.dataStore, super.api);

  Stream<List<Location>> watchLocations() {
    return dataStore.locationsDao.watchLocations();
  }

  Future<void> deleteLocations() async {
    await dataStore.locationsDao.deleteLocations();
  }

  Future<void> saveLocation({
    required double latitude,
    required double longitude,
    required double accuracy,
    required double altitude,
    required double heading,
    required double speed,
    required DateTime deviceTimestamp,
    required int batteryLevel,
    required String batteryState
  }) async {
    await dataStore.locationsDao.insertLocation(
      LocationsCompanion(
        guid: Value(dataStore.generateGuid()),
        latitude: Value(latitude),
        longitude: Value(longitude),
        accuracy: Value(accuracy),
        altitude: Value(altitude),
        heading: Value(heading),
        speed: Value(speed),
        deviceTimestamp: Value(deviceTimestamp),
        batteryLevel: Value(batteryLevel),
        batteryState: Value(batteryState)
      )
    );
  }

  Future<void> syncLocationChanges(List<Location> locations) async {
    try {
      DateTime lastSyncTime = DateTime.now();
      List<Map<String, dynamic>> locationsData = locations.map((e) => {
        'latitude': e.latitude,
        'longitude': e.longitude,
        'accuracy': e.accuracy,
        'altitude': e.altitude,
        'heading': e.heading,
        'speed': e.speed,
        'timestamp': e.deviceTimestamp.toIso8601String(),
        'batteryLevel': e.batteryLevel,
        'batteryState': e.batteryState,
      }).toList();
      await api.locations(locationsData);

      await dataStore.transaction(() async {
        for (var location in locations) {
          await dataStore.locationsDao.updateLocation(
            location.guid,
            LocationsCompanion(lastSyncTime: Value(lastSyncTime))
          );
        }
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncChanges() async {
    final locations = await dataStore.locationsDao.getLocationsForSync();

    if (locations.length < kMinLocationPoint) return;

    await syncLocationChanges(locations);
  }
}
