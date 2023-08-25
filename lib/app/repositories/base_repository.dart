import 'package:flutter/material.dart';

import '/app/data/database.dart';
import '/app/services/api.dart';

class BaseRepository extends ChangeNotifier {
  final AppDataStore dataStore;
  final Api api;

  BaseRepository(this.dataStore, this.api);
}
