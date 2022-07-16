import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({Key? key}) : super(key: key);

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  bool zoomCard = false;
  bool isSwipeDisabled = true;

  bool _zoomCard() {
    setState(() {
      zoomCard = true;
    });
    return zoomCard;
  }

  bool _unZoomCard() {
    setState(() {
      zoomCard = false;
    });
    return zoomCard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(title: const Text('Inspired Senior Care')),
      bottomNavigationBar: const MainBottomAppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 350),
              scale: zoomCard == true ? 1.2 : 1.0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 350),
                offset: zoomCard == true
                    ? const Offset(0, -0.4)
                    : const Offset(0, 0),
                child: SizedBox(
                  height: 500,
                  child: AppinioSwiper(
                      isDisabled: isSwipeDisabled,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      cards: [
                        for (var i = 12; i > 0; i--)
                          InfoCard(
                            cardNumber: i,
                          ),
                      ]),
                ),
              ),
            ),
            Visibility(
              visible: zoomCard ? false : true,
              child: Padding(
                padding: const EdgeInsets.only(top: 35),
                child: ShareButton(
                  zoomCard: _zoomCard,
                  unZoomCard: _unZoomCard,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareButton extends StatefulWidget {
  final bool Function() zoomCard;
  final bool Function() unZoomCard;
  const ShareButton({
    required this.unZoomCard,
    required this.zoomCard,
    Key? key,
  }) : super(key: key);

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        var zoom = widget.zoomCard;
        var unZoom = widget.unZoomCard;
        zoom();
        var bottomSheet = showBottomSheet(
          context: context,
          builder: (context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                height: 240,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.drag_handle_rounded,
                        color: Colors.grey.shade500,
                      ),
                      const ShareTextField(),
                      const SendButton(),
                    ]),
              ),
            );
          },
        );
        bottomSheet.closed.then((value) => unZoom());
      },
      child: const Text('Share'),
    );
  }
}

class ShareTextField extends StatelessWidget {
  const ShareTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                blurRadius: 10, color: Colors.grey.shade300, spreadRadius: 5),
          ]),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const TextField(
          minLines: 1,
          maxLines: 4,
          decoration:
              InputDecoration.collapsed(hintText: 'Share your response'),
        ),
      ),
    );
  }
}

class SendButton extends StatefulWidget {
  const SendButton({Key? key}) : super(key: key);

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: const Size(240, 42)),
      onPressed: () {},
      //color: Colors.grey.shade800,
      child: const Text(
        'Submit',
        //style: TextStyle(color: Colors.white),
      ),
    );
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
                child: Image.asset(
                    'lib/assets/card_contents/positive_interactions/${cardNumber.toString()}.png')),
          ),
        ),
      ),
    );
  }
}
