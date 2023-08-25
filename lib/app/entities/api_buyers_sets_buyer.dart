part of 'entities.dart';

class ApiBuyersSetsBuyer extends Equatable {
  final int buyersSetId;
  final int buyerId;

  const ApiBuyersSetsBuyer({
    required this.buyersSetId,
    required this.buyerId
  });

  factory ApiBuyersSetsBuyer.fromJson(dynamic json) {
    return ApiBuyersSetsBuyer(
      buyersSetId: json['buyersSetId'],
      buyerId: json['buyerId']
    );
  }

  BuyersSetsBuyer toDatabaseEnt() {
    return BuyersSetsBuyer(
      buyersSetId: buyersSetId,
      buyerId: buyerId
    );
  }

  @override
  List<Object> get props => [
    buyersSetId,
    buyerId
  ];
}
