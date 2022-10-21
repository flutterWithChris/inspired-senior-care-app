import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesRepository {
  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration? configuration;

    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration("goog_vNVZjWFgEqVtULzDAKrmLaSryIc");
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration("appl_lhPFnQjvipbdcvvGNKqqNlfiFle");
    }

    await Purchases.configure(configuration!);
  }

  Future<Offerings?> getOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings;
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> makePurchase(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print(e);
      }
    }
  }

  Future<bool?> getSubscriptionStatus(CustomerInfo customerInfo) async {
    try {
      if (customerInfo.activeSubscriptions.isNotEmpty ||
          customerInfo.entitlements.active.isNotEmpty) {
        // Grant user "pro" access
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      // Error fetching purchaser info
      print(e);
    }
    return null;
  }

  Future<void> restorePurchases() async {
    try {
      CustomerInfo restoredInfo = await Purchases.restorePurchases();
      // ... check restored customerInfo to see if entitlement is now active
    } on PlatformException catch (e) {
      // Error restoring purchases
      print(e);
    }
  }

  Future<void> logoutOfRevCat() async {
    try {
      await Purchases.logOut();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> loginToRevCat(String userId) async {
    try {
      await Purchases.logIn(userId);
      // await Future.wait([
      // Purchases.setEmail(user.email!),
      // Purchases.setDisplayName(user.name!),
      // ]);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo;
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<StoreProduct>?> getProducts(
      List<String> productIdentifiers) async {
    try {
      List<StoreProduct> storeProducts =
          await Purchases.getProducts(productIdentifiers);
      return storeProducts;
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
  }
}

getUpdateListener() => Purchases.addCustomerInfoUpdateListener;
