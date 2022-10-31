import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  final PageController pageController;
  const WelcomePage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Opacity(
              opacity: 0.05,
              child: Image.asset(
                  'lib/assets/backgrounds/Categories_Screenshot.png')),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Welcome!',
                      style: Theme.of(context).textTheme.displayMedium),
                ),
                const Text(
                    'Learn the what\'s, why\'s, & how\'s of senior care.'),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: ElevatedButton(
                    onPressed: () {
                      widget.pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 32)),
                    child: const Text('Get Started'),
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setInt('initScreen', 1);
                      if (!mounted) return;
                      context.goNamed('login');
                    },
                    child: const Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'Have an account?'),
                        TextSpan(
                            text: ' Sign in.',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
