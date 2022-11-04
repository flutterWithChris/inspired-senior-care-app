import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/bloc/group_member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/cubits/groups/featured_category_cubit.dart';
import 'package:inspired_senior_care_app/cubits/groups/group_featured_category_cubit.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/globals.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/groups/create_group.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/groups/delete_group_dialog.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/groups/edit_group.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/members/add_manager.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/members/add_member.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/main_app_drawer.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/name_plate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController inviteTextFieldController = TextEditingController();
  List<Group> myGroupList = [];
  User currentUser = User.empty;
  final GlobalKey groupSectionShowcaseKey = GlobalKey();

  BuildContext? showcaseBuildContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
        future: checkSpotlightStatus('dashboardSpotlightDone'),
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (snapshot.connectionState == ConnectionState.done &&
              (data == null || data == false)) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ShowCaseWidget.of(showcaseBuildContext!)
                  .startShowCase([groupSectionShowcaseKey]);
            });
          }
          return ShowCaseWidget(onFinish: () async {
            await setSpotlightStatusToComplete('dashboardSpotlightDone');
          }, builder: Builder(
            builder: (context) {
              showcaseBuildContext = context;
              return Scaffold(
                drawer: const MainAppDrawer(),
                bottomNavigationBar: const MainBottomAppBar(),
                appBar: const PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: MainTopAppBar(),
                ),
                // * Main Content
                body: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is ProfileLoaded) {
                      currentUser = state.user;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            // * Name Plate
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: NamePlate(
                                user: currentUser,
                                memberName: currentUser.name!,
                                memberTitle: currentUser.title!,
                                memberColorHex: currentUser.userColor!,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 6.0,
                                    bottom: 24.0,
                                    left: 12.0,
                                    right: 12.0),
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Wrap(
                                          spacing: 12.0,
                                          runAlignment: WrapAlignment.center,
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(
                                              Icons.group,
                                              color: Colors.black87,
                                            ),
                                            Text(
                                              'My Groups',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // * Groups Section
                                  BlocBuilder<GroupBloc, GroupState>(
                                    // * Rebuild when groups updated.
                                    builder: (context, state) {
                                      if (state is GroupLoading ||
                                          state is GroupUpdated ||
                                          state is GroupCreated ||
                                          state is GroupDeleted) {
                                        return Center(
                                          child: LoadingAnimationWidget.inkDrop(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 25),
                                        );
                                      }
                                      if (state is GroupLoaded) {
                                        if (state.myGroups.isEmpty) {
                                          return Center(
                                            child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            33)),
                                                child: SizedBox(
                                                    width: 325,
                                                    height: 150,
                                                    child: Center(
                                                        child: Wrap(
                                                      direction: Axis.vertical,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      spacing: 8.0,
                                                      children: [
                                                        Text(
                                                          'No Groups Yet!',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleLarge!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        ElevatedButton.icon(
                                                            onPressed: () =>
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return CreateGroupDialog(
                                                                        manager:
                                                                            currentUser,
                                                                      );
                                                                    }),
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    fixedSize:
                                                                        const Size(
                                                                            140,
                                                                            32)),
                                                            icon: const Icon(
                                                              Icons.add_circle,
                                                              size: 18,
                                                            ),
                                                            label: const Text(
                                                                'New Group'))
                                                      ],
                                                    )))),
                                          );
                                        } else {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // * Build groups
                                              for (Group group
                                                  in state.myGroups)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: GroupSection(
                                                      group: group,
                                                      manager: currentUser,
                                                      groupName:
                                                          group.groupName!,
                                                      sampleGroupList:
                                                          state.myGroups,
                                                      inviteTextFieldController:
                                                          inviteTextFieldController),
                                                ),
                                            ],
                                          );
                                        }
                                      } else {
                                        return const Center(
                                          child: Text('Something Went Wrong!'),
                                        );
                                      }
                                    },
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                // * FAB
                floatingActionButton: Showcase(
                  key: groupSectionShowcaseKey,
                  targetBorderRadius:
                      const BorderRadius.all(Radius.circular(50.0)),
                  descriptionAlignment: TextAlign.center,
                  targetPadding: const EdgeInsets.all(12.0),
                  description:
                      'Create groups &  invite members to join using their email address. *Must sign up on app first.* \n\n See their progress and congratulate them when you see they have earned awards!',
                  child: SpeedDial(
                    overlayColor: Colors.black,
                    spacing: 12.0,
                    backgroundColor: Colors.lightGreen,
                    children: [
                      SpeedDialChild(
                        label: 'Create a Group',
                        child: const Icon(Icons.group_add),
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return CreateGroupDialog(
                                manager: currentUser,
                              );
                            }),
                      ),
                    ],
                    child: const Icon(Icons.add),
                  ),
                ),
              );
            },
          ));
        });
  }
}

