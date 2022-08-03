import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/view/pages/signup/basic_info.dart';
import 'package:inspired_senior_care_app/view/pages/signup/profile_info.dart';
import 'package:inspired_senior_care_app/view/pages/signup/user_type.dart';
import 'package:inspired_senior_care_app/view/pages/signup/welcome.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: PageView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              WelcomePage(pageController: controller),
              BasicInfoPage(pageController: controller),
              UserTypePage(pageController: controller),
              ProfileInfo(pageController: controller),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 60,
        color: Colors.grey.shade300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmoothPageIndicator(
              controller: controller,
              count: 4,
              effect: const WormEffect(spacing: 16),
            )
          ],
        ),
      ),
    );
  }
}
