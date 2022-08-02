import 'package:inspired_senior_care_app/data/models/user.dart';

abstract class BaseDatabaseRepository {
  Stream<User> getUser(String userId);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  //Future<void> updateUserPictures();
}
