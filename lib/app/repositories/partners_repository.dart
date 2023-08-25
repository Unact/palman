import '/app/data/database.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/api.dart';

class PartnersRepository extends BaseRepository {
  PartnersRepository(AppDataStore dataStore, Api api) : super(dataStore, api);

  Future<List<Buyer>> getBuyers() async {
    return dataStore.partnersDao.getBuyers();
  }

  Future<List<Partner>> getPartners() async {
    return dataStore.partnersDao.getPartners();
  }
}
