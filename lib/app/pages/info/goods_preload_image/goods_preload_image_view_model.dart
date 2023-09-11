part of 'goods_preload_image_page.dart';

class GoodsPreloadImageViewModel extends PageViewModel<GoodsPreloadImageState, GoodsPreloadImageStateStatus> {
  final OrdersRepository ordersRepository;

  GoodsPreloadImageViewModel(this.ordersRepository) : super(GoodsPreloadImageState());

  @override
  GoodsPreloadImageStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final goods = await ordersRepository.getAllGoodsWithImage();

    emit(state.copyWith(
      status: GoodsPreloadImageStateStatus.dataLoaded,
      goodsWithImage: goods
    ));
  }

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();
    await preload();
  }

  void cancelPreload() {
    emit(state.copyWith(canceled: true));
  }

  Future<void> preload() async {
    emit(state.copyWith(status: GoodsPreloadImageStateStatus.inProgress));

    if (state.goodsWithImage.isEmpty) {
      emit(state.copyWith(
        status: GoodsPreloadImageStateStatus.failure,
        message: 'Нет товаров для загрузки фотографий'
      ));
      return;
    }

    String? lastErrorMsg;

    for (var goodsImage in state.goodsWithImage) {
      try {
        if (state.canceled) {
          emit(state.copyWith(status: GoodsPreloadImageStateStatus.failure, message: 'Загрузка отменена'));
          return;
        }

        await ordersRepository.preloadGoodsImages(goodsImage);
        emit(state.copyWith(
          status: GoodsPreloadImageStateStatus.imageLoaded,
          loadedGoodsImages: state.loadedGoodsImages + 1
        ));
      } on AppError catch(e) {
        lastErrorMsg = e.message;
      }
    }
    await ordersRepository.clearFiles();

    emit(state.copyWith(
      status: GoodsPreloadImageStateStatus.success,
      message: lastErrorMsg == null ?
        'Фотографии успешно загружены' :
        'Не удалось загрузить все фотографии. $lastErrorMsg'
    ));
  }
}