class GroupSection extends StatefulWidget {
  final Group group;
  final User manager;
  final String groupName;
  const GroupSection({
    required this.group,
    required this.manager,
    required this.groupName,
    Key? key,
    required this.sampleGroupList,
    required this.inviteTextFieldController,
  }) : super(key: key);

  final List<Group> sampleGroupList;
  final TextEditingController inviteTextFieldController;

  @override
  State<GroupSection> createState() => _GroupSectionState();
}

class _GroupSectionState extends State<GroupSection> {
  final GlobalKey addButtonShowcase = GlobalKey();
  final GlobalKey editButtonShowcase = GlobalKey();
  final GlobalKey chooseCategoryShowcase = GlobalKey();
  final GlobalKey viewGroupMembersButtonShowcase = GlobalKey();

  BuildContext? showcaseBuildContext;

  @override
  Widget build(BuildContext context) {
    final Group currentGroup = widget.group;
    final currentUser = widget.manager;
    return FutureBuilder<bool?>(
        future: checkSpotlightStatus('groupFeatureShowcaseDone'),
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (snapshot.connectionState == ConnectionState.done &&
              (data == null || data == false)) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ShowCaseWidget.of(showcaseBuildContext!).startShowCase([
                addButtonShowcase,
                editButtonShowcase,
                chooseCategoryShowcase,
                viewGroupMembersButtonShowcase
              ]);
            });
          }
          return ShowCaseWidget(
            onFinish: () async {
              await setSpotlightStatusToComplete('groupFeatureShowcaseDone');
            },
            builder: Builder(
              builder: (context) {
                showcaseBuildContext = context;
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12.0),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: FittedBox(
                                  child: Text(
                                    currentGroup.groupName!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .color),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 2.0,
                                children: [
                                  Showcase(
                                    targetPadding: const EdgeInsets.all(4.0),
                                    targetBorderRadius:
                                        BorderRadius.circular(50),
                                    key: addButtonShowcase,
                                    description:
                                        'Add group members & managers.',
                                    child: PopupMenuButton(
                                      position: PopupMenuPosition.under,
                                      itemBuilder: (context) =>
                                          <PopupMenuEntry>[
                                        PopupMenuItem(
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(seconds: 0),
                                                  () => showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AddMemberDialog(
                                                                group: widget
                                                                    .group,
                                                                inviteTextFieldController:
                                                                    widget
                                                                        .inviteTextFieldController),
                                                      ));
                                            },
                                            child: Wrap(
                                              spacing: 6.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.group_add_rounded,
                                                  size: 18,
                                                ),
                                                Text('Add Member'),
                                              ],
                                            )),
                                        PopupMenuItem(
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(seconds: 0),
                                                  () => showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AddManagerDialog(
                                                                group: widget
                                                                    .group,
                                                                inviteTextFieldController:
                                                                    widget
                                                                        .inviteTextFieldController),
                                                      ));
                                            },
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 8.0,
                                              children: const [
                                                Icon(
                                                  Icons.add_moderator_rounded,
                                                  size: 18,
                                                ),
                                                Text('Add Manager'),
                                              ],
                                            )),
                                      ],
                                      child: const Icon(
                                        Icons.add_circle_rounded,
                                        color: Colors.lightGreen,
                                      ),
                                    ),
                                  ),
                                  Showcase(
                                    targetPadding: const EdgeInsets.all(-8.0),
                                    targetBorderRadius:
                                        BorderRadius.circular(50),
                                    key: editButtonShowcase,
                                    description: 'Edit group details.',
                                    child: PopupMenuButton(
                                      position: PopupMenuPosition.under,
                                      itemBuilder: (context) =>
                                          <PopupMenuEntry>[
                                        PopupMenuItem(
                                            onTap: () {
                                              Future.delayed(
                                                const Duration(seconds: 0),
                                                () => showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        EditGroupDialog(
                                                            currentUser:
                                                                currentUser,
                                                            currentGroup:
                                                                currentGroup)),
                                              );
                                            },
                                            child: Wrap(
                                              spacing: 8.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.edit,
                                                  size: 18,
                                                ),
                                                Text('Rename'),
                                              ],
                                            )),
                                        PopupMenuItem(
                                            onTap: () {
                                              Future.delayed(
                                                const Duration(seconds: 0),
                                                () => showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        DeleteGroupDialog(
                                                            currentUser:
                                                                currentUser,
                                                            currentGroup:
                                                                currentGroup)),
                                              );
                                            },
                                            child: Wrap(
                                              spacing: 8.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.delete_forever_rounded,
                                                  size: 18,
                                                ),
                                                Text('Delete Group'),
                                              ],
                                            )),
                                        PopupMenuItem(
                                            onTap: () {
                                              context
                                                  .read<GroupMemberBloc>()
                                                  .add(LoadGroupMembers(
                                                      userIds: widget.group
                                                          .groupMemberIds!,
                                                      group: currentGroup));
                                              context.pushNamed(
                                                  'view-group-members');
                                            },
                                            child: Wrap(
                                              spacing: 8.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.group,
                                                  size: 18,
                                                ),
                                                Text('Edit Members'),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Showcase(
                        targetBorderRadius: BorderRadius.circular(20.0),
                        targetPadding: const EdgeInsets.all(12.0),
                        key: chooseCategoryShowcase,
                        description:
                            'Change the monthly category for your group!',
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8.0, left: 16.0),
                              child: SizedBox(
                                  width: 300,
                                  child: Text(
                                    'Featured Category',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(color: Colors.black87),
                                  )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CurrentCategoryCard(
                                  group: currentGroup, user: widget.manager),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: BlocBuilder<GroupBloc, GroupState>(
                          builder: (context, state) {
                            if (state is GroupLoading) {
                              return Center(
                                child: LoadingAnimationWidget.inkDrop(
                                    color: Colors.blue, size: 30),
                              );
                            }
                            if (state is GroupLoaded) {
                              return Showcase(
                                targetBorderRadius: BorderRadius.circular(50.0),
                                targetPadding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                key: viewGroupMembersButtonShowcase,
                                description:
                                    'View/Edit group members & their progress!',
                                child: ElevatedButton(
                                    onPressed: () {
                                      context.read<GroupMemberBloc>().add(
                                          LoadGroupMembers(
                                              userIds:
                                                  widget.group.groupMemberIds!,
                                              group: currentGroup));
                                      context.goNamed('view-group-members');
                                    },
                                    child: const Text('View Group Members')),
                              );
                            }
                            return const Text('Something Went Wrong!');
                          },
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
          );
        });
  }
}

