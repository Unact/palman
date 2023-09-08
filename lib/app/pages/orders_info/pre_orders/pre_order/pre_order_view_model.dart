part of 'pre_order_page.dart';

class PreOrderViewModel extends PageViewModel<PreOrderState, PreOrderStateStatus> {
  final OrdersRepository ordersRepository;
  final PricesRepository pricesRepository;

  PreOrderViewModel(this.ordersRepository, this.pricesRepository, {required PreOrderExResult preOrderEx}) :
    super(PreOrderState(preOrderEx: preOrderEx), [ordersRepository, pricesRepository]);

  @override
  PreOrderStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final linesExList = await ordersRepository.getPreOrderLineExList(state.preOrderEx.preOrder.id);

    emit(state.copyWith(
      status: PreOrderStateStatus.dataLoaded,
      linesExList: linesExList
    ));
  }

  Future<void> createOrder() async {
    final orderEx = await ordersRepository.addOrder(
      status: OrderStatus.upload.value,
      needProcessing: true,
      preOrderId: state.preOrderEx.preOrder.id,
      buyerId: state.preOrderEx.preOrder.buyerId,
      date: state.preOrderEx.preOrder.date,
      needDocs: state.preOrderEx.preOrder.needDocs
    );
    final goodsDetails = await ordersRepository.getGoodsDetails(
      buyerId: state.preOrderEx.preOrder.buyerId,
      date: state.preOrderEx.preOrder.date,
      goodsIds: state.linesExList.map((e) => e.line.goodsId).toList()
    );

    for (var preOrderLine in state.linesExList) {
      final goodsDetail = goodsDetails.firstWhereOrNull((e) => e.goods == preOrderLine.goods);

      if (goodsDetail == null) continue;

      await ordersRepository.addOrderLine(
        orderEx.order,
        goodsId: preOrderLine.goods.id,
        vol: preOrderLine.line.vol * preOrderLine.line.rel / goodsDetail.rel,
        price: goodsDetail.price,
        priceOriginal: goodsDetail.pricelistPrice,
        package: goodsDetail.package,
        rel: goodsDetail.rel
      );
    }

    emit(state.copyWith(
      status: PreOrderStateStatus.orderCreated,
      newOrder: orderEx
    ));
  }
}
