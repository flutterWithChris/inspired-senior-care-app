class Category {
  final String name;
  final String categoryColor;
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
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 12,
      completedCards: 0),
  Category(
      name: 'Building Blocks 2',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 16,
      completedCards: 0),
  Category(
      name: 'Communication',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 24,
      completedCards: 0),
  Category(
      name: 'Damaging Interactions',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 15,
      completedCards: 0),
  Category(
      name: 'Genuine Relationships',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 23,
      completedCards: 0),
  Category(
      name: 'Language Matters',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 12,
      completedCards: 0),
  Category(
      name: 'Meaningful Engagemenet',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 18,
      completedCards: 0),
  Category(
      name: 'Positive Interactions',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 21,
      completedCards: 0),
  Category(
      name: 'Strengths Based',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 10,
      completedCards: 0),
  Category(
      name: 'Supportive Environment',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 12,
      completedCards: 0),
  Category(
      name: 'Well Being',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 16,
      completedCards: 0),
  Category(
      name: 'What if',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 20,
      completedCards: 0),
  Category(
      name: 'Wildly Curious',
      categoryColor: 'red',
      progressColor: 'lightBlue',
      totalCards: 12,
      completedCards: 0),
];
