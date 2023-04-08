import 'package:cloud_firestore/cloud_firestore.dart';

class CommentNotification {
  String? id;
  String senderId;
  String receiverId;
  String senderName;
  String categoryName;
  int cardNumber;
  CommentNotification({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.categoryName,
    required this.cardNumber,
  });

  CommentNotification copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? senderName,
    String? categoryName,
    int? cardNumber,
  }) {
    return CommentNotification(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderName: senderName ?? this.senderName,
      categoryName: categoryName ?? this.categoryName,
      cardNumber: cardNumber ?? this.cardNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'categoryName': categoryName,
      'cardNumber': cardNumber,
    };
  }

  factory CommentNotification.fromSnapshot(DocumentSnapshot snapshot) {
    return CommentNotification(
      id: snapshot.id,
      senderId: snapshot['senderId'],
      receiverId: snapshot['receiverId'],
      senderName: snapshot['senderName'],
      categoryName: snapshot['categoryName'],
      cardNumber: snapshot['cardNumber'],
    );
  }

  factory CommentNotification.fromMap(Map<String, dynamic> map) {
    return CommentNotification(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      senderName: map['senderName'],
      categoryName: map['categoryName'],
      cardNumber: map['cardNumber'],
    );
  }
}
