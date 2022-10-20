import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/repositories/purchases/purchases_repository.dart';
import 'package:meta/meta.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'purchases_event.dart';
part 'purchases_state.dart';

class PurchasesBloc extends Bloc<PurchasesEvent, PurchasesState> {
  Package? selectedPackage;
  final PurchasesRepository purchasesRepository;
  final ProfileBloc _profileBloc;
  StreamSubscription? profileStateStream;
  PurchasesBloc(
      {required this.purchasesRepository,
      required ProfileBloc profileBloc,
      this.selectedPackage})
      : _profileBloc = profileBloc,
        super(PurchasesLoading()) {
    profileStateStream = _profileBloc.stream.listen((state) async {
      if (state is ProfileLoaded) {
        await purchasesRepository.loginToRevCat(_profileBloc.state.user);
      }
    });
    on<PurchasesEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is LoadPurchases) {
        if (state is PurchasesLoading == false) {
          emit(PurchasesLoading());
        }
        try {
          bool? isSubscribed =
              await purchasesRepository.getSubscriptionStatus();
          Offerings? offerings = await purchasesRepository.getOfferings();
          CustomerInfo? customerInfo =
              await purchasesRepository.getCustomerInfo();
          emit(PurchasesLoaded(
              offerings: offerings,
              isSubscribed: isSubscribed,
              customerInfo: customerInfo));
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
    profileStateStream?.cancel();
    return super.close();
  }
}
