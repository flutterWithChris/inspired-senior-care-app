import 'package:flutter/material.dart';

class UpgradePage extends StatelessWidget {
  const UpgradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Unlock These Packs!',
            style: Theme.of(context).textTheme.headline5,
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Unlock Now')),
          const Text('\$9.99 for lifetime access.')
        ]),
      ),
    );
  }
}