class CurrentCategoryCard extends StatelessWidget {
  final Group group;
  final User user;
  const CurrentCategoryCard({
    required this.group,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return LoadingAnimationWidget.fourRotatingDots(
              color: Colors.blue, size: 30);
        }
        if (state is CategoriesFailed) {
          return const Center(
            child: Text('Error Fetching Categories...'),
          );
        }
        if (state is CategoriesLoaded) {
          Category currentCategory = state.categories.singleWhere(
            (category) => category.name == group.featuredCategory,
          );
          return BlocBuilder<FeaturedCategoryCubit, FeaturedCategoryState>(
            builder: (context, state) {
              if (state is FeaturedCategoryLoading ||
                  state is FeaturedCategoryUpdated) {
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.blue, size: 20),
                );
              }

              if (state is FeaturedCategoryFailed) {
                return const Center(
                  child: Text('Error Fetching Category!'),
                );
              }
              if (state is FeaturedCategoryLoaded) {
                return ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 100, minHeight: 60),
                  child: InkWell(
                    onTap: () {
                      context
                          .read<GroupFeaturedCategoryCubit>()
                          .loadFeaturedCategory(group);

                      context.goNamed('choose-category');
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: currentCategory.categoryColor
                                  .withOpacity(0.8),
                              width: 1.618),
                          borderRadius: BorderRadius.circular(12.0)),
                      elevation: 1.0,
                      child: SizedBox(
                        width: 325,
                        //height: 100,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: currentCategory.coverImageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            group.featuredCategory!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 12.0),
                                          child:
                                              Icon(Icons.chevron_right_rounded),
                                        ),
                                      ],
                                    ),
                                  ),
                                  group.onSchedule == true
                                      ? Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              spacing: 6.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: const [
                                                Icon(
                                                  FontAwesomeIcons
                                                      .solidCalendarCheck,
                                                  size: 12.0,
                                                  color: Colors.blue,
                                                ),
                                                Text('On Schedule'),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                top: 4.0,
                                                right: 4.0),
                                            child: Text(
                                              currentCategory.description,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const Center(
                child: Text('Something Went Wrong!'),
              );
            },
          );
        }
        return const Center(
          child: Text('Something Went Wrong...'),
        );
      },
    );
  }
}
