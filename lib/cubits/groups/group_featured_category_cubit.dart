import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';

import '../../data/models/category.dart';

part 'group_featured_category_state.dart';

class GroupFeaturedCategoryCubit extends Cubit<GroupFeaturedCategoryState> {
  Group currentGroup = Group.empty;
  final DatabaseRepository _databaseRepository;

  GroupFeaturedCategoryCubit({
    required DatabaseRepository databaseRepository,
    required CategoriesBloc categoriesBloc,
  })  : _databaseRepository = databaseRepository,
        super(GroupFeaturedCategoryLoading());

  void loadFeaturedCategory(Group group) => _onLoadFeaturedCategory(group);
  void loadFeaturedCategoryById(String groupId) =>
      _onLoadFeaturedCategoryById(groupId);
  void updateFeaturedCategory(Category category) =>
      _onUpdateFeaturedCategory(category);

  void _onLoadFeaturedCategory(Group group) async {
    emit(GroupFeaturedCategoryLoading());
    await Future.delayed(const Duration(milliseconds: 250));
    currentGroup = group;
    emit(GroupFeaturedCategoryLoaded(
        featuredCategoryName: group.featuredCategory!));
  }

  void _onLoadFeaturedCategoryById(String groupId) async {
    emit(GroupFeaturedCategoryLoading());
    await Future.delayed(const Duration(seconds: 1));

    _databaseRepository.getGroup(groupId).listen((group) {
      currentGroup = group;
    }).onData((data) {
      emit(GroupFeaturedCategoryLoaded(
          featuredCategoryName: data.featuredCategory!));
    });
  }

  void _onUpdateFeaturedCategory(Category category) async {
    emit(GroupFeaturedCategoryLoading());
    await _databaseRepository.setGroupFeaturedCategory(
        currentGroup.groupId!, category);
    currentGroup = currentGroup.copyWith(featuredCategory: category.name);
    await Future.delayed(const Duration(seconds: 1));
    emit(GroupFeaturedCategoryUpdated());
    await Future.delayed(const Duration(seconds: 1));
    loadFeaturedCategory(currentGroup);
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
