import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
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
            children: const [
              BasicInfoPage(),
              UserTypePage(),
              ProfileInfo(),
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
              count: 3,
              effect: const WormEffect(spacing: 16),
            )
          ],
        ),
      ),
    );
  }
}

class UserTypePage extends StatelessWidget {
  const UserTypePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Healthcare Worker'),
            subtitle: Text('I just want to learn!'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(
              width: 250,
              child: Divider(
                thickness: 0.75,
              )),
          const ListTile(
            leading: Icon(Icons.security),
            title: Text('I\'m a Manager'),
            subtitle:
                Text('I\'d like to create groups & view others\' progress.'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

class BasicInfoPage extends StatelessWidget {
  const BasicInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What\'s Your Email?',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
              width: 325,
              child: TextFormField(
                decoration: const InputDecoration(label: Text('Email Address')),
              )),
          Text(
            'Create a Password',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            width: 325,
            child: TextFormField(
              decoration: const InputDecoration(label: Text('Password')),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Continue')),
        ],
      ),
    ));
  }
}

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    screenPickerColor = Colors.blue; // Material blue.
    dialogPickerColor = Colors.red; // Material red.
    dialogSelectColor = const Color(0xFFA239CA); // A purple color.
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'What\'s Your Name?',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            width: 325,
            child: TextFormField(
              decoration: const InputDecoration(label: Text('Your Name')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'What\'s Your Title?',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const SizedBox(
            width: 325,
            child: TextField(
              decoration: InputDecoration(label: Text('Title')),
            ),
          ),
          Card(
            child: ColorPicker(
              color: screenPickerColor,
              onColorChanged: (Color selectedColor) =>
                  setState(() => screenPickerColor = selectedColor),
              borderRadius: 22,
              heading: Text(
                'Pick a Color',
                style: Theme.of(context).textTheme.headline5,
              ),
              subheading: Text(
                'Pick a Shade',
                style: Theme.of(context).textTheme.headline5,
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
              subtitle: const Text('Choose a color for your profile'),
              trailing: ColorIndicator(
                borderRadius: 22,
                color: screenPickerColor,
              ),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Finish Setup')),
        ],
      ),
    );
  }
}
