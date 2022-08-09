import 'package:flutter/material.dart';

class Category {
  final String name;
  final Color categoryColor;
  final Color progressColor;
  int totalCards;
  int completedCards;
  Category({
    required this.name,
    required this.categoryColor,
    required this.progressColor,
    required this.totalCards,
    required this.completedCards,
  });
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
