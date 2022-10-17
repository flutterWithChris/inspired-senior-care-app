import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/cubits/settings/cubit/settings_cubit.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: MainTopAppBar(
            title: 'Settings',
          )),
      bottomNavigationBar: const MainBottomAppBar(),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return LoadingAnimationWidget.fourRotatingDots(
                color: Colors.blue, size: 30);
          }
          if (state is ProfileLoaded) {
            User currentUser = state.user;
            return SettingsList(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
              sections: [
                SettingsSection(
                  //margin: const EdgeInsetsDirectional.all(12.0),
                  title: const Text('Account'),
                  tiles: [
                    SettingsTile.navigation(
                      title: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text('Email'),
                      ),
                      value: FittedBox(child: Text(currentUser.email!)),
                      leading: const Icon(Icons.email_rounded),
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const ChangeEmailDialog();
                          },
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      title: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text('Name'),
                      ),
                      value: FittedBox(child: Text(currentUser.name!)),
                      leading: const Icon(Icons.person),
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const ChangeNameDialog();
                          },
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      title: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text('Title'),
                      ),
                      value: FittedBox(
                        child: Text(currentUser.title!),
                      ),
                      leading: const Icon(Icons.badge),
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const ChangeTitleDialog();
                          },
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      title: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text('Organization'),
                      ),
                      value: FittedBox(child: Text(currentUser.organization!)),
                      leading: const Icon(Icons.work_rounded),
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const ChangeOrganizationDialog();
                          },
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      title: const Text('Password'),
                      leading: const Icon(Icons.lock_rounded),
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const ChangePasswordDialog();
                          },
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      title: const Text('Sign Out'),
                      leading: const Icon(Icons.logout_rounded),
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Sign Out?'),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      title: const Text('Delete Account'),
                      leading: const Icon(Icons.delete_forever_rounded),
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Delete Account?'),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: const Text('Help & Support'),
                  tiles: [
                    SettingsTile.navigation(
                      title: const Text('Report an Issue / Bug'),
                      leading: const Icon(Icons.report),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Text('Something Went Wrong');
          }
        },
      ),
    );
  }
}

class ChangeEmailDialog extends StatefulWidget {
  const ChangeEmailDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  final TextEditingController emailFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<ProfileBloc>().state.user;
    emailFieldController.text = currentUser.email!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
        child: SizedBox(
          height: 175,
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Edit Email',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextFormField(
                controller: emailFieldController,
                decoration: const InputDecoration(label: Text('Your Email')),
              ),
              ElevatedButton(
                  onPressed: () {
                    context.read<ProfileBloc>().add(UpdateProfile(
                        user: currentUser.copyWith(
                            email: emailFieldController.value.text)));
                  },
                  child: const Text('Update Email'))
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeNameDialog extends StatefulWidget {
  const ChangeNameDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  final TextEditingController nameFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<ProfileBloc>().state.user;
    nameFieldController.text = currentUser.name!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
        child: SizedBox(
          height: 175,
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Edit Name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextFormField(
                controller: nameFieldController,
                decoration: const InputDecoration(label: Text('Your Name')),
              ),
              ElevatedButton(onPressed: () {
                context.read<ProfileBloc>().add(UpdateProfile(
                    user: currentUser.copyWith(
                        name: nameFieldController.value.text)));
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              }, child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return LoadingAnimationWidget.bouncingBall(
                        color: Colors.white, size: 18);
                  }
                  if (state is ProfileUpdated) {
                    return const Text('Name Updated!');
                  }
                  return const Text('Update Name');
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeTitleDialog extends StatefulWidget {
  const ChangeTitleDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeTitleDialog> createState() => _ChangeTitleDialogState();
}

class _ChangeTitleDialogState extends State<ChangeTitleDialog> {
  final TextEditingController titleFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<ProfileBloc>().state.user;
    titleFieldController.text = currentUser.title!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
        child: SizedBox(
          height: 175,
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Edit Title',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextFormField(
                controller: titleFieldController,
                decoration: const InputDecoration(label: Text('Your Name')),
              ),
              ElevatedButton(onPressed: () {
                context.read<ProfileBloc>().add(UpdateProfile(
                    user: currentUser.copyWith(
                        title: titleFieldController.value.text)));
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              }, child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return LoadingAnimationWidget.bouncingBall(
                        color: Colors.white, size: 18);
                  }
                  if (state is ProfileUpdated) {
                    return const Text('Title Updated!');
                  }
                  return const Text('Update Title');
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeOrganizationDialog extends StatefulWidget {
  const ChangeOrganizationDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeOrganizationDialog> createState() =>
      _ChangeOrganizationDialogState();
}

class _ChangeOrganizationDialogState extends State<ChangeOrganizationDialog> {
  final TextEditingController nameFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<ProfileBloc>().state.user;
    nameFieldController.text = currentUser.name!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
        child: SizedBox(
          height: 175,
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Edit Name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextFormField(
                controller: nameFieldController,
                decoration: const InputDecoration(label: Text('Your Name')),
              ),
              ElevatedButton(onPressed: () {
                context.read<ProfileBloc>().add(UpdateProfile(
                    user: currentUser.copyWith(
                        name: nameFieldController.value.text)));
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              }, child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return LoadingAnimationWidget.bouncingBall(
                        color: Colors.white, size: 18);
                  }
                  if (state is ProfileUpdated) {
                    return const Text('Name Updated!');
                  }
                  return const Text('Update Name');
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordDialog extends StatelessWidget {
  const ChangePasswordDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: SizedBox(
          height: 175,
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Edit Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Text(
                'To reset your password you\'ll need to request a password reset email.',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                  onPressed: () {
                    context.read<EditPassCubit>().passwordResetRequest(
                        context.read<ProfileBloc>().state.user.email!);
                  },
                  child: const Text('Request Password Reset'))
            ],
          ),
        ),
      ),
    );
  }
}
