import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/onboarding/onboarding_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfileInfo extends StatefulWidget {
  final PageController pageController;
  const ProfileInfo({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  // create some values
  // Color for the picker shown in Card on the screen.
  late Color screenPickerColor;
  // Color for the picker in a dialog using onChanged.
  late Color dialogPickerColor;
  // Color for picker using the color select dialog.
  late Color dialogSelectColor;

  final TextEditingController nameFieldController = TextEditingController();
  final TextEditingController titleFieldController = TextEditingController();
  final TextEditingController organizationFieldController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    screenPickerColor = Colors.blue; // Material blue.
    dialogPickerColor = Colors.red; // Material red.
    dialogSelectColor = const Color(0xFFA239CA); // A purple color.
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return LoadingAnimationWidget.discreteCircle(
              color: Colors.blue, size: 30);
        }
        if (state is OnboardingLoaded) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Opacity(
                  opacity: 0.05,
                  child: Image.asset(
                      'lib/assets/backgrounds/Categories_Screenshot.png')),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'You\'re Almost Done!',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'What\'s Your Name?',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      SizedBox(
                        width: 325,
                        child: BlocBuilder<OnboardingBloc, OnboardingState>(
                          builder: (context, state) {
                            if (state is OnboardingLoaded) {
                              return TextFormField(
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                controller: nameFieldController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Your Name';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    label: Text('Your Name')),
                              );
                            }
                            return const Text("Something went wrong!");
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'What\'s Your Title?',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      SizedBox(
                        width: 325,
                        child: BlocBuilder<OnboardingBloc, OnboardingState>(
                          builder: (context, state) {
                            if (state is OnboardingLoaded) {
                              return TextFormField(
                                textCapitalization: TextCapitalization.words,
                                controller: titleFieldController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Your Title';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    label: Text('Your Title'),
                                    hintText: 'Nurse, Home Attendant, Manager'),
                              );
                            }
                            return const Text("Something went wrong!");
                          },
                        ),
                      ),
                      state.user.type == 'manager'
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Where Do You Work?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                                SizedBox(
                                  width: 325,
                                  child: BlocBuilder<OnboardingBloc,
                                      OnboardingState>(
                                    builder: (context, state) {
                                      if (state is OnboardingLoaded) {
                                        return TextFormField(
                                          textCapitalization:
                                              TextCapitalization.words,
                                          controller:
                                              organizationFieldController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter an Organization';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              label: Text('Your Organization'),
                                              hintText:
                                                  'Chicago Senior Living, Oasis Care, etc..'),
                                        );
                                      }
                                      return const Text(
                                          "Something went wrong!");
                                    },
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Card(
                          child: BlocBuilder<OnboardingBloc, OnboardingState>(
                            builder: (context, state) {
                              if (state is OnboardingLoaded) {
                                return ColorPicker(
                                  color: screenPickerColor,
                                  onColorChanged: (Color selectedColor) {
                                    setState(() =>
                                        screenPickerColor = selectedColor);
                                  },
                                  borderRadius: 22,
                                  heading: Text(
                                    'Choose a Color',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  subheading: Text(
                                    'Pick a Shade',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                );
                              }
                              return const Text('Something Went Wrong..');
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        child: ListTile(
                          title: Text(
                            'Currently Selected Color:',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle:
                              const Text('Choose a color for your profile'),
                          trailing: ColorIndicator(
                            borderRadius: 22,
                            color: screenPickerColor,
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate() == true) {
                              context.read<OnboardingBloc>().add(UpdateUser(
                                  user: state.user.copyWith(
                                      name: nameFieldController.value.text,
                                      title: titleFieldController.value.text,
                                      organization: organizationFieldController
                                          .value.text,
                                      userColor: screenPickerColor.hex)));
                              context.go('/');
                            }
                          },
                          child: const Text('Finish Setup')),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('Error Loading Page!'),
          );
        }
      },
    );
  }
}
