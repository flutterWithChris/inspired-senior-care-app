import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:inspired_senior_care_app/data/repositories/storage/base_storage_repository.dart';

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
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<List<String>> getCategoryCards(String categoryName) async {
    try {
      print('Getting Cards...');
      var cardList = await storage.ref('card-contents/$categoryName').listAll();

      int cardCount = cardList.items.length;
      print('This many cards: $cardCount');
      List<String> cardImageURLs = [];

      for (int i = 1; i < cardCount + 1; i++) {
        String cardImageURL = await storage
            .ref('card-contents/$categoryName/$i.png')
            .getDownloadURL();
        cardImageURLs.add(cardImageURL);
      }

      return cardImageURLs;
    } catch (e) {
      print('Error Loading Cards!');
      throw Exception(e);
    }
  }
}
