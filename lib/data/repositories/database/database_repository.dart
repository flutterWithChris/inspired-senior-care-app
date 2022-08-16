import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/response.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/base_database_repository.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => User.fromSnapshot(event));
  }

  @override
  Stream<List<User>>? getUsers(List<String> userIds) {
    for (String userId in userIds) {
      return _firebaseFirestore
          .collection('users')
          .doc(userId)
          .snapshots()
          .map((event) => User.fromSnapshot(event))
          .toList()
          .asStream();
    }
    return null;
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

  Stream<List<Category>?> getCategories() {
    final List<Category> categories = [];
    return _firebaseFirestore.collection('categories').get().then((snap) {
      for (int i = 0; i < snap.docs.length; i++) {
        categories.add(Category.fromSnapshot(snap.docs[i]));
      }
      return categories;
    }).asStream();
  }

  Stream<Category> getCategory(String categoryName) {
    final List<Category> categories = [];
    return _firebaseFirestore
        .collection('categories')
        .where({'categoryName': categoryName})
        .snapshots()
        .map((snap) => Category.fromSnapshot(snap.docs.first));
  }

  Future<void> setGroupFeaturedCategory(String groupId, Category category) {
    return _firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .update({'featuredCategory': category.name});
  }

  Future<void> submitResponse(
      String categoryName, int cardNumber, String response) {
    return _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('responses')
        .doc(categoryName)
        .set({'$cardNumber': response}, SetOptions(merge: true));
  }

  Stream<Response> viewResponse(User user, Category category, int cardNumber) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .collection('responses')
        .doc(category.name)
        .snapshots()
        .map((event) => Response.fromSnapshot(event, cardNumber));
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
    await _firebaseFirestore.collection('users').doc(manager.id).update({
      'groups': FieldValue.arrayRemove([group.groupId]),
    });
  }

  Stream<Group> getGroup(String groupId) {
    return _firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((event) => Group.fromSnapshot(event));
  }

  Stream<List<Group>> getGroups(User user) {
    return _firebaseFirestore.collection('groups').snapshots().map((snapshot) {
      print('Fetching Groups from Firebase');
      return snapshot.docs.map((doc) => Group.fromSnapshot(doc)).toList();
    });
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
