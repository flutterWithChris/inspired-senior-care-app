part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoadCategories extends CategoriesEvent {}

class UpdateCategories extends CategoriesEvent {
  final List<dynamic> categoryImageUrls;
  UpdateCategories({
    required this.categoryImageUrls,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [categoryImageUrls];
}
