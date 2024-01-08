part of 'return_act_page.dart';

class ReturnActViewModel extends PageViewModel<ReturnActState, ReturnActStateStatus> {
  final AppRepository appRepository;
  final PartnersRepository partnersRepository;
  final ReturnActsRepository returnActsRepository;
  final UsersRepository usersRepository;

  StreamSubscription<User>? userSubscription;
  StreamSubscription<List<ReturnActExResult>>? returnActExListSubscription;
  StreamSubscription<List<ReturnActLineExResult>>? returnActLineExListSubscription;
  StreamSubscription<List<BuyerEx>>? buyersSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  ReturnActViewModel(
    this.appRepository,
    this.partnersRepository,
    this.returnActsRepository,
    this.usersRepository,
    {
      required ReturnActExResult returnActEx
    }
  ) : super(ReturnActState(returnActEx: returnActEx));

  @override
  ReturnActStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();
    if (state.returnActEx.returnAct.buyerId != null) {
      List<ReceptExResult> receptExList = state.returnActEx.returnAct.returnActTypeId == null ?
        [] :
        await returnActsRepository.getReceptExList(
          buyerId: state.returnActEx.returnAct.buyerId!,
          returnActTypeId: state.returnActEx.returnAct.returnActTypeId!
        );
      final returnActTypes = await returnActsRepository.getReturnActTypes(
        buyerId: state.returnActEx.returnAct.buyerId!
      );

      emit(state.copyWith(
        status: ReturnActStateStatus.dataLoaded,
        receptExList: receptExList,
        returnActTypes: returnActTypes
      ));
    }

    userSubscription = usersRepository.watchUser().listen((event) {
      emit(state.copyWith(status: ReturnActStateStatus.dataLoaded, user: event));
    });
    returnActExListSubscription = returnActsRepository.watchReturnActExList().listen((event) {
      final returnActEx = event.firstWhereOrNull((e) => e.returnAct.guid == state.returnActEx.returnAct.guid);

      if (returnActEx == null) {
        emit(state.copyWith(status: ReturnActStateStatus.returnActRemoved));
        return;
      }

      emit(state.copyWith(status: ReturnActStateStatus.dataLoaded, returnActEx: returnActEx));
    });
    returnActLineExListSubscription = returnActsRepository
      .watchReturnActLineExList(state.returnActEx.returnAct.guid).listen((event) {
        emit(state.copyWith(
          status: ReturnActStateStatus.dataLoaded,
          linesExList: event
        ));
      });
    buyersSubscription = partnersRepository.watchBuyers().listen((event) {
      emit(state.copyWith(status: ReturnActStateStatus.dataLoaded, buyerExList: event));
    });
    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: ReturnActStateStatus.dataLoaded, appInfo: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await userSubscription?.cancel();
    await returnActExListSubscription?.cancel();
    await returnActLineExListSubscription?.cancel();
    await buyersSubscription?.cancel();
    await appInfoSubscription?.cancel();
  }

  Future<void> updateBuyer(Buyer? buyer) async {
    await returnActsRepository.updateReturnAct(
      state.returnActEx.returnAct,
      buyerId: Optional.fromNullable(buyer?.id),
      returnActTypeId: const Optional.absent(),
      receptId: const Optional.absent(),
      receptNdoc: const Optional.absent(),
      receptDate: const Optional.absent()
    );
    await returnActsRepository.clearReturnActLines(state.returnActEx.returnAct);

    _notifyReturnActUpdated();

    List<ReturnActType> returnActTypes = buyer == null ?
      [] :
      await returnActsRepository.getReturnActTypes(buyerId: buyer.id);

    emit(state.copyWith(status: ReturnActStateStatus.dataLoaded, returnActTypes: returnActTypes));
  }

  Future<void> updateNeedPickup(bool needPickup) async {
    await returnActsRepository.updateReturnAct(
      state.returnActEx.returnAct,
      needPickup: Optional.of(needPickup)
    );
    _notifyReturnActUpdated();
  }

  Future<void> updateReturnActTypeId(int returnActTypeId) async {
    if (state.returnActEx.returnAct.buyerId == null) {
      emit(state.copyWith(status: ReturnActStateStatus.failure, message: 'Не указан покупатель'));
      return;
    }

    await returnActsRepository.updateReturnAct(
      state.returnActEx.returnAct,
      returnActTypeId: Optional.of(returnActTypeId),
      receptId: const Optional.absent(),
      receptNdoc: const Optional.absent(),
      receptDate: const Optional.absent()
    );
    await returnActsRepository.clearReturnActLines(state.returnActEx.returnAct);
    _notifyReturnActUpdated();

    try {
      emit(state.copyWith(status: ReturnActStateStatus.inProgress));

      await returnActsRepository.loadReturnRemains(
        buyerId: state.returnActEx.returnAct.buyerId!,
        returnActTypeId: returnActTypeId
      );

      emit(state.copyWith(
        status: ReturnActStateStatus.success,
        receptExList: await returnActsRepository.getReceptExList(
          buyerId: state.returnActEx.returnAct.buyerId!,
          returnActTypeId: returnActTypeId
        )
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: ReturnActStateStatus.failure, message: e.message));
    }
  }

  Future<void> updateReceptId(int receptId) async {
    if (state.returnActEx.returnAct.returnActTypeId == null) {
      emit(state.copyWith(status: ReturnActStateStatus.failure, message: 'Не указан тип'));
      return;
    }

    final recept = state.receptExList.firstWhere((e) => e.id == receptId);
    await returnActsRepository.updateReturnAct(
      state.returnActEx.returnAct,
      receptId: Optional.of(recept.id),
      receptDate: Optional.of(recept.date),
      receptNdoc: Optional.of(recept.ndoc)
    );
    await returnActsRepository.clearReturnActLines(state.returnActEx.returnAct);
    _notifyReturnActUpdated();
  }

  Future<void> deleteReturnActLine(ReturnActLineExResult returnactLineEx) async {
    await returnActsRepository.deleteReturnActLine(returnactLineEx.line);
    emit(state.copyWith(
      status: ReturnActStateStatus.returnActLineDeleted,
      linesExList: state.linesExList.where((e) => e != returnactLineEx).toList()
    ));
  }

  Future<void> syncChanges() async {
    await returnActsRepository.syncReturnActs(
      [state.returnActEx.returnAct],
      state.linesExList.map((e) => e.line).toList()
    );
  }

  void _notifyReturnActUpdated() {
    emit(state.copyWith(status: ReturnActStateStatus.returnActUpdated));
  }
}
