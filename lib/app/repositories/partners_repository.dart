import '/app/data/database.dart';
import '/app/repositories/base_repository.dart';

class PartnersRepository extends BaseRepository {
  PartnersRepository(super.dataStore, super.api);

  Stream<List<BuyerEx>> watchBuyers() {
    return dataStore.partnersDao.watchBuyers();
  }
}
