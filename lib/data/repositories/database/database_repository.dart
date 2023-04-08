import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/data/models/bug_report.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/response_comment.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/base_database_repository.dart';
import 'package:inspired_senior_care_app/globals.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/invite.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  @override
  Stream<User> getUser(String userId) {
    try {
      return _firebaseFirestore
          .collection('users')
          .doc(userId)
          .snapshots()
          .map((event) => User.fromSnapshot(event));
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

  @override
  Stream<User?> getUserByEmail(String emailAddress) {
    try {
      return _firebaseFirestore
          .collection('users')
          .where('email', isEqualTo: emailAddress)
          .limit(1)
          .snapshots()
          .map((event) => event.docs.isNotEmpty
              ? User.fromSnapshot(event.docs.first)
              : null);
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

  @override
  Stream<List<User>>? getUsers(List<String> userIds) {
    for (String userId in userIds) {
      try {
        return _firebaseFirestore
            .collection('users')
            .doc(userId)
            .snapshots()
            .map((event) => User.fromSnapshot(event))
            .toList()
            .asStream();
      } on FirebaseException catch (e) {
        final SnackBar snackBar = SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.redAccent,
        );
        snackbarKey.currentState?.showSnackBar(snackBar);
        (e, stack) =>
            FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> createUser(User user) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .set(user.toMap());

      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .collection('responses')
          .doc()
          .set({});
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

  @override
  Future<void> updateUser(User user) async {
    try {
      return await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .update(user.toMap());
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

  @override
  Future<void> deleteUser(User user) async {
    try {
      List<String>? groupIds = user.groups;
      if (groupIds!.isNotEmpty && user.type == 'user') {
        for (String groupId in groupIds) {
          await _firebaseFirestore.collection('groups').doc(groupId).update({
            'groupMemberIds': FieldValue.arrayRemove([user.id!])
          });
        }
      }
      if (groupIds.isNotEmpty && user.type == 'member') {
        for (String groupId in groupIds) {
          await _firebaseFirestore.collection('groups').doc(groupId).update({
            'groupManagerIds': FieldValue.arrayRemove([user.id!])
          });
        }
      }
      _firebaseFirestore.collection('invites').doc(user.id).delete();
      return await _firebaseFirestore.collection('users').doc(user.id).delete();
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

  Stream<List<Category>?> getCategories() {
    try {
      final List<Category> categories = [];
      return _firebaseFirestore.collection('categories').get().then((snap) {
        for (int i = 0; i < snap.docs.length; i++) {
          categories.add(Category.fromSnapshot(snap.docs[i]));
        }
        return categories;
      }).asStream();
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

  Stream<Category> getCategory(String categoryName) {
    try {
      return _firebaseFirestore
          .collection('categories')
          .where({'categoryName': categoryName})
          .snapshots()
          .map((snap) => Category.fromSnapshot(snap.docs.first));
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

  // Get category as future
  Future<Category> getCategoryFuture(String categoryName) async {
    return await _firebaseFirestore
        .collection('categories')
        .doc(categoryName)
        .get()
        .then((value) => Category.fromSnapshot(value));
  }

  Future<void> setGroupFeaturedCategory(
      String groupId, String categoryName) async {
    try {
      return await _firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .update({'featuredCategory': categoryName});
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

  Future<String> getGroupFeaturedCategory(String groupId) async {
    try {
      return await _firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .get()
          .then((value) => value.data()!['featuredCategory']);
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

  Future<bool> getGroupScheduleStatus(String groupId) async {
    try {
      return await _firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .get()
          .then((value) => value.data()!['onSchedule']);
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

  // Get group featured category as a stream
  Stream<String> getGroupFeaturedCategoryStream(String groupId) {
    try {
      return _firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .snapshots()
          .map((snap) => snap.data()!['featuredCategory']);
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

  Future<Map<Group?, bool?>?> getGroupSubscriptionStatus(String userId) async {
    try {
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
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return null;
    }
  }

  Future<void> setGroupSubscriptionStatus(List<String> groupIds) async {
    try {
      for (String groupId in groupIds) {
        await _firebaseFirestore
            .collection('groups')
            .doc(groupId)
            .set({'isSubscribed': true}, SetOptions(merge: true));
      }
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

  Future<void> resetGroupSubscriptionStatus(String userId) async {
    try {
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

  Future<void> submitResponse(
      String categoryName, int cardNumber, String response) async {
    try {
      return await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('responses')
          .doc(categoryName)
          .set({'${(cardNumber)}': response}, SetOptions(merge: true));
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

  Future<String?> viewResponse(User user, Category category, int cardNumber) {
    try {
      return _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .collection('responses')
          .doc(category.name)
          .get()
          .then((value) => value.data()!['$cardNumber']);
      // .snapshots()
      // .map((event) => Response.fromSnapshot(event, cardNumber).response);
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

  void addNewGroup(Group group, User manager) async {
    try {
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

  void deleteGroup(Group group, User manager) async {
    try {
      await _firebaseFirestore.collection('users').doc(manager.id).update({
        'groups': FieldValue.arrayRemove([group.groupId]),
      });
      await _firebaseFirestore.collection('groups').doc(group.groupId).delete();
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

  Stream<Group> getGroup(String groupId) {
    try {
      return _firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .snapshots()
          .map((event) => Group.fromSnapshot(event));
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

  Stream<Group> getGroupMembers(String groupId) {
    try {
      return _firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .snapshots()
          .map((event) => Group.fromSnapshot(event));
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

  Future<int> getGroupCount(String userId) async {
    try {
      return await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .get()
          .then((value) => List.from(value.get('groups')).length);
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

  Future<List<String>> getGroups() async {
    try {
      return await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .get()
          .then((value) => List.from(value.get('groups')));
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

  Stream<List<Group>> getManagerGroups(String userId) {
    try {
      final ownedGroups = _firebaseFirestore
          .collection('groups')
          .where('groupOwnerId', isEqualTo: userId)
          .snapshots();
      final sharedGroups = _firebaseFirestore
          .collection('groups')
          .where('groupManagerIds', arrayContains: userId)
          .snapshots();
      return MergeStream([ownedGroups, sharedGroups]).map((snapshot) {
        return snapshot.docs.map((doc) => Group.fromSnapshot(doc)).toList();
      });
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

  // Get manager groups as future
  Future<List<Group>> getManagerGroupsAsFuture(String userId) async {
    try {
      final ownedGroups = await _firebaseFirestore
          .collection('groups')
          .where('groupOwnerId', isEqualTo: userId)
          .get();
      final sharedGroups = await _firebaseFirestore
          .collection('groups')
          .where('groupManagerIds', arrayContains: userId)
          .get();
      return ownedGroups.docs
          .map((doc) => Group.fromSnapshot(doc))
          .toList()
          .followedBy(sharedGroups.docs.map((doc) => Group.fromSnapshot(doc)))
          .toList();
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

  Stream<List<Group>> getMemberGroups(String userId) {
    try {
      return _firebaseFirestore
          .collection('groups')
          .where('groupMemberIds', arrayContains: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Group.fromSnapshot(doc)).toList();
      });
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

// Get Member groups as future
  Future<List<Group>> getMemberGroupsAsFuture(String userId) async {
    try {
      final memberGroups = await _firebaseFirestore
          .collection('groups')
          .where('groupMemberIds', arrayContains: userId)
          .get();
      return memberGroups.docs.map((doc) => Group.fromSnapshot(doc)).toList();
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

  Future<void> updateGroup(Group group) async {
    try {
      return await _firebaseFirestore
          .collection('groups')
          .doc(group.groupId)
          .update(group.toMap());
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

  Future<void> addMemberToGroup(
      String userId, String groupId, Invite invite) async {
    try {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'groups': FieldValue.arrayUnion([groupId])
      });

      await _firebaseFirestore.collection('groups').doc(groupId).update({
        'groupMemberIds': FieldValue.arrayUnion([userId])
      });
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return;
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
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return;
    }
  }

  Future<void>? inviteMemberToGroup(Invite invite) async {
    try {
      String inviteId =
          DateTime.now().millisecondsSinceEpoch.toString().substring(0, 13);
      var docRef = _firebaseFirestore
          .collection('invites')
          .doc(invite.invitedUserId)
          .collection('invites')
          .doc(inviteId);

      await docRef.set(invite.copyWith(inviteId: inviteId).toMap());

      /// Create invite reference for inviter to see sent status
      await _firebaseFirestore
          .collection('users')
          .doc(invite.inviterId)
          .collection('sent-invites')
          .doc(inviteId)
          .set(invite.copyWith(inviteId: inviteId).toMap());

      DocumentSnapshot documentSnapshot = await docRef.get();
      //   var docId = documentSnapshot.reference.id;
      // docRef.set({'inviteId': docId}, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return;
    }
  }

  Future<void>? deleteInvite(Invite invite) async {
    try {
      var docRef =
          _firebaseFirestore.collection('invites').doc(invite.invitedUserId);
      // Delete this invite
      docRef.collection('invites').doc(invite.inviteId).delete();
      // Delete user invite collection if empty

      /// Delete invite reference for inviter.
      await _firebaseFirestore
          .collection('users')
          .doc(invite.inviterId)
          .collection('sent-invites')
          .doc(invite.inviteId)
          .delete();
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
    }
  }

  Future<void>? declineInvite(Invite invite) async {
    String inviteId =
        DateTime.now().millisecondsSinceEpoch.toString().substring(0, 13);
    try {
      var docRef =
          _firebaseFirestore.collection('invites').doc(invite.invitedUserId);
      // Delete this invite
      await docRef.collection('invites').doc(invite.inviteId).delete();

      /// Delete invite reference for inviter.
      await _firebaseFirestore
          .collection('users')
          .doc(invite.inviterId)
          .collection('sent-invites')
          .doc(invite.inviteId)
          .delete();

      // Create copy of invite with status declined
      await _firebaseFirestore
          .collection('users')
          .doc(invite.inviterId)
          .collection('sent-invites')
          .doc(inviteId)
          .set(invite.copyWith(status: 'declined').toMap());
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
    }
  }

  Future<void>? acceptInvite(Invite invite) async {
    String inviteId =
        DateTime.now().millisecondsSinceEpoch.toString().substring(0, 13);
    try {
      var docRef =
          _firebaseFirestore.collection('invites').doc(invite.invitedUserId);
      // Delete this invite
      await docRef.collection('invites').doc(invite.inviteId).delete();
      // Delete user invite collection if empty

      /// Delete invite reference for inviter.
      await _firebaseFirestore
          .collection('users')
          .doc(invite.inviterId)
          .collection('sent-invites')
          .doc(invite.inviteId)
          .delete();

      // Create copy of invite with status accepted
      await _firebaseFirestore
          .collection('users')
          .doc(invite.inviterId)
          .collection('sent-invites')
          .doc(inviteId)
          .set(invite.copyWith(status: 'accepted').toMap());
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
    }
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
          }
          return invites;
        } else {
          return null;
        }
      }).asStream();
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return null;
    }
  }

  Stream<List<Invite>?>? getSentInvites() {
    auth.User? user = _firebaseAuth.currentUser;
    try {
      return _firebaseFirestore
          .collection('users')
          .doc(user!.uid)
          .collection('sent-invites')
          .get()
          .then((value) {
        var docs = value.docs;
        if (docs.isNotEmpty) {
          List<Invite> invites = [];
          for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs) {
            Invite thisInvite = Invite.fromSnapshot(doc);
            invites.add(thisInvite);
          }
          return invites;
        } else {
          return null;
        }
      }).asStream();
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return null;
    }
  }

  // Get count of invites as future
  Future<int>? getInviteCount() {
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
          return docs.length;
        } else {
          return 0;
        }
      });
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return null;
    }
  }

  // Get count of invites & comment notifications as future
  Future<int>? getNotificationCount() {
    auth.User? user = _firebaseAuth.currentUser;
    try {
      return _firebaseFirestore
          .collection('users')
          .doc(user!.uid)
          .collection('comment-notifications')
          .get()
          .then((value) {
        var docs = value.docs;
        if (docs.isNotEmpty) {
          return docs.length;
        } else {
          return 0;
        }
      });
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return null;
    }
  }

  Stream<List<Invite>?> listenForInvites() {
    auth.User? user = _firebaseAuth.currentUser;
    try {
      List<Invite> invites = [];
      return _firebaseFirestore
          .collection('invites')
          .doc(user!.uid)
          .collection('invites')
          .snapshots()
          .map((value) {
        for (var change in value.docChanges) {
          if (change.type == DocumentChangeType.added) {
            Invite thisInvite = Invite.fromSnapshot(change.doc);
            invites.add(thisInvite);
          }
          if (change.type == DocumentChangeType.removed) {
            Invite thisInvite = Invite.fromSnapshot(change.doc);
            invites.remove(thisInvite);
          }
          if (change.type == DocumentChangeType.modified) {
            Invite thisInvite = Invite.fromSnapshot(change.doc);
            invites.remove(thisInvite);
            invites.add(thisInvite);
          }
        }

        return invites;
      });
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      rethrow;
    }
  }

  Stream<List<Invite>?> listenForSentInvites() {
    auth.User? user = _firebaseAuth.currentUser;
    try {
      List<Invite> invites = [];
      return _firebaseFirestore
          .collection('users')
          .doc(user!.uid)
          .collection('sent-invites')
          .snapshots()
          .map((value) {
        for (var change in value.docChanges) {
          if (change.type == DocumentChangeType.added) {
            Invite thisInvite = Invite.fromSnapshot(change.doc);
            invites.add(thisInvite);
          }
          if (change.type == DocumentChangeType.removed) {
            Invite thisInvite = Invite.fromSnapshot(change.doc);
            invites.remove(thisInvite);
          }
          if (change.type == DocumentChangeType.modified) {
            Invite thisInvite = Invite.fromSnapshot(change.doc);
            invites.remove(thisInvite);
            invites.add(thisInvite);
          }
        }

        return invites;
      });
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      rethrow;
    }
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
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
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
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
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
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
    }
  }

  Future<void> sendBugReport(BugReport bugReport) async {
    try {
      await _firebaseFirestore
          .collection('bug-reports')
          .doc()
          .set(bugReport.toMap());
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
    }
  }

  Future<void> updateProgress(
      User user, String categoryName, int currentCardNumber) async {
    try {
      await _firebaseFirestore.collection('users').doc(user.id).set({
        'progress': {categoryName: currentCardNumber}
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
    }
  }

  // Send response comments to the database
  Future<void> sendResponseComment(ResponseComment responseComment) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(responseComment.userId)
          .collection('responses')
          .doc(responseComment.categoryName!)
          .collection('response-comments')
          .doc(
              '${responseComment.cardNumber.toString()}:${responseComment.commenterId}')
          .set(responseComment.toDocument());
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
    }
  }

  // Check if response comment exists & fetch it
  Future<ResponseComment?> fetchResponseComment(
      String userId, String categoryName, int cardNumber) async {
    try {
      var responseComment = await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('responses')
          .doc(categoryName)
          .collection('response-comments')
          .doc('$cardNumber:${_firebaseAuth.currentUser!.uid}')
          .get();
      if (responseComment.exists) {
        return ResponseComment.fromSnapshot(responseComment);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      rethrow;
    }
  }

  // Fetch all response documents for a specific card
  Future<List<ResponseComment>> fetchAllResponseComments(
      String userId, String categoryName, int cardNumber) async {
    try {
      // Get all doauments from the response-comments collection

      var responseComments = await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('responses')
          .doc(categoryName)
          .collection('response-comments')
          .where('cardNumber', isEqualTo: cardNumber)
          .get()
          .then((value) => value.docs);
      return responseComments
          .map((responseComment) =>
              ResponseComment.fromSnapshot(responseComment))
          .toList();
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      rethrow;
    }
  }

  // Delete response comment
  Future<void> deleteResponseComment(ResponseComment responseComment) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(responseComment.userId)
          .collection('responses')
          .doc(responseComment.categoryName!)
          .collection('response-comments')
          .doc(responseComment.commenterId)
          .collection(responseComment.cardNumber.toString())
          .doc(responseComment.commenterId)
          .delete();
    } on FirebaseException catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      (e, stack) =>
          FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
    }
  }
}
