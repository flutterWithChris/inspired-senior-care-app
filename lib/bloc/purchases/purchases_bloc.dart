import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/data/repositories/purchases/purchases_repository.dart';
import 'package:meta/meta.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'purchases_event.dart';
part 'purchases_state.dart';

class PurchasesBloc extends Bloc<PurchasesEvent, PurchasesState> {
  Package? selectedPackage;
  final PurchasesRepository purchasesRepository;
  final AuthBloc _authBloc;
  StreamSubscription? authStateStream;
  PurchasesBloc(
      {required this.purchasesRepository,
      required AuthBloc authBloc,
      this.selectedPackage})
      : _authBloc = authBloc,
        super(PurchasesLoading()) {
    authStateStream = _authBloc.stream.listen((state) async {
      if (state.authStatus == AuthStatus.authenticated) {
        add(LoadPurchases());
      }
    });
    on<PurchasesEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is LoadPurchases) {
        if (state is PurchasesLoading == false) {
          emit(PurchasesLoading());
        }

        try {
          CustomerInfo? customerInfo =
              await purchasesRepository.getCustomerInfo();
          bool? isSubscribed =
              await purchasesRepository.getSubscriptionStatus(customerInfo!);
          Offerings? offerings = await purchasesRepository.getOfferings();

          Map<String, EntitlementInfo> entitlements =
              customerInfo.entitlements.active;
          List<StoreProduct>? products;

          products = await purchasesRepository
              .getProducts(customerInfo.allPurchasedProductIdentifiers);

          emit(PurchasesLoaded(
              offerings: offerings,
              isSubscribed: isSubscribed,
              customerInfo: customerInfo,
              products: products));
        } catch (e) {
          print(e);
        }
      }
      if (event is AddPurchase) {
        emit(PurchasesLoading());
        await purchasesRepository.makePurchase(event.package);
        emit(PurchasesUpdated());
        add(LoadPurchases());
      }
      if (event is EditPurchase) {}
      if (event is RemovePurchase) {}
      if (event is RestorePurchases) {
        emit(PurchasesLoading());
        await purchasesRepository.restorePurchases();
        emit(PurchasesUpdated());
        add(LoadPurchases());
      }
      if (event is RefreshPurchases) {
        add(LoadPurchases());
      }
      if (event is SelectPackage) {
        selectedPackage = event.package;
        print('Selected Package: $event.package');
      }
    });
  }
  @override
  Future<void> close() {
    // TODO: implement close
    authStateStream?.cancel();
    return super.close();
  }
}
