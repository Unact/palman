part of 'goods_preload_image_page.dart';

enum GoodsPreloadImageStateStatus {
  initial,
  inProgress,
  dataLoaded,
  imageLoaded,
  success,
  failure,
  canceled
}

class GoodsPreloadImageState {
  GoodsPreloadImageState({
    this.status = GoodsPreloadImageStateStatus.initial,
    this.message = '',
    this.canceled = false,
    this.goodsWithImage = const [],
    this.loadedGoodsImages = 0
  });

  final GoodsPreloadImageStateStatus status;
  final String message;
  final bool canceled;

  final List<Goods> goodsWithImage;
  final int loadedGoodsImages;

  GoodsPreloadImageState copyWith({
    GoodsPreloadImageStateStatus? status,
    String? message,
    bool? canceled,
    List<Goods>? goodsWithImage,
    int? loadedGoodsImages,
  }) {
    return GoodsPreloadImageState(
      status: status ?? this.status,
      message: message ?? this.message,
      canceled: canceled ?? this.canceled,
      goodsWithImage: goodsWithImage ?? this.goodsWithImage,
      loadedGoodsImages: loadedGoodsImages ?? this.loadedGoodsImages
    );
  }
}
