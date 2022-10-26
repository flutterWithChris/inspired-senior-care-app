import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:inspired_senior_care_app/data/models/bug_report.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/response.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/base_database_repository.dart';

import '../../models/invite.dart';

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
  Stream<User?> getUserByEmail(String emailAddress) {
    return _firebaseFirestore
        .collection('users')
        .where('email', isEqualTo: emailAddress)
        .limit(1)
        .snapshots()
        .map((event) => User.fromSnapshot(event.docs.first));
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

    await _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .collection('responses')
        .doc()
        .set({});
  }

  @override
  Future<void> updateUser(User user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toMap())
        .then((value) => print('User document Updated**'));
  }

  @override
  Future<void> deleteUser(User user) {
    List<String>? groupIds = user.groups;
    if (groupIds!.isNotEmpty && user.type == 'user') {
      for (String groupId in groupIds) {
        _firebaseFirestore.collection('groups').doc(groupId).update({
          'groupMemberIds': FieldValue.arrayRemove([user.id!])
        });
      }
    }
    if (groupIds.isNotEmpty && user.type == 'member') {
      for (String groupId in groupIds) {
        _firebaseFirestore.collection('groups').doc(groupId).update({
          'groupManagerIds': FieldValue.arrayRemove([user.id!])
        });
      }
    }
    _firebaseFirestore.collection('invites').doc(user.id).delete();
    return _firebaseFirestore.collection('users').doc(user.id).delete();
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

  Future<void> setGroupFeaturedCategory(String groupId, String categoryName) {
    return _firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .update({'featuredCategory': categoryName});
  }

  Future<String> getGroupFeaturedCategory(String groupId) {
    return _firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .get()
        .then((value) => value.data()!['featuredCategory']);
  }

  Future<Map<Group?, bool?>?> getGroupSubscriptionStatus(String userId) async {
    List<dynamic> groupIds = await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .get()
        .then((value) => value.data()?['groups']);

    if (groupIds.isNotEmpty) {
      List<Group> groups = [];
      for (String groupId in groupIds) {
        Group group = await _firebaseFirestore
            .collection('groups')
            .doc(groupId)
            .get()
            .then((value) => Group.fromSnapshot(value));
        groups.add(group);
      }
      if (groups.any((group) => group.isSubscribed == true)) {
        Group subscribedGroup =
            groups.firstWhere((group) => group.isSubscribed == true);
        return {subscribedGroup: true};
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> setGroupSubscriptionStatus(List<String> groupIds) async {
    for (String groupId in groupIds) {
      await _firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .set({'isSubscribed': true}, SetOptions(merge: true));
    }
  }

  Future<void> resetGroupSubscriptionStatus(String userId) async {
    List<Group> groups = [];
    await _firebaseFirestore
        .collection('groups')
        .where('groupOwnerId', isEqualTo: userId)
        .get()
        .then((value) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
        groups.add(Group.fromSnapshot(doc));
      }
    });
    for (Group group in groups) {
      await _firebaseFirestore
          .collection('groups')
          .doc(group.groupId)
          .set({'isSubscribed': false}, SetOptions(merge: true));
    }
  }

  Future<void> submitResponse(
      String categoryName, int cardNumber, String response) {
    return _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('responses')
        .doc(categoryName)
        .set({'${(cardNumber)}': response}, SetOptions(merge: true));
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
    try {
      await _firebaseFirestore.collection('users').doc(manager.id).update({
        'groups': FieldValue.arrayRemove([group.groupId]),
      });
      await _firebaseFirestore.collection('groups').doc(group.groupId).delete();
    } catch (e) {
      print(e);
    }
  }

  Stream<Group> getGroup(String groupId) {
    return _firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((event) => Group.fromSnapshot(event));
  }

  Stream<Group> getGroupMembers(String groupId) {
    return _firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((event) => Group.fromSnapshot(event));
  }

  Future<int> getGroupCount(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .get()
        .then((value) => List.from(value.get('groups')).length);
  }

  Future<List<String>> getGroups() {
    return _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((value) => List.from(value.get('groups')));
  }

  Stream<List<Group>> getManagerGroups(String userId) {
    return _firebaseFirestore
        .collection('groups')
        .where('groupManagerIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      print('Fetching Groups from Firebase');
      return snapshot.docs.map((doc) => Group.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Group>> getMemberGroups(String userId) {
    return _firebaseFirestore
        .collection('groups')
        .where('groupMemberIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
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

  Future<void> addMemberToGroup(
      String userId, String groupId, Invite invite) async {
    try {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'groups': FieldValue.arrayUnion([groupId])
      });

      await _firebaseFirestore.collection('groups').doc(groupId).update({
        'groupMemberIds': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addInvitedMemberToGroup(String userId, String groupId) async {
    try {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'groups': FieldValue.arrayUnion([groupId])
      });
      return await _firebaseFirestore.collection('groups').doc(groupId).update({
        'groupMemberIds': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void>? inviteMemberToGroup(Invite invite) async {
    try {
      var docRef = _firebaseFirestore
          .collection('invites')
          .doc(invite.invitedUserId)
          .collection('invites')
          .doc();

      docRef.set(invite.toMap());
      DocumentSnapshot documentSnapshot = await docRef.get();
      var docId = documentSnapshot.reference.id;
      docRef.set({'inviteId': docId}, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
    return;
  }

  Future<void>? deleteInvite(Invite invite) async {
    try {
      var docRef =
          _firebaseFirestore.collection('invites').doc(invite.invitedUserId);
      // Delete this invite
      docRef.collection('invites').doc(invite.inviteId).delete();
      // Delete user invite collection if empty
      docRef.collection('invites').get().then((value) async {
        if (value.size == 0) {
          await docRef.delete();
        }
      });
    } catch (e) {
      print(e);
    }
    return;
  }

  Stream<List<Invite>?>? getInvites() {
    auth.User? user = _firebaseAuth.currentUser;
    try {
      return _firebaseFirestore
          .collection('invites')
          .doc(user!.uid)
          .collection('invites')
          .get()
          .then((value) {
        var docs = value.docs;
        if (docs.isNotEmpty) {
          List<Invite> invites = [];
          for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs) {
            Invite thisInvite = Invite.fromSnapshot(doc);
            invites.add(thisInvite);
            print('Invite ${thisInvite.inviteId} Fetched***');
          }
          return invites;
        } else {
          return null;
        }
      }).asStream();
    } catch (e) {
      print(e);
    }
    return null;
  }

  Stream<List<Invite>?>? listenForInvites() {
    auth.User? user = _firebaseAuth.currentUser;
    try {
      return _firebaseFirestore
          .collection('invites')
          .doc(user!.uid)
          .collection('invites')
          .snapshots()
          .map((value) {
        var docs = value.docs;
        if (docs.isNotEmpty) {
          List<Invite> invites = [];
          for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs) {
            Invite thisInvite = Invite.fromSnapshot(doc);
            invites.add(thisInvite);
            print('Invite ${thisInvite.inviteId} Fetched***');
          }
          return invites;
        } else {
          return null;
        }
      });
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> removeMemberFromGroup(User user, Group group) async {
    try {
      await _firebaseFirestore.collection('users').doc(user.id).update({
        'groups': FieldValue.arrayRemove([group.groupId])
      });
      return await _firebaseFirestore
          .collection('groups')
          .doc(group.groupId)
          .update({
        'groupMemberIds': FieldValue.arrayRemove([user.id]),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addManagerToGroup(
      String userId, String groupId, Invite invite) async {
    try {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'groups': FieldValue.arrayUnion([groupId])
      });
      await _firebaseFirestore
          .collection(invite.invitedUserId)
          .doc()
          .collection('invites')
          .doc(invite.inviteId)
          .delete();
      return await _firebaseFirestore.collection('groups').doc(groupId).update({
        'groupManagerIds': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeManagerFromGroup(User user, Group group) async {
    try {
      await _firebaseFirestore.collection('users').doc(user.id).update({
        'groups': FieldValue.arrayRemove([group.groupId])
      });
      return await _firebaseFirestore
          .collection('groups')
          .doc(group.groupId)
          .update({
        'groupManagerIds': FieldValue.arrayRemove([user.id]),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendBugReport(BugReport bugReport) async {
    try {
      await _firebaseFirestore
          .collection('bug-reports')
          .doc()
          .set(bugReport.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProgress(
      User user, String categoryName, int currentCardNumber) {
    return _firebaseFirestore.collection('users').doc(user.id).set({
      'progress': {categoryName: currentCardNumber}
    }, SetOptions(merge: true));
  }
}
