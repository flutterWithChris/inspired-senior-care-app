part of 'purchases_bloc.dart';

@immutable
abstract class PurchasesState extends Equatable {
  Offerings? offerings;
  @override
  // TODO: implement props
  List<Object?> get props => [offerings];
}

class PurchasesInitial extends PurchasesState {}

class PurchasesLoading extends PurchasesState {}

class PurchasesLoaded extends PurchasesState {
  @override
  final Offerings? offerings;
  final bool? isSubscribed;
  PurchasesLoaded({
    this.offerings,
    this.isSubscribed,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [offerings];
}

class PurchasesFailed extends PurchasesState {}

class PurchasesUpdated extends PurchasesState {}
