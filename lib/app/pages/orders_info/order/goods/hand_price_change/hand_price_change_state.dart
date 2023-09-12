part of 'hand_price_change_page.dart';

enum HandPriceChangeStateStatus {
  initial,
  handPriceUpdated
}

class HandPriceChangeState {
  HandPriceChangeState({
    this.status = HandPriceChangeStateStatus.initial,
    required this.minHandPrice,
    required this.handPrice
  });

  final HandPriceChangeStateStatus status;

  final double minHandPrice;
  final double? handPrice;

  double get priceStep => 0.01;

  HandPriceChangeState copyWith({
    HandPriceChangeStateStatus? status,
    double? minHandPrice,
    Optional<double>? handPrice,
  }) {
    return HandPriceChangeState(
      status: status ?? this.status,
      minHandPrice: minHandPrice ?? this.minHandPrice,
      handPrice: handPrice != null ? handPrice.orNull : this.handPrice
    );
  }
}
