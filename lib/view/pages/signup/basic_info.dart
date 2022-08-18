import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:inspired_senior_care_app/bloc/onboarding/onboarding_bloc.dart';
import 'package:inspired_senior_care_app/cubits/signup/signup_cubit.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';

class BasicInfoPage extends StatefulWidget {
  final PageController pageController;
  const BasicInfoPage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  late bool hidePassword;
  @override
  void initState() {
    hidePassword = true;
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Stack(
          children: [
            Opacity(
                opacity: 0.05,
                child: Image.asset(
                  'lib/assets/backgrounds/Categories_Screenshot.png',
                )),
            Form(
                key: formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'First the basics.',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Email Sign Up.',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      SizedBox(
                          width: 325,
                          child: TextFormField(
                            controller: emailFieldController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              context.read<SignupCubit>().emailChanged(value);
                            },
                            validator: (value) =>
                                value != null && !EmailValidator.validate(value)
                                    ? 'Enter a valid email!'
                                    : null,
                            decoration: InputDecoration(
                                label: const Text('Email Address'),
                                prefixIcon: const Icon(Icons.email_rounded),
                                suffixIcon: IconButton(
                                    onPressed: () =>
                                        emailFieldController.clear(),
                                    icon: const Icon(Icons.close))),
                          )),
                      /*  Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Create a Password',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),*/
                      const SizedBox(
                        height: 12.0,
                      ),
                      SizedBox(
                        width: 325,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          controller: passwordFieldController,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                icon: hidePassword
                                    ? const Icon(Icons.visibility_off_rounded)
                                    : const Icon(Icons.visibility_rounded)),
                          ),
                          onChanged: (value) {
                            context.read<SignupCubit>().passwordChanged(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          height: 70,
                          child: FlutterPwValidator(
                              width: 300,
                              height: 50,
                              minLength: 6,
                              uppercaseCharCount: 1,
                              specialCharCount: 1,
                              onFail: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Invalid Password!'),
                                  backgroundColor: Colors.redAccent,
                                ));
                              },
                              onSuccess: () {},
                              controller: passwordFieldController),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(onPressed: () async {
                          final form = formKey.currentState;
                          if (form!.validate()) {
                            await context
                                .read<SignupCubit>()
                                .signupWithCredentials();

                            // TODO: Implement Signup Cubit
                            // * Create Initial User Object
                            if (!mounted) return;
                            User user = User(
                                id: context.read<SignupCubit>().state.user!.uid,
                                name: '',
                                email: emailFieldController.text,
                                type: '',
                                title: '',
                                userColor: '',
                                groups: [],
                                progress: {});
                            // * Pass User to Onboarding Bloc
                            context
                                .read<OnboardingBloc>()
                                .add(StartOnboarding(user: user));
                            await Future.delayed(const Duration(seconds: 1));
                            widget.pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text('Invalid Email Entered!')));
                          }
                        }, child: BlocBuilder<SignupCubit, SignupState>(
                          builder: (context, state) {
                            if (state.status == SignupStatus.submitting) {
                              return const SizedBox(
                                height: 20,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            if (state.status == SignupStatus.success) {
                              return Wrap(spacing: 4.0, children: const [
                                Icon(Icons.check_circle),
                                Text('Signed Up!')
                              ]);
                            }
                            if (state.status == SignupStatus.error) {
                              return const Text('Try Again!');
                            }
                            return const Text('Sign Up');
                          },
                        )),
                      ),
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }
}
