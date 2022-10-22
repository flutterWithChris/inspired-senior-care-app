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
  final bool? isSubscribed;
  @override
  final CustomerInfo? customerInfo;
  final List<StoreProduct>? products;
  PurchasesLoaded(
      {this.offerings, this.isSubscribed, this.customerInfo, this.products});
  @override
  // TODO: implement props
  List<Object?> get props => [offerings, products, isSubscribed, customerInfo];
}

class PurchasesFailed extends PurchasesState {}

class PurchasesUpdated extends PurchasesState {}
