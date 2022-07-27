import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                    decoration: InputDecoration(
                      label: const Text('Email Address'),
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
                    decoration: InputDecoration(
                      label: const Text('Password'),
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
                    context.read<AuthBloc>().add(AuthUserChanged());
                    context.go('/');
                  },
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        fixedSize:
                            const MaterialStatePropertyAll(Size(200, 30)),
                      ),
                  child: const Text('Login'),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
