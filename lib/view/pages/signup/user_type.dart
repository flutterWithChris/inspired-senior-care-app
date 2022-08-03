import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/onboarding/onboarding_bloc.dart';

class UserTypePage extends StatelessWidget {
  final PageController pageController;
  const UserTypePage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Opacity(
            opacity: 0.05,
            child: Image.asset(
                'lib/assets/backgrounds/Categories_Screenshot.png')),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'What are you?',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  child: BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      if (state is OnboardingLoaded) {
                        return ListTile(
                          minLeadingWidth: 30,
                          onTap: () {
                            context.read<OnboardingBloc>().add(UpdateUser(
                                user: state.user.copyWith(type: 'user')));
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          leading: const Icon(
                            Icons.person,
                            size: 28,
                          ),
                          title: const Text('Healthcare Worker'),
                          subtitle: const Text('I just want to learn!'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                        );
                      } else {
                        return const Text('Something went wrong!');
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      if (state is OnboardingLoaded) {
                        return ListTile(
                          minLeadingWidth: 30,
                          onTap: () {
                            Container();
                            context.read<OnboardingBloc>().add(UpdateUser(
                                user: state.user.copyWith(type: 'manager')));
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          leading: const Icon(
                            Icons.security,
                            size: 28,
                          ),
                          title: const Text('I\'m a Manager'),
                          subtitle: const Text(
                              'I\'d like to create groups & view others\' progress.'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                        );
                      } else {
                        return const Text('Something Went Wrong!');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
