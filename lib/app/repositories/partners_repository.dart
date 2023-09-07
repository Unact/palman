import 'package:u_app_utils/u_app_utils.dart';

import '/app/data/database.dart';
import '/app/repositories/base_repository.dart';

class PartnersRepository extends BaseRepository {
  PartnersRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

  Future<List<Buyer>> getBuyers() async {
    return dataStore.partnersDao.getBuyers();
  }

  Future<List<Partner>> getPartners() async {
    return dataStore.partnersDao.getPartners();
  }
}
