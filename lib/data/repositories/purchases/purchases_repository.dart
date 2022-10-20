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
      var isPro =
          customerInfo.entitlements.all["my_entitlement_identifier"]!.isActive;
      if (isPro) {
        // Unlock that great "pro" content
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print(e);
      }
    }
  }

  Future<bool?> getSubscriptionStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.activeSubscriptions.isNotEmpty) {
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
}

getUpdateListener() => Purchases.addCustomerInfoUpdateListener;