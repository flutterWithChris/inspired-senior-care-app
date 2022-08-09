import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/base_database_repository.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => User.fromSnapshot(event));
  }

  @override
  Future<void> createUser(User user) async {
    await _firebaseFirestore.collection('users').doc(user.id).set(user.toMap());
  }

  @override
  Future<void> updateUser(User user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toMap())
        .then((value) => print('User document Updated**'));
  }

  void addNewGroup(Group group, User manager) async {
    DocumentReference docRef = _firebaseFirestore.collection('groups').doc();
    await docRef.set(group.toMap());
    String docId = docRef.id;
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(docId)
        .update({'groupId': docId});
    await _firebaseFirestore.collection('users').doc(manager.id).update({
      'groups': FieldValue.arrayUnion([docId]),
    });
  }

  void deleteGroup(Group group, User manager) async {
    DocumentReference docRef = _firebaseFirestore.collection('groups').doc();
    await docRef.set(group.toMap());
    String docId = docRef.id;
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(docId)
        .update({'groupId': docId});
    await _firebaseFirestore.collection('users').doc(manager.id).update({
      'groups': FieldValue.arrayRemove([docId]),
    });
  }

  Stream<Group> getGroup(String groupId) {
    return _firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((event) => Group.fromSnapshot(event));
  }

  Future<void> updateGroup(Group group) {
    return _firebaseFirestore
        .collection('groups')
        .doc(group.groupId)
        .update(group.toMap())
        .then((value) => print('Group Updated!'));
  }

  Future<void> updateProgress(
      User user, String categoryName, int currentCardNumber) {
    return _firebaseFirestore.collection('users').doc(user.id).set({
      'progress': {categoryName: currentCardNumber}
    }, SetOptions(merge: true));
  }
}
