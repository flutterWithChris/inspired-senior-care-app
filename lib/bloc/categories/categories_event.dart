part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent extends Equatable {
  List<dynamic>? categoryImageUrls;
  @override
  List<Object?> get props => [categoryImageUrls];
}

class LoadCategories extends CategoriesEvent {}

class UpdateCategories extends CategoriesEvent {
  @override
  final List<dynamic> categoryImageUrls;
  UpdateCategories({
    required this.categoryImageUrls,
  });

  @override
  List<Object?> get props => [categoryImageUrls];
}
