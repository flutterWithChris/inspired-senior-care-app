import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/purchases/purchases_repository.dart';
import 'package:meta/meta.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'purchases_event.dart';
part 'purchases_state.dart';

class PurchasesBloc extends Bloc<PurchasesEvent, PurchasesState> {
  Package? selectedPackage;
  final PurchasesRepository _purchasesRepository;
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  final ProfileBloc _profileBloc;
  StreamSubscription? authStateStream;
  PurchasesBloc(
      {required PurchasesRepository purchasesRepository,
      required AuthBloc authBloc,
      required DatabaseRepository databaseRepository,
      required ProfileBloc profileBloc,
      this.selectedPackage})
      : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        _purchasesRepository = purchasesRepository,
        _profileBloc = profileBloc,
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
          // Check Revenue Cat for Subscription Status
          CustomerInfo? customerInfo =
              await purchasesRepository.getCustomerInfo();
          User currentUser = _profileBloc.state.user;
          print('Checking groups for: ${_profileBloc.state.user.name}');

          bool? isSubscribed =
              await purchasesRepository.getSubscriptionStatus(customerInfo!);
          Offerings? offerings = await purchasesRepository.getOfferings();
          List<StoreProduct>? products;

          // Subscription type 0 = self, 1 = group-inherited.
          int subscriptionType = 0;
          Group? subscribedGroup;

          // Set groups to unsubscribed if no subscription active for owned groupa
          if (isSubscribed != true && currentUser.type == 'manager') {
            _databaseRepository.resetGroupSubscriptionStatus(currentUser.id!);
          }

          // Check if groups are subscribed for organization access
          if (isSubscribed != true) {
            Map<Group?, bool?>? groupMap = await _databaseRepository
                .getGroupSubscriptionStatus(_authBloc.state.user!.uid);
            if (groupMap != null && groupMap.containsValue(true)) {
              subscriptionType = 1;
              isSubscribed = true;
              subscribedGroup = groupMap.keys.first;
            }
          }

          products = await purchasesRepository
              .getProducts(customerInfo.allPurchasedProductIdentifiers);

          emit(PurchasesLoaded(
              offerings: offerings,
              isSubscribed: isSubscribed,
              customerInfo: customerInfo,
              subscribedGroup: subscribedGroup ?? subscribedGroup,
              subscriptionType: subscriptionType,
              products: products));
        } catch (e) {
          print(e);
        }
      }
      if (event is AddPurchase) {
        emit(PurchasesLoading());
        await purchasesRepository.makePurchase(event.package);
        emit(PurchasesUpdated());
        User currentUser = _profileBloc.state.user;
        if (currentUser.type == 'manager') {
          _databaseRepository.setGroupSubscriptionStatus(currentUser.groups!);
        }
        add(LoadPurchases());
      }
      if (event is EditPurchase) {}
      if (event is RemovePurchase) {}
      if (event is RestorePurchases) {
        emit(PurchasesLoading());
        CustomerInfo? customerInfo =
            await purchasesRepository.restorePurchases();
        emit(PurchasesUpdated());
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
