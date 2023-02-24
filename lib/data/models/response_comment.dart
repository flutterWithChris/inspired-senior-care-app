import 'package:cloud_firestore/cloud_firestore.dart';

class ResponseComment {
  String? commentId;
  String? commentTime;
  String? commenterId;
  String? commenterName;
  String? comment;
  String? userId;
  String? categoryName;
  int? cardNumber;

  ResponseComment({
    this.commentId,
    this.commentTime,
    this.commenterId,
    this.commenterName,
    this.comment,
    this.userId,
    this.categoryName,
    this.cardNumber,
  });

  ResponseComment.fromSnapshot(DocumentSnapshot snapshot) {
    commentId = snapshot.id;
    commentTime = snapshot['commentTime'];
    commenterId = snapshot['commenterId'];
    commenterName = snapshot['commenterName'];
    comment = snapshot['comment'];
    userId = snapshot['userId'];
    categoryName = snapshot['categoryName'];
    cardNumber = snapshot['cardNumber'];
  }

  Map<String, dynamic> toDocument() {
    return {
      'commentTime': commentTime,
      'commenterId': commenterId,
      'commenterName': commenterName,
      'comment': comment,
      'userId': userId,
      'categoryName': categoryName,
      'cardNumber': cardNumber,
    };
  }
}
