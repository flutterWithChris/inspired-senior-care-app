import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspired_senior_care_app/globals.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesRepository {
  final beforeCapitalLetter = RegExp(r"(?=[A-Z])");
  String formatErrorMessage(String message) {
    return message.splitMapJoin(
      beforeCapitalLetter,
      onMatch: (p0) {
        return '${p0[0]} ';
      },
    ).replaceFirst(
        message.characters.first, message.characters.first.capitalize());
  }

  Future<void> initPlatformState() async {
    /// Set this to true if you're debugging. This enables printing
    Purchases.setDebugLogsEnabled(false);

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration("goog_vNVZjWFgEqVtULzDAKrmLaSryIc");
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration("appl_lhPFnQjvipbdcvvGNKqqNlfiFle");
    }
    try {
      await Purchases.configure(configuration!);
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      String revCatErrorMessage = formatErrorMessage(errorCode.name);

      final SnackBar snackBar = SnackBar(
        content: Text(revCatErrorMessage),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      throw Exception();
    }
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
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      String revCatErrorMessage = formatErrorMessage(errorCode.name);

      final SnackBar snackBar = SnackBar(
        content: Text(revCatErrorMessage),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return null;
    }
  }

  Future<bool?> isUserAnonymous() async {
    try {
      bool isAnonymous = await Purchases.isAnonymous;
      return isAnonymous;
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      String revCatErrorMessage = formatErrorMessage(errorCode.name);

      final SnackBar snackBar = SnackBar(
        content: Text(revCatErrorMessage),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return null;
    }
  }

  Future<CustomerInfo?> makePurchase(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      return customerInfo;
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      String revCatErrorMessage = formatErrorMessage(errorCode.name);

      final SnackBar snackBar = SnackBar(
        content: Text(revCatErrorMessage),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return null;
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
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      String revCatErrorMessage = formatErrorMessage(errorCode.name);

      final SnackBar snackBar = SnackBar(
        content: Text(revCatErrorMessage),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return null;
    }
  }

  Future<CustomerInfo?> restorePurchases() async {
    try {
      CustomerInfo restoredInfo = await Purchases.restorePurchases();
      // ... check restored customerInfo to see if entitlement is now active
      if (restoredInfo.activeSubscriptions.isNotEmpty ||
          restoredInfo.entitlements.active.isNotEmpty) {
        // Grant user "pro" access
        return restoredInfo;
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      String revCatErrorMessage = formatErrorMessage(errorCode.name);

      final SnackBar snackBar = SnackBar(
        content: Text(revCatErrorMessage),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return null;
    }
  }

  Future<void> logoutOfRevCat() async {
    try {
      await Purchases.logOut();
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      String revCatErrorMessage = formatErrorMessage(errorCode.name);

      final SnackBar snackBar = SnackBar(
        content: Text(revCatErrorMessage),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      throw Exception();
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
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      String revCatErrorMessage = formatErrorMessage(errorCode.name);

      final SnackBar snackBar = SnackBar(
        content: Text(revCatErrorMessage),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      throw Exception();
    }
  }

  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo;
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      String revCatErrorMessage = formatErrorMessage(errorCode.name);

      final SnackBar snackBar = SnackBar(
        content: Text(revCatErrorMessage),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
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
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      String revCatErrorMessage = formatErrorMessage(errorCode.name);

      final SnackBar snackBar = SnackBar(
        content: Text(revCatErrorMessage),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return null;
    }
  }
}

getUpdateListener() => Purchases.addCustomerInfoUpdateListener;
