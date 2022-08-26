import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';

import '../../data/models/category.dart';

part 'featured_category_state.dart';

class FeaturedCategoryCubit extends Cubit<FeaturedCategoryState> {
  Group currentGroup = Group.empty;
  final CategoriesBloc _categoriesBloc;
  StreamSubscription? _categoriesStream;
  final DatabaseRepository _databaseRepository;
  FeaturedCategoryCubit({
    required DatabaseRepository databaseRepository,
    required CategoriesBloc categoriesBloc,
  })  : _databaseRepository = databaseRepository,
        _categoriesBloc = categoriesBloc,
        super(FeaturedCategoryLoading()) {
    _categoriesStream = _categoriesBloc.stream.listen((state) {
      if (state is CategoriesLoaded) {}
    });
  }

  void loadFeaturedCategory(Group group) => _onLoadFeaturedCategory(group);
  void loadFeaturedCategoryById(String groupId) =>
      _onLoadFeaturedCategoryById(groupId);
  void updateFeaturedCategory(Category category) =>
      _onUpdateFeaturedCategory(category);
  void loadUserFeaturedCategory(User user) => _loadUserFeaturedCategory(user);

  void _onLoadFeaturedCategory(Group group) async {
    emit(FeaturedCategoryLoading());
    await Future.delayed(const Duration(seconds: 1));
    currentGroup = group;
    emit(FeaturedCategoryLoaded(featuredCategoryName: group.featuredCategory!));
  }

  void _loadUserFeaturedCategory(User user) async {
    emit(FeaturedCategoryLoading());

    user.groups == null || user.groups!.isEmpty == true
        ? emit(
            const FeaturedCategoryLoaded(featuredCategoryName: 'Communication'))
        : _databaseRepository.getGroup(user.groups![0]).listen((group) {
            currentGroup = group;
          }).onData((group) {
            emit(FeaturedCategoryLoaded(
                featuredCategoryName: group.featuredCategory!));
          });
  }

  void _onLoadFeaturedCategoryById(String groupId) async {
    emit(FeaturedCategoryLoading());
    await Future.delayed(const Duration(seconds: 1));

    _databaseRepository.getGroup(groupId).listen((group) {
      currentGroup = group;
    }).onData((data) {
      emit(
          FeaturedCategoryLoaded(featuredCategoryName: data.featuredCategory!));
    });
  }

  void _onUpdateFeaturedCategory(Category category) async {
    emit(FeaturedCategoryLoading());
    await _databaseRepository.setGroupFeaturedCategory(
        currentGroup.groupId!, category);
    currentGroup = currentGroup.copyWith(featuredCategory: category.name);
    await Future.delayed(const Duration(seconds: 1));
    emit(FeaturedCategoryUpdated());
    await Future.delayed(const Duration(seconds: 5));
    //loadFeaturedCategory(currentGroup);
  }
}
