import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/view/widget/name_plate.dart';

class Category {
  final String name;
  final String coverImageUrl;
  final String description;
  final Color categoryColor;
  final Color progressColor;
  int? totalCards;

  Category({
    required this.name,
    required this.description,
    required this.coverImageUrl,
    required this.categoryColor,
    required this.progressColor,
    this.totalCards,
  });

  static Category fromSnapshot(DocumentSnapshot snap) {
    Category category = Category(
      name: snap.reference.id,
      description: snap['description'],
      coverImageUrl: snap['coverImageUrl'],
      totalCards: snap['totalCards'],
      categoryColor: hexToColor(snap['categoryColor']),
      progressColor: hexToColor(snap['progressColor']),
    );
    return category;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'categoryColor': categoryColor.value,
      'progressColor': progressColor.value,
      'totalCards': totalCards,
    };
  }

  Category copyWith({
    String? name,
    String? coverImageUrl,
    String? description,
    Map<int, String>? cardImages,
    Color? categoryColor,
    Color? progressColor,
    int? totalCards,
  }) {
    return Category(
      name: name ?? this.name,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      categoryColor: categoryColor ?? this.categoryColor,
      progressColor: progressColor ?? this.progressColor,
      totalCards: totalCards ?? this.totalCards,
    );
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] ?? '',
      description: map['description'],
      coverImageUrl: map['coverImageUrl'],
      categoryColor: Color(map['categoryColor']),
      progressColor: Color(map['progressColor']),
      totalCards: map['totalCards']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));
}
