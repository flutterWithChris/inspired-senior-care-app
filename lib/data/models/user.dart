import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/data/models/user_type.dart';

class User {
  final String? name;
  final String? emailAddress;
  final UserType? type;
  final String? title;
  final Color? userColor;

  const User({
    this.name,
    this.emailAddress,
    this.type,
    this.title,
    this.userColor,
  });

  static const empty = User(name: '');

  User copyWith({
    String? name,
    String? emailAddress,
    UserType? type,
    String? title,
    Color? userColor,
  }) {
    return User(
      name: name ?? this.name,
      emailAddress: emailAddress ?? this.emailAddress,
      type: type ?? this.type,
      title: title ?? this.title,
      userColor: userColor ?? this.userColor,
    );
  }
}
