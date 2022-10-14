import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/cubits/groups/group_featured_category_cubit.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:jiffy/jiffy.dart';

part 'featured_category_state.dart';

class FeaturedCategoryCubit extends Cubit<FeaturedCategoryState> {
  Group currentGroup = Group.empty;
  final CategoriesBloc _categoriesBloc;
  final AuthBloc _authBloc;
  final GroupFeaturedCategoryCubit _groupFeaturedCategoryCubit;

  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;
  StreamSubscription? _groupCategorySubscription;
  FeaturedCategoryCubit(
      {required DatabaseRepository databaseRepository,
      required CategoriesBloc categoriesBloc,
      required AuthBloc authBloc,
      required GroupFeaturedCategoryCubit groupFeaturedCategoryCubit})
      : _databaseRepository = databaseRepository,
        _categoriesBloc = categoriesBloc,
        _authBloc = authBloc,
        _groupFeaturedCategoryCubit = groupFeaturedCategoryCubit,
        super(FeaturedCategoryLoading()) {
    _authSubscription = _authBloc.stream.listen((event) {
      if (event.authStatus == AuthStatus.authenticated) {
        _loadUserFeaturedCategory();
      }
    });
    _groupCategorySubscription =
        _groupFeaturedCategoryCubit.stream.listen((state) {
      if (state == GroupFeaturedCategoryUpdated()) {
        _loadUserFeaturedCategory();
      }
    });
  }

  void loadUserFeaturedCategory() => _loadUserFeaturedCategory();

  void _loadUserFeaturedCategory() async {
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

    emit(FeaturedCategoryLoading());

    var groups = await _databaseRepository.getGroups();
    groups.isEmpty
        ? emit(FeaturedCategoryLoaded(
            featuredCategoryName: thisMonthsCategory,
            scheduledCategoryName: thisMonthsCategory))
        : emit(FeaturedCategoryLoaded(
            featuredCategoryName:
                await _databaseRepository.getGroupFeaturedCategory(groups[0]),
            scheduledCategoryName: thisMonthsCategory));
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _authSubscription?.cancel();
    return super.close();
  }
}
