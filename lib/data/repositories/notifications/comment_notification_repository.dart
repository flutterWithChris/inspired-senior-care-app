import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inspired_senior_care_app/data/models/comment_notification.dart';

class CommentNotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(CommentNotification commentNotification) async {
    var docRef = _firestore
        .collection('users')
        .doc(commentNotification.receiverId)
        .collection('comment-notifications')
        .doc();

    docRef.set(commentNotification.copyWith(id: docRef.id).toMap());
  }

  Future<void> deleteComment(CommentNotification commentNotification) async {
    _firestore
        .collection('users')
        .doc(commentNotification.receiverId)
        .collection('comment-notifications')
        .doc(commentNotification.id)
        .delete();
  }

  // Get a list of all comment notifications for a user as a stream
  Stream<List<CommentNotification>> getCommentNotifications(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('comment-notifications')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentNotification.fromMap(doc.data()))
            .toList());
  }
}
