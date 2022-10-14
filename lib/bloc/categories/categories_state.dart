part of 'categories_bloc.dart';

@immutable
abstract class CategoriesState extends Equatable {
  final List<Category>? categories;
  final List<dynamic>? categoryImageUrls;
  const CategoriesState({
    this.categories,
    this.categoryImageUrls,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [categories, categoryImageUrls];
}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  @override
  final List<Category> categories;
  @override
  final List<dynamic> categoryImageUrls;
  const CategoriesLoaded({
    required this.categories,
    this.categoryImageUrls = const [],
  });
  @override
  // TODO: implement props
  List<Object?> get props => [categories, categoryImageUrls];
}

class CategoriesFailed extends CategoriesState {}
