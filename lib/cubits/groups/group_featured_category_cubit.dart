import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:jiffy/jiffy.dart';

part 'group_featured_category_state.dart';

class GroupFeaturedCategoryCubit extends Cubit<GroupFeaturedCategoryState> {
  Group currentGroup = Group.empty;
  final DatabaseRepository _databaseRepository;

  GroupFeaturedCategoryCubit({
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository,
        super(GroupFeaturedCategoryLoading());

  void loadFeaturedCategory(Group group) => _onLoadFeaturedCategory(group);
  void loadFeaturedCategoryById(String groupId) =>
      _onLoadFeaturedCategoryById(groupId);
  void updateFeaturedCategory(String categoryName, String groupId) =>
      _onUpdateFeaturedCategory(categoryName, groupId);

  void _onLoadFeaturedCategory(Group group) async {
    Map<int, String> monthlyCategories = {
      1: 'Genuine Relationships',
      2: 'Brain Change',
      3: 'What If',
      4: 'Supportive Environment',
      5: 'Language Matters',
      6: 'Well Being',
      7: 'Meaningful Engagement',
      8: 'Communication',
      9: 'Damaging Interactions',
      10: 'Positive Interactions',
      11: 'Wildly Curious',
      12: 'Strengths Based'
    };
    int month = Jiffy().month;
    String thisMonthsCategory = monthlyCategories[month]!;

    emit(GroupFeaturedCategoryLoading());
    await Future.delayed(const Duration(milliseconds: 250));
    currentGroup = group;
    if (group.onSchedule == true) {
      if (group.featuredCategory! != thisMonthsCategory) {
        updateFeaturedCategory(thisMonthsCategory, group.groupId!);
        _databaseRepository.setGroupFeaturedCategory(
            group.groupId!, thisMonthsCategory);
      }
    }
    emit(GroupFeaturedCategoryLoaded(
        featuredCategoryName: group.onSchedule == true
            ? thisMonthsCategory
            : group.featuredCategory!,
        suggestedCategory: thisMonthsCategory));
  }

  void _onLoadFeaturedCategoryById(String groupId) async {
    emit(GroupFeaturedCategoryLoading());
    await Future.delayed(const Duration(seconds: 1));
    Map<int, String> monthlyCategories = {
      1: 'Genuine Relationships',
      2: 'Brain Change',
      3: 'What If',
      4: 'Supportive Environment',
      5: 'Language Matters',
      6: 'Well Being',
      7: 'Meaningful Engagement',
      8: 'Communication',
      9: 'Damaging Interactions',
      10: 'Positive Interactions',
      11: 'Wildly Curious',
      12: 'Strengths Based'
    };
    int month = Jiffy().month;
    String thisMonthsCategory = monthlyCategories[month]!;

    _databaseRepository.getGroup(groupId).listen((group) {
      currentGroup = group;
    }).onData((data) {
      emit(GroupFeaturedCategoryLoaded(
          featuredCategoryName: data.featuredCategory!,
          suggestedCategory: thisMonthsCategory));
    });
  }

  void _onUpdateFeaturedCategory(String categoryName, String groupId) async {
    emit(GroupFeaturedCategoryLoading());
    await _databaseRepository.setGroupFeaturedCategory(groupId, categoryName);
    currentGroup = currentGroup.copyWith(featuredCategory: categoryName);
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
