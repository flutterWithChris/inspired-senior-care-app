import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/cubits/login/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Opacity(
                  opacity: 0.05,
                  child: Image.asset(
                    'lib/assets/backgrounds/Categories_Screenshot.png',
                  )),
              Center(
                child: Form(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.headline4,
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
                        validator: (value) =>
                                value != null && !EmailValidator.validate(value)
                                    ? 'Enter a valid email!'
                                    : null,
                        onChanged: (value) =>
                            context.read<LoginCubit>().emailChanged(value),
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
                        onChanged: (value) =>
                            context.read<LoginCubit>().passwordChanged(value),
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
                              onPressed: () {},
                              child: const Text('Forgot Password?'))
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LoginCubit>().signInWithCredentials();
                      },
                      style: Theme.of(context)
                          .elevatedButtonTheme
                          .style!
                          .copyWith(
                            fixedSize:
                                MaterialStateProperty.all(const Size(200, 30)),
                          ),
                      child: const Text('Login'),
                    ),
                  ],
                )),
              ),
            ],
          ),
        );
      },
    );
  }
}
