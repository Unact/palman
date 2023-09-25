part of 'pre_order_page.dart';

class PreOrderViewModel extends PageViewModel<PreOrderState, PreOrderStateStatus> {
  final OrdersRepository ordersRepository;
  final PricesRepository pricesRepository;

  PreOrderViewModel(this.ordersRepository, this.pricesRepository, {required PreOrderExResult preOrderEx}) :
    super(PreOrderState(preOrderEx: preOrderEx), [ordersRepository, pricesRepository]);

  @override
  PreOrderStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await _saveSeen();

    await super.initViewModel();
  }

  @override
  Future<void> loadData() async {
    final linesExList = await ordersRepository.getPreOrderLineExList(state.preOrderEx.preOrder.id);

    emit(state.copyWith(
      status: PreOrderStateStatus.dataLoaded,
      linesExList: linesExList
    ));
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
