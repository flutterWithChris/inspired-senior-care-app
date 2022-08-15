import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';

import '../../data/models/category.dart';

part 'featured_category_state.dart';

class FeaturedCategoryCubit extends Cubit<FeaturedCategoryState> {
  Group currentGroup = Group.empty;
  final DatabaseRepository _databaseRepository;
  FeaturedCategoryCubit({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(FeaturedCategoryInitial());

  void loadFeaturedCategory(Group group) => _onLoadFeaturedCategory(group);
  void updateFeaturedCategory(Category category) =>
      _onUpdateFeaturedCategory(category);

  void _onLoadFeaturedCategory(Group group) async {
    emit(FeaturedCategoryLoading());
    await Future.delayed(const Duration(seconds: 1));
    currentGroup = group;
    emit(FeaturedCategoryLoaded(featuredCategoryName: group.featuredCategory!));
  }

  void _onUpdateFeaturedCategory(Category category) async {
    emit(FeaturedCategoryLoading());
    await _databaseRepository.setGroupFeaturedCategory(
        currentGroup.groupId!, category);
    currentGroup = currentGroup.copyWith(featuredCategory: category.name);
    emit(FeaturedCategoryUpdated());
    await Future.delayed(const Duration(seconds: 1));
    loadFeaturedCategory(currentGroup);
  }
}
