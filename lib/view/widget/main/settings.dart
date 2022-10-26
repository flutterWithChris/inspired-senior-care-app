import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/cubits/settings/cubit/settings_cubit.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../bloc/auth/auth_bloc.dart';

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
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading || state is SettingsUpdated) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.blue, size: 30),
            );
          }
          if (state is SettingsLoaded) {
            User currentUser = context.watch<ProfileBloc>().state.user;
            List<AbstractSettingsTile> mainSettingsTiles = [
              SettingsTile.navigation(
                title: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text('Email'),
                ),
                value: Text(currentUser.email!),
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
                value: Text(currentUser.name!),
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
                value: Text(currentUser.title!),
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
                  context.read<AuthBloc>().add(AppLogoutRequested());
                },
              ),
              SettingsTile.navigation(
                title: const Text('Delete Account'),
                leading: const Icon(Icons.delete_forever_rounded),
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const DeleteAccountDialog();
                    },
                  );
                },
              ),
            ];
            if (currentUser.type == 'manager') {
              mainSettingsTiles.insert(
                  3,
                  SettingsTile.navigation(
                    title: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text('Organization'),
                    ),
                    value: Text(currentUser.organization ?? 'nope'),
                    leading: const Icon(Icons.work_rounded),
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const ChangeOrganizationDialog();
                        },
                      );
                    },
                  ));
            }
            return SettingsList(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
              sections: [
                SettingsSection(
                  //margin: const EdgeInsetsDirectional.all(12.0),
                  title: const Text('Account'),
                  tiles: mainSettingsTiles,
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

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController deleteFieldController = TextEditingController();
  final GlobalKey<FormState> deleteFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<ProfileBloc>().state.user;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
        child: SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Delete Account Forever?',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
                child: Text.rich(
                  const TextSpan(children: [
                    TextSpan(
                      text:
                          'Are you sure you\'d like to delete your account forever?',
                    ),
                    TextSpan(
                        text: ' This cannot be undone.',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                key: deleteFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != currentUser.name) {
                    if (value == '' || value == null) {
                      return 'Please enter your name!';
                    }
                    return 'Name doesn\'t match!';
                  }
                  return null;
                },
                autofocus: true,
                controller: deleteFieldController,
                decoration:
                    InputDecoration(hintText: 'Type "${currentUser.name!}"'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: () {
                      //deleteFormKey.currentState!.validate();
                      if (!deleteFormKey.currentState!.validate()) {
                        print('invalid delete');
                      } else {
                        context.read<SettingsCubit>().deleteAccount();

                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.pop(context);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.delete_forever_rounded,
                      size: 20,
                    ),
                    label: BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        if (state is SettingsLoading) {
                          return LoadingAnimationWidget.bouncingBall(
                              color: Colors.white, size: 18);
                        }
                        if (state is SettingsUpdated) {
                          return const Text('Account Deleted!');
                        }
                        return const Text('Delete Account');
                      },
                    )),
              )
            ],
          ),
        ),
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
                keyboardType: TextInputType.emailAddress,
                controller: emailFieldController,
                decoration: const InputDecoration(label: Text('Your Email')),
              ),
              ElevatedButton(onPressed: () {
                context
                    .read<SettingsCubit>()
                    .changeEmail(emailFieldController.value.text);
                // context.read<SettingsCubit>().add(UpdateProfile(
                //     user: currentUser.copyWith(
                //         email: emailFieldController.value.text)));
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              }, child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsLoading) {
                    return LoadingAnimationWidget.bouncingBall(
                        color: Colors.white, size: 18);
                  }
                  if (state is SettingsUpdated) {
                    return const Text('Email Updated!');
                  }
                  return const Text('Update Email');
                },
              ))
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
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                controller: nameFieldController,
                decoration: const InputDecoration(label: Text('Your Name')),
              ),
              ElevatedButton(onPressed: () {
                context
                    .read<SettingsCubit>()
                    .changeName(nameFieldController.value.text);
                // context.read<SettingsCubit>().add(UpdateProfile(
                //     user: currentUser.copyWith(
                //         name: nameFieldController.value.text)));
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              }, child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsLoading) {
                    return LoadingAnimationWidget.bouncingBall(
                        color: Colors.white, size: 18);
                  }
                  if (state is SettingsUpdated) {
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
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                controller: titleFieldController,
                decoration: const InputDecoration(label: Text('Your Title')),
              ),
              ElevatedButton(onPressed: () {
                context
                    .read<SettingsCubit>()
                    .changeTitle(titleFieldController.value.text);
                // .add(UpdateProfile(
                //     user: currentUser.copyWith(
                //         title: titleFieldController.value.text)));
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              }, child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsLoading) {
                    return LoadingAnimationWidget.bouncingBall(
                        color: Colors.white, size: 18);
                  }
                  if (state is SettingsUpdated) {
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
  final TextEditingController organizationFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<ProfileBloc>().state.user;
    organizationFieldController.text = currentUser.organization!;
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
                  'Edit Organization',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                controller: organizationFieldController,
                decoration:
                    const InputDecoration(label: Text('Your Organization')),
              ),
              ElevatedButton(onPressed: () {
                context
                    .read<SettingsCubit>()
                    .changeOrganization(organizationFieldController.value.text);
                // context.read<SettingsCubit>().add(UpdateProfile(
                //     user: currentUser.copyWith(
                //         name: organizationFieldController.value.text)));
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              }, child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsLoading) {
                    return LoadingAnimationWidget.bouncingBall(
                        color: Colors.white, size: 18);
                  }
                  if (state is SettingsUpdated) {
                    return const Text('Organization Updated!');
                  }
                  return const Text('Update Organization');
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                    context.read<SettingsCubit>().passwordResetRequest(
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
