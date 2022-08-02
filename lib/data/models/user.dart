import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? type;
  final String? title;
  final String? userColor;

  const User({
    this.id,
    this.name,
    this.email,
    this.type,
    this.title,
    this.userColor,
  });

  static User fromSnapshot(DocumentSnapshot snap) {
    User user = User(
        id: snap['id'],
        name: snap['name'],
        email: snap['email'],
        type: snap['type'],
        title: snap['title'],
        userColor: snap['userColor']);

    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'type': type,
      'title': title,
      'userColor': userColor,
    };
  }

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? type,
    String? title,
    String? userColor,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      type: type ?? this.type,
      title: title ?? this.title,
      userColor: userColor ?? this.userColor,
    );
  }
}
