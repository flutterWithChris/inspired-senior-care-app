import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final PageController pageController;
  const WelcomePage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

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
                      style: Theme.of(context).textTheme.headline2),
                ),
                const Text(
                    'Learn the what\'s, why\'s, & how\'s of senior care.'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: ElevatedButton(
                    onPressed: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 32)),
                    child: const Text('Get Started'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
