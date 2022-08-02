import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:inspired_senior_care_app/data/repositories/storage/base_storage_repository.dart';

class StorageRepository extends BaseStorageRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
}
