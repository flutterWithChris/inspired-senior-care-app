import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/cubits/groups/group_featured_category_cubit.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/globals.dart';

import '../../bloc/profile/profile_bloc.dart';

part 'featured_category_state.dart';

class FeaturedCategoryCubit extends Cubit<FeaturedCategoryState> {
  String? currentGroupId;
  final CategoriesBloc _categoriesBloc;
  final AuthBloc _authBloc;
  final GroupFeaturedCategoryCubit _groupFeaturedCategoryCubit;
  final ProfileBloc _profileBloc;
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;
  StreamSubscription? _groupCategorySubscription;
  FeaturedCategoryCubit(
      {required DatabaseRepository databaseRepository,
      required CategoriesBloc categoriesBloc,
      required AuthBloc authBloc,
      required ProfileBloc profileBloc,
      required GroupFeaturedCategoryCubit groupFeaturedCategoryCubit})
      : _databaseRepository = databaseRepository,
        _categoriesBloc = categoriesBloc,
        _authBloc = authBloc,
        _groupFeaturedCategoryCubit = groupFeaturedCategoryCubit,
        _profileBloc = profileBloc,
        super(FeaturedCategoryLoading()) {
    _authSubscription = _authBloc.stream.listen((event) {
      if (event.authStatus == AuthStatus.authenticated) {
        _loadUserFeaturedCategory();
      }
    });
    // _groupCategorySubscription =
    //     _groupFeaturedCategoryCubit.stream.listen((state) {
    //   if (state == GroupFeaturedCategoryUpdated()) {
    //     _loadUserFeaturedCategory();
    //   }
    // });
    _profileBloc.stream.listen((state) {
      if (state is ProfileLoaded && state.user.groups != null) {
        _groupCategorySubscription = _databaseRepository
            .getGroupFeaturedCategoryStream(state.user.groups![0])
            .listen((event) async {
          await Future.delayed(const Duration(seconds: 2));
          _loadUserFeaturedCategory();
        });
      }
    });
  }

  void loadUserFeaturedCategory() => _loadUserFeaturedCategory();

  void _loadUserFeaturedCategory() async {
    emit(FeaturedCategoryLoading());

    var groups = await _databaseRepository.getGroups();
    var groupScheduleStatus =
        await _databaseRepository.getGroupScheduleStatus(groups[0]);

    if (groups.isNotEmpty) {
      currentGroupId = groups[0];
    }
    groups.isEmpty
        ? emit(FeaturedCategoryLoaded(
            featuredCategoryName: thisMonthsCategory,
            scheduledCategoryName: thisMonthsCategory))
        : emit(FeaturedCategoryLoaded(
            featuredCategoryName: groupScheduleStatus == true
                ? thisMonthsCategory
                : await _databaseRepository.getGroupFeaturedCategory(groups[0]),
            scheduledCategoryName: thisMonthsCategory));
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _authSubscription?.cancel();
    _groupCategorySubscription?.cancel();
    return super.close();
  }
}
