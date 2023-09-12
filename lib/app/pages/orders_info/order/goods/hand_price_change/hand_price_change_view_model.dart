part of 'hand_price_change_page.dart';

class HandPriceChangeViewModel extends PageViewModel<HandPriceChangeState, HandPriceChangeStateStatus> {
  HandPriceChangeViewModel({required double minHandPrice, required double handPrice}) :
    super(HandPriceChangeState(minHandPrice: minHandPrice, handPrice: handPrice), []);

  @override
  HandPriceChangeStateStatus get status => state.status;

  @override
  Future<void> loadData() async {}

  void updateHandPrice(double? handPrice) async {
    emit(state.copyWith(
      status: HandPriceChangeStateStatus.handPriceUpdated,
      handPrice: Optional.fromNullable(handPrice?.roundDigits(2))
    ));
  }
}
