part of 'categories_bloc.dart';

@immutable
abstract class CategoriesState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final Category category;
  final List<dynamic> categoryImageUrls;
  CategoriesLoaded({
    required this.category,
    this.categoryImageUrls = const [],
  });
  @override
  // TODO: implement props
  List<Object?> get props => [category, categoryImageUrls];
}
