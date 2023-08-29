import 'package:drift/drift.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/api.dart';
import '/app/utils/misc.dart';

class LocationsRepository extends BaseRepository {
  static const int kMinLocationPoint = 10;

  LocationsRepository(AppDataStore dataStore, Api api) : super(dataStore, api);

  Future<void> saveLocation({
    required double latitude,
    required double longitude,
    required double accuracy,
    required double altitude,
    required double heading,
    required double speed,
    required DateTime timestamp
  }) async {
    await dataStore.insertLocation(
      LocationsCompanion(
        latitude: Value(latitude),
        longitude: Value(longitude),
        accuracy: Value(accuracy),
        altitude: Value(altitude),
        heading: Value(heading),
        speed: Value(speed),
        timestamp: Value(timestamp)
      )
    );

    notifyListeners();
  }

  Future<void> syncLocationChanges(List<Location> locations) async {
    if (locations.length < kMinLocationPoint) return;

    try {
      List<Map<String, dynamic>> locationsData = locations.map((e) => {
        'latitude': e.latitude,
        'longitude': e.longitude,
        'accuracy': e.accuracy,
        'altitude': e.altitude,
        'heading': e.heading,
        'speed': e.speed,
        'timestamp': e.timestamp.toIso8601String()
      }).toList();
      await api.locations(locationsData);

      for (var e in locations) {
        await dataStore.deleteLocation(e.id);
      }
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncChanges() async {
    final locations = await dataStore.getLocations();

    await syncLocationChanges(locations);
  }
}
