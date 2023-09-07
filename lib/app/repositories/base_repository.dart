import 'package:flutter/material.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/data/database.dart';

class BaseRepository extends ChangeNotifier {
  final AppDataStore dataStore;
  final RenewApi api;

  BaseRepository(this.dataStore, this.api);
}
