part of 'pre_order_page.dart';

class PreOrderViewModel extends PageViewModel<PreOrderState, PreOrderStateStatus> {
  final OrdersRepository ordersRepository;
  StreamSubscription<List<PreOrderLineExResult>>? preOrderLineExListSubscription;

  PreOrderViewModel(this.ordersRepository, {required PreOrderExResult preOrderEx}) :
    super(PreOrderState(preOrderEx: preOrderEx));

  @override
  PreOrderStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await _saveSeen();

    await super.initViewModel();
    preOrderLineExListSubscription = ordersRepository.watchPreOrderLineExList(state.preOrderEx.preOrder.id).listen(
      (event) {
      emit(state.copyWith(status: PreOrderStateStatus.dataLoaded, linesExList: event));
      }
    );
  }

  @override
  Future<void> close() async {
    await super.close();

    await preOrderLineExListSubscription?.cancel();
  }

  Future<void> _saveSeen() async {
    if (state.preOrderEx.wasSeen) return;

    await ordersRepository.addSeenPreOrder(id: state.preOrderEx.preOrder.id);
  }

  Future<void> createOrder() async {
    final orderEx = await ordersRepository.createOrderFromPreOrder(
      state.preOrderEx.preOrder,
      state.linesExList.map((e) => e.line).toList()
    );

    emit(state.copyWith(
      status: PreOrderStateStatus.orderCreated,
      newOrder: orderEx
    ));
  }
}
