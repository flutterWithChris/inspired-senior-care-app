import 'package:flutter/material.dart';

class Category {
  final String name;
  final Color categoryColor;
  final String progressColor;
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
      progressColor: 'lightBlue',
      totalCards: 12,
      completedCards: 0),
  Category(
      name: 'Building Blocks',
      categoryColor: Colors.black,
      progressColor: 'lightBlue',
      totalCards: 16,
      completedCards: 0),
  Category(
      name: 'Communication',
      categoryColor: Colors.deepOrange,
      progressColor: 'lightBlue',
      totalCards: 24,
      completedCards: 0),
  Category(
      name: 'Damaging Interactions',
      categoryColor: Colors.grey,
      progressColor: 'lightBlue',
      totalCards: 15,
      completedCards: 0),
  Category(
      name: 'Genuine Relationships',
      categoryColor: Colors.red,
      progressColor: 'lightBlue',
      totalCards: 23,
      completedCards: 0),
  Category(
      name: 'Language Matters',
      categoryColor: Colors.blue,
      progressColor: 'lightBlue',
      totalCards: 12,
      completedCards: 0),
  Category(
      name: 'Meaningful Engagement',
      categoryColor: Colors.purple,
      progressColor: 'lightBlue',
      totalCards: 18,
      completedCards: 0),
  Category(
      name: 'Positive Interactions',
      categoryColor: Colors.redAccent,
      progressColor: 'lightBlue',
      totalCards: 21,
      completedCards: 0),
  Category(
      name: 'Strengths Based',
      categoryColor: Colors.lightGreen,
      progressColor: 'lightBlue',
      totalCards: 10,
      completedCards: 0),
  Category(
      name: 'Supportive Environment',
      categoryColor: Colors.yellow,
      progressColor: 'lightBlue',
      totalCards: 12,
      completedCards: 0),
  Category(
      name: 'Well Being',
      categoryColor: Colors.teal,
      progressColor: 'lightBlue',
      totalCards: 16,
      completedCards: 0),
  Category(
      name: 'What if',
      categoryColor: Colors.pinkAccent,
      progressColor: 'lightBlue',
      totalCards: 20,
      completedCards: 0),
  Category(
      name: 'Wildly Curious',
      categoryColor: Colors.pink,
      progressColor: 'lightBlue',
      totalCards: 12,
      completedCards: 0),
];
