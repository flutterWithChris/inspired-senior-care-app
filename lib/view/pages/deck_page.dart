import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({Key? key}) : super(key: key);

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Inspired Senior Care')),
        bottomNavigationBar: const MainBottomAppBar(),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.asset('lib/assets/Positive_Interactions.png'),
            AppinioSwiper(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
                cards: [
                  for (var i = 12; i > 0; i--)
                    InfoCard(
                      cardNumber: i,
                    ),
                ])
          ],
        ));
  }
}

class InfoCard extends StatelessWidget {
  final int cardNumber;
  const InfoCard({
    Key? key,
    required this.cardNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: SizedBox(
          width: 250,
          child: Image.asset(
              'lib/assets/card_contents/positive_interactions/${cardNumber.toString()}.png')),
    );
  }
}
