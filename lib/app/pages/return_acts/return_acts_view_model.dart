part of 'return_acts_page.dart';

class ReturnActsViewModel extends PageViewModel<ReturnActsState, ReturnActsStateStatus> {
  final AppRepository appRepository;
  final PartnersRepository partnersRepository;
  final ReturnActsRepository returnActsRepository;
  final UsersRepository usersRepository;
  StreamSubscription<List<ReturnActExResult>>? returnActExListSubscription;
  StreamSubscription<List<BuyerEx>>? buyersSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  ReturnActsViewModel(
    this.appRepository,
    this.partnersRepository,
    this.returnActsRepository,
    this.usersRepository
  ) : super(ReturnActsState());

  @override
  ReturnActsStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    returnActExListSubscription = returnActsRepository.watchReturnActExList().listen((event) {
      emit(state.copyWith(status: ReturnActsStateStatus.dataLoaded, returnActExList: event));
    });
    buyersSubscription = partnersRepository.watchBuyers().listen((event) {
      emit(state.copyWith(status: ReturnActsStateStatus.dataLoaded, buyerExList: event));
    });
    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: ReturnActsStateStatus.dataLoaded, appInfo: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await returnActExListSubscription?.cancel();
    await buyersSubscription?.cancel();
    await appInfoSubscription?.cancel();
  }


  void selectBuyer(Buyer? buyer) {
    emit(state.copyWith(
      status: ReturnActsStateStatus.buyerChanged,
      selectedBuyer: Optional.fromNullable(buyer)
    ));
  }

  Future<void> syncChanges() async {
    final futures = [
      returnActsRepository.syncChanges
    ];

    await Future.wait(futures.map((e) => e.call()));
  }

  Future<void> getData() async {
    if (state.isLoading) return;

    final futures = [
      returnActsRepository.loadReturnActs
    ];

    try {
      emit(state.copyWith(isLoading: true));
      await Future.wait(futures.map((e) => e.call()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> addNewReturnAct() async {
    ReturnActExResult newReturnAct = await returnActsRepository.addReturnAct();

    emit(state.copyWith(
      status: ReturnActsStateStatus.returnActAdded,
      newReturnAct: newReturnAct
    ));
  }

  Future<void> deleteReturnAct(ReturnActExResult returnActEx) async {
    await returnActsRepository.deleteReturnAct(returnActEx.returnAct);
    emit(state.copyWith(
      status: ReturnActsStateStatus.returnActDeleted,
      returnActExList: state.returnActExList.where((e) => e != returnActEx).toList()
    ));
  }
}
