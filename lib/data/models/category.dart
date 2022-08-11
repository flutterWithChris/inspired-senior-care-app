import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/view/widget/name_plate.dart';

class Category {
  final String name;
  final Color categoryColor;
  final Color progressColor;
  int? totalCards;
  int? completedCards;

  Category({
    required this.name,
    required this.categoryColor,
    required this.progressColor,
    this.totalCards,
    this.completedCards,
  });

  static Category fromSnapshot(DocumentSnapshot snap) {
    Category category = Category(
      name: snap.reference.id,
      categoryColor: hexToColor(snap['categoryColor']),
      progressColor: hexToColor(snap['progressColor']),
    );
    return category;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryColor': categoryColor.value,
      'progressColor': progressColor.value,
      'totalCards': totalCards,
      'completedCards': completedCards,
    };
  }

  Category copyWith({
    String? name,
    Map<int, String>? cardImages,
    Color? categoryColor,
    Color? progressColor,
    int? totalCards,
    int? completedCards,
  }) {
    return Category(
      name: name ?? this.name,
      categoryColor: categoryColor ?? this.categoryColor,
      progressColor: progressColor ?? this.progressColor,
      totalCards: totalCards ?? this.totalCards,
      completedCards: completedCards ?? this.completedCards,
    );
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] ?? '',
      categoryColor: Color(map['categoryColor']),
      progressColor: Color(map['progressColor']),
      totalCards: map['totalCards']?.toInt(),
      completedCards: map['completedCards']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));
}

List<Category> categoryList = [
  Category(
      name: 'Brain Change',
      categoryColor: Colors.green,
      progressColor: Colors.lightBlue,
      totalCards: 12,
      completedCards: 0),
  Category(
      name: 'Building Blocks',
      categoryColor: Colors.black,
      progressColor: Colors.white,
      totalCards: 16,
      completedCards: 0),
  Category(
      name: 'Communication',
      categoryColor: Colors.deepOrange,
      progressColor: Colors.pink,
      totalCards: 24,
      completedCards: 0),
  Category(
      name: 'Damaging Interactions',
      categoryColor: Colors.grey,
      progressColor: Colors.blueAccent,
      totalCards: 15,
      completedCards: 0),
  Category(
      name: 'Genuine Relationships',
      categoryColor: Colors.red,
      progressColor: Colors.blueAccent,
      totalCards: 23,
      completedCards: 0),
  Category(
      name: 'Language Matters',
      categoryColor: Colors.blue,
      progressColor: Colors.orangeAccent,
      totalCards: 12,
      completedCards: 0),
  Category(
      name: 'Meaningful Engagement',
      categoryColor: Colors.purple,
      progressColor: Colors.lightGreen,
      totalCards: 18,
      completedCards: 0),
  Category(
      name: 'Positive Interactions',
      categoryColor: Colors.redAccent,
      progressColor: Colors.lightBlueAccent,
      totalCards: 21,
      completedCards: 0),
  Category(
      name: 'Strengths Based',
      categoryColor: Colors.lightGreen,
      progressColor: Colors.purpleAccent,
      totalCards: 10,
      completedCards: 0),
  Category(
      name: 'Supportive Environment',
      categoryColor: Colors.yellow,
      progressColor: Colors.blue,
      totalCards: 12,
      completedCards: 0),
  Category(
      name: 'Well Being',
      categoryColor: Colors.teal,
      progressColor: Colors.pink,
      totalCards: 16,
      completedCards: 0),
  Category(
      name: 'What if',
      categoryColor: Colors.pinkAccent,
      progressColor: Colors.green,
      totalCards: 20,
      completedCards: 0),
  Category(
      name: 'Wildly Curious',
      categoryColor: Colors.pink,
      progressColor: Colors.cyan,
      totalCards: 12,
      completedCards: 0),
];
