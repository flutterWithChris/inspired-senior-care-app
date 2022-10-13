part of 'group_featured_category_cubit.dart';

abstract class GroupFeaturedCategoryState extends Equatable {
  const GroupFeaturedCategoryState();

  @override
  List<Object> get props => [];
}

class GroupFeaturedCategoryInitial extends GroupFeaturedCategoryState {}

class GroupFeaturedCategoryLoading extends GroupFeaturedCategoryState {}

class GroupFeaturedCategoryLoaded extends GroupFeaturedCategoryState {
  final String featuredCategoryName;
  final String suggestedCategory;
  const GroupFeaturedCategoryLoaded({
    required this.featuredCategoryName,
    required this.suggestedCategory,
  });
  @override
  // TODO: implement props
  List<Object> get props => [featuredCategoryName, suggestedCategory];
}

class GroupFeaturedCategoryUpdated extends GroupFeaturedCategoryState {}

class GroupFeaturedCategoryFailed extends GroupFeaturedCategoryState {}
