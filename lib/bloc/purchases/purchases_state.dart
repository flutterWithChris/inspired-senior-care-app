part of 'purchases_bloc.dart';

@immutable
abstract class PurchasesState extends Equatable {
  Offerings? offerings;

  bool? isSubscribed;
  Package? selectedPackage;
  CustomerInfo? customerInfo;

  @override
  // TODO: implement props
  List<Object?> get props => [offerings, selectedPackage, customerInfo];
}

class PurchasesInitial extends PurchasesState {}

class PurchasesLoading extends PurchasesState {}

class PurchasesLoaded extends PurchasesState {
  @override
  final Offerings? offerings;
  @override
  final bool? isSubscribed;

  @override
  final CustomerInfo? customerInfo;
  final List<StoreProduct>? products;
  final int subscriptionType;
  final Group? subscribedGroup;
  PurchasesLoaded(
      {this.offerings,
      this.isSubscribed,
      this.customerInfo,
      this.products,
      this.subscribedGroup,
      required this.subscriptionType});
  @override
  // TODO: implement props
  List<Object?> get props =>
      [offerings, products, isSubscribed, customerInfo, subscriptionType];
}

class PurchasesFailed extends PurchasesState {}

class PurchasesUpdated extends PurchasesState {}
