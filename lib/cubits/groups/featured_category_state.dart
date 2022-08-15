part of 'featured_category_cubit.dart';

abstract class FeaturedCategoryState extends Equatable {
  const FeaturedCategoryState();

  @override
  List<Object> get props => [];
}

class FeaturedCategoryInitial extends FeaturedCategoryState {}

class FeaturedCategoryLoading extends FeaturedCategoryState {}

class FeaturedCategoryLoaded extends FeaturedCategoryState {
  final String featuredCategoryName;
  const FeaturedCategoryLoaded({
    required this.featuredCategoryName,
  });
}

class FeaturedCategoryUpdated extends FeaturedCategoryState {}

class FeaturedCategoryFailed extends FeaturedCategoryState {}
