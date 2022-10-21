part of 'purchases_bloc.dart';

@immutable
abstract class PurchasesEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadPurchases extends PurchasesEvent {}

class RestorePurchases extends PurchasesEvent {}

class AddPurchase extends PurchasesEvent {
  final Package package;
  AddPurchase({
    required this.package,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [package];
}

class EditPurchase extends PurchasesEvent {}

class RemovePurchase extends PurchasesEvent {}

class SelectPackage extends PurchasesEvent {
  final Package package;
  SelectPackage({
    required this.package,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [package];
}
