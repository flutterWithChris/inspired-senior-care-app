import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/bloc/group_member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/cubits/groups/featured_category_cubit.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/main.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/add_member.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/create_group.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/name_plate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController inviteTextFieldController = TextEditingController();
  List<Group> myGroupList = [];
  User currentUser = User.empty;
  static List<Group> sampleGroupList = [
    const Group(
        groupName: 'Cleveland Senior Care',
        groupId: '5167',
        groupMemberIds: [''],
        groupManagerIds: ['']),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const MainAppDrawer(),
        bottomNavigationBar: const MainBottomAppBar(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(title: const Text('Inspired Senior Care')),
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
              context
                  .watch<GroupBloc>()
                  .add(LoadGroups(currentUser: currentUser));
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // * Name Plate
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: NamePlate(
                        memberName: currentUser.name!,
                        memberTitle: currentUser.title!,
                        memberColorHex: currentUser.userColor!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 6.0, bottom: 24.0, left: 12.0, right: 12.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Wrap(
                                  spacing: 12.0,
                                  runAlignment: WrapAlignment.center,
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.group,
                                      color: Colors.black87,
                                    ),
                                    Text(
                                      'My Groups',
                                      style:
                                          Theme.of(context).textTheme.headline5,
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
                              if (state is GroupLoading) {
                                return Center(
                                  child:
                                      LoadingAnimationWidget.fourRotatingDots(
                                          color: Colors.blue, size: 25),
                                );
                              }
                              if (state is GroupLoaded) {
                                if (state.myGroups.isEmpty) {
                                  return Center(
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(33)),
                                        child: SizedBox(
                                            width: 325,
                                            height: 150,
                                            child: Center(
                                                child: Wrap(
                                              direction: Axis.vertical,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 8.0,
                                              children: [
                                                Text(
                                                  'No Groups Yet!',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                          color: Colors.grey),
                                                ),
                                                ElevatedButton.icon(
                                                    onPressed: () => showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CreateGroupDialog(
                                                            manager:
                                                                currentUser,
                                                          );
                                                        }),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            fixedSize:
                                                                const Size(
                                                                    140, 32)),
                                                    icon: const Icon(
                                                      Icons.add_circle,
                                                      size: 18,
                                                    ),
                                                    label:
                                                        const Text('New Group'))
                                              ],
                                            )))),
                                  );
                                } else {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // * Build groups
                                      for (Group group in state.myGroups)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: GroupSection(
                                              group: group,
                                              manager: currentUser,
                                              groupName: group.groupName!,
                                              sampleGroupList: state.myGroups,
                                              inviteTextFieldController:
                                                  inviteTextFieldController),
                                        ),
                                      // TODO: Handle No Groups Created State
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
        floatingActionButton: SpeedDial(
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Group currentGroup = widget.group;
    final currentUser = widget.manager;
    context.read<FeaturedCategoryCubit>().loadFeaturedCategory(currentGroup);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              currentGroup.groupName!,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Wrap(
            runAlignment: WrapAlignment.end,
            alignment: WrapAlignment.end,
            spacing: 8.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(140, 30),
                    primary: Colors.lightGreen,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AddMemberDialog(
                            group: widget.group,
                            inviteTextFieldController:
                                widget.inviteTextFieldController));
                  },
                  icon: const Icon(
                    Icons.add_circle_rounded,
                    size: 18,
                  ),
                  label: const Text(
                    'Add Member',
                  )),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(140, 30),
                  ),
                  onPressed: () {
                    print(currentUser.name);
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 18,
                  ),
                  label: const Text(
                    'Edit Group',
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: SizedBox(
                width: 300,
                child: Text(
                  'Featured Category',
                  style: Theme.of(context).textTheme.titleLarge,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child:
                CurrentCategoryCard(group: currentGroup, user: widget.manager),
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
                  return ElevatedButton(
                      onPressed: () {
                        context.read<GroupMemberBloc>().add(LoadGroupMembers(
                            userIds: widget.group.groupMemberIds!,
                            group: currentGroup));
                        context.goNamed('view-group-members');
                      },
                      child: const Text('View Group Members'));
                  print('Current Group Is: ${widget.group.groupName}');
                }
                return const Text('Something Went Wrong!');
              },
            ),
          ),
        ]),
      ),
    );
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
                return Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: currentCategory.categoryColor.withOpacity(0.8),
                          width: 1.618),
                      borderRadius: BorderRadius.circular(12.0)),
                  elevation: 1.0,
                  child: SizedBox(
                    width: 325,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10.0),
                      child: ListTile(
                        minLeadingWidth: 40,
                        // dense: true,
                        onTap: () {
                          context
                              .read<FeaturedCategoryCubit>()
                              .loadFeaturedCategory(group);

                          context.goNamed('choose-category');
                        },

                        title: Text(
                          group.featuredCategory!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        //  subtitle: const Text('Creating a healthy environment.'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        leading: SizedBox(
                          height: 50,
                          width: 40,
                          child: CachedNetworkImage(
                            imageUrl: currentCategory.coverImageUrl,
                            fit: BoxFit.fitHeight,
                          ),
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
