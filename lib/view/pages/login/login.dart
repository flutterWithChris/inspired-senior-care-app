import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/cubits/login/forgot_password_cubit.dart';
import 'package:inspired_senior_care_app/cubits/login/login_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Opacity(
              opacity: 0.05,
              child: Image.asset(
                'lib/assets/backgrounds/Categories_Screenshot.png',
              )),
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              if (state.status == LoginStatus.submitting) {
                return Center(
                  child: LoadingAnimationWidget.inkDrop(
                      color: Colors.blue, size: 30.0),
                );
              }
              if (state.status == LoginStatus.error) {
                return const Center(
                  child: Text('Error Logging In!'),
                );
              }
              if (state.status == LoginStatus.success) {
                return Center(
                  child: Wrap(
                    spacing: 8.0,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.green.shade400,
                      ),
                      Text(
                        'Logged In!',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              }
              if (state.status == LoginStatus.initial) {
                return Center(
                  child: Form(
                      key: _loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Sign In',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          SizedBox(
                            width: 325,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      context.goNamed('signup');
                                    },
                                    child: const Text('New? Sign Up.'))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 325,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => value != null &&
                                      !EmailValidator.validate(value)
                                  ? 'Enter a valid email!'
                                  : null,
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .emailChanged(value),
                              decoration: InputDecoration(
                                label: const Text('Email Address'),
                                prefixIcon: const Icon(Icons.email),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          SizedBox(
                            width: 325,
                            child: TextFormField(
                              obscureText: hidePassword,
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .passwordChanged(value),
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
                                        ? const Icon(
                                            Icons.visibility_off_rounded)
                                        : const Icon(Icons.visibility_rounded)),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 325,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ForgotPasswordDialog(),
                                      );
                                    },
                                    child: const Text('Forgot Password?'))
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_loginFormKey.currentState!.validate()) {
                                context
                                    .read<LoginCubit>()
                                    .signInWithCredentials();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Invalid Login!'),
                                  backgroundColor: Colors.redAccent,
                                ));
                              }
                            },
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style!
                                .copyWith(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(200, 30)),
                                ),
                            child: const Text('Login'),
                          ),
                        ],
                      )),
                );
              } else {
                return const Center(
                  child: Text('Something Went Wrong...'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class ForgotPasswordDialog extends StatelessWidget {
  ForgotPasswordDialog({super.key});

  final GlobalKey<FormState> forgotPassEmailFieldKey = GlobalKey<FormState>();
  final TextEditingController forgotPassEmailController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: SizedBox(
          height: 225,
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) async {
              if (state == ForgotPasswordState.sent()) {
                await Future.delayed(const Duration(seconds: 2), () {
                  Navigator.pop(context);
                });
              }
            },
            builder: (context, state) {
              if (state == ForgotPasswordState.failed()) {
                return const Center(
                  child: Text('Error sending request!'),
                );
              }
              if (state == ForgotPasswordState.sending()) {
                return Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                      color: Colors.blue, size: 20.0),
                );
              }
              if (state == ForgotPasswordState.sent()) {
                return const Center(
                  child: Text('Password reset sent! Check your inbox.'),
                );
              }
              if (state == ForgotPasswordState.initial()) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Text(
                      'Enter your email address to receive a reset password email.',
                      textAlign: TextAlign.center,
                    ),
                    Form(
                      key: forgotPassEmailFieldKey,
                      child: TextFormField(
                        controller: forgotPassEmailController,
                        validator: (value) =>
                            value != null && !EmailValidator.validate(value)
                                ? 'Enter a valid email!'
                                : null,
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(label: Text('Email Address')),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (forgotPassEmailFieldKey.currentState!
                              .validate()) {
                            context
                                .read<ForgotPasswordCubit>()
                                .requestPasswordReset(
                                    forgotPassEmailController.value.text);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Enter a valid email!'),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        },
                        child: const Text('Request Reset')),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Something Went Wrong...'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
