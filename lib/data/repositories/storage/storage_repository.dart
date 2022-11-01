import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/data/repositories/storage/base_storage_repository.dart';
import 'package:inspired_senior_care_app/globals.dart';

class StorageRepository extends BaseStorageRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<List<String>> getCategoryCovers() async {
    try {
      var coverList = await storage.ref('card-covers').listAll();
      var coverCount = coverList.items.length;
      List<String> coverUrls = [];

      for (int i = 0; i < coverCount; i++) {
        String categoryCoverURL = await coverList.items[i].getDownloadURL();
        coverUrls.add(categoryCoverURL);
      }

      return coverUrls;
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      throw Exception();
    }
  }

  Future<List<String>> getCategoryCards(String categoryName) async {
    try {
      var cardList = await storage.ref('card-contents/$categoryName').listAll();

      int cardCount = cardList.items.length;
      List<String> cardImageURLs = [];

      for (int i = 1; i < cardCount + 1; i++) {
        String cardImageURL = await storage
            .ref('card-contents/$categoryName/$i.png')
            .getDownloadURL();
        cardImageURLs.add(cardImageURL);
      }

      return cardImageURLs;
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      throw Exception();
    }
  }
}
