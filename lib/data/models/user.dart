import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/data/models/user_type.dart';

class User {
  final String? id;
  final String? name;
  final String? email;
  final UserType? type;
  final String? title;
  final Color? userColor;

  const User({
    this.id,
    this.name,
    this.email,
    this.type,
    this.title,
    this.userColor,
  });

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  User copyWith({
    String? id,
    String? name,
    String? email,
    UserType? type,
    String? title,
    Color? userColor,
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
