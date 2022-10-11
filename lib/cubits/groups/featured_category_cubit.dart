import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';

import '../../data/models/category.dart';

part 'featured_category_state.dart';

class FeaturedCategoryCubit extends Cubit<FeaturedCategoryState> {
  Group currentGroup = Group.empty;
  final CategoriesBloc _categoriesBloc;
  final AuthBloc _authBloc;
  StreamSubscription? _categoriesStream;
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;
  FeaturedCategoryCubit({
    required DatabaseRepository databaseRepository,
    required CategoriesBloc categoriesBloc,
    required AuthBloc authBloc,
  })  : _databaseRepository = databaseRepository,
        _categoriesBloc = categoriesBloc,
        _authBloc = authBloc,
        super(FeaturedCategoryLoading()) {
    _authSubscription = authBloc.stream.listen((event) {
      _loadUserFeaturedCategory();
    });
    _categoriesStream = _categoriesBloc.stream.listen((state) {
      if (state is CategoriesLoaded) {}
    });
  }

  void loadFeaturedCategory(Group group) => _onLoadFeaturedCategory(group);
  void loadFeaturedCategoryById(String groupId) =>
      _onLoadFeaturedCategoryById(groupId);
  void updateFeaturedCategory(Category category) =>
      _onUpdateFeaturedCategory(category);
  void loadUserFeaturedCategory() => _loadUserFeaturedCategory();

  void _onLoadFeaturedCategory(Group group) async {
    emit(FeaturedCategoryLoading());
    await Future.delayed(const Duration(milliseconds: 250));
    currentGroup = group;
    emit(FeaturedCategoryLoaded(featuredCategoryName: group.featuredCategory!));
  }

  void _loadUserFeaturedCategory() async {
    emit(FeaturedCategoryLoading());

    var groups = await _databaseRepository.getGroups();
    groups.isEmpty
        ? emit(
            const FeaturedCategoryLoaded(featuredCategoryName: 'Communication'))
        : emit(FeaturedCategoryLoaded(
            featuredCategoryName:
                await _databaseRepository.getGroupFeaturedCategory(groups[0])));
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
    await Future.delayed(const Duration(seconds: 1));
    loadFeaturedCategory(currentGroup);
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _categoriesStream?.cancel();
    _authSubscription?.cancel();
    return super.close();
  }
}
