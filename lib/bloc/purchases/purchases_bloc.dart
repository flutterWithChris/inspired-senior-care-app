import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/repositories/purchases/purchases_repository.dart';
import 'package:meta/meta.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'purchases_event.dart';
part 'purchases_state.dart';

class PurchasesBloc extends Bloc<PurchasesEvent, PurchasesState> {
  final PurchasesRepository purchasesRepository;
  final ProfileBloc _profileBloc;
  PurchasesBloc(
      {required this.purchasesRepository, required ProfileBloc profileBloc})
      : _profileBloc = profileBloc,
        super(PurchasesLoading()) {
    on<PurchasesEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is LoadPurchases) {
        if (state is PurchasesLoading == false) {
          emit(PurchasesLoading());
        }
        try {
          // await purchasesRepository.initPlatformState();
          bool? isSubscribed =
              await purchasesRepository.getSubscriptionStatus();
          Offerings? offerings = await purchasesRepository.getOfferings();
          emit(PurchasesLoaded(
              offerings: offerings, isSubscribed: isSubscribed));
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
    });
  }
}
