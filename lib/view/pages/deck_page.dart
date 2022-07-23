import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({Key? key}) : super(key: key);

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  bool zoomCard = false;
  bool isSwipeDisabled = true;
  int currentCardIndex = 1;

  final AppinioSwiperController controller = AppinioSwiperController();

  @override
  void initState() {
    // TODO: implement initState
    controller.addListener(() {});
    super.initState();
  }

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
    int _incrementCounter() {
      setState(() {
        currentCardIndex++;
      });
      return currentCardIndex;
    }

    _decrementCounter() {
      currentCardIndex--;
    }

    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(title: const Text('Inspired Senior Care')),
      bottomNavigationBar: const MainBottomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedScale(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 200),
              scale: zoomCard == true ? 1.1 : 1.0,
              child: AnimatedSlide(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 200),
                offset: zoomCard == true
                    ? const Offset(0, -0.4)
                    : const Offset(0, 0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    SizedBox(
                      height: 500,
                      child: AppinioSwiper(
                          controller: controller,
                          onSwipe: (int index) {
                            controller.swipe();
                            _incrementCounter();
                          },
                          isDisabled: isSwipeDisabled,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          cards: [
                            for (var i = 12; i > 0; i--)
                              InfoCard(
                                cardNumber: i,
                              ),
                          ]),
                    ),
                    Positioned(
                      right: 15,
                      top: -20,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 30,
                          child: Text(
                            '$currentCardIndex/12',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: ShareButton(
                swipeController: controller,
                zoomCard: _zoomCard,
                unZoomCard: _unZoomCard,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareButton extends StatefulWidget {
  final AppinioSwiperController swipeController;
  final bool Function() zoomCard;
  final bool Function() unZoomCard;
  const ShareButton({
    required this.swipeController,
    required this.unZoomCard,
    required this.zoomCard,
    Key? key,
  }) : super(key: key);

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  TextEditingController shareFieldController = TextEditingController();

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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          height: 5,
                          width: 30,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      ShareTextField(
                        shareFieldController: shareFieldController,
                      ),
                      SendButton(
                          shareFieldController: shareFieldController,
                          swipeController: widget.swipeController),
                    ]),
              ),
            );
          },
        );
        bottomSheet.closed.then((value) => unZoom());
      },
      child: const Text('Share Response'),
    );
  }
}

class ShareTextField extends StatelessWidget {
  final TextEditingController shareFieldController;
  const ShareTextField({
    required this.shareFieldController,
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
        child: TextField(
          controller: shareFieldController,
          autofocus: true,
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.start,
          minLines: 4,
          maxLines: 4,
          decoration: const InputDecoration.collapsed(
              hintText: 'Share your response..'),
        ),
      ),
    );
  }
}

class SendButton extends StatefulWidget {
  final AppinioSwiperController swipeController;
  final TextEditingController shareFieldController;
  const SendButton(
      {required this.swipeController,
      required this.shareFieldController,
      Key? key})
      : super(key: key);

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(fixedSize: const Size(240, 42)),
      onPressed: () {
        context.read<ShareBloc>().add(SubmitPressed());
      },
      icon: BlocBuilder<ShareBloc, ShareState>(
        builder: (context, state) {
          if (state.status == Status.failed) {
            return const Dialog();
          }
          if (state.status == Status.initial) {
            return const Icon(
              Icons.send_rounded,
              size: 18,
            );
          }
          if (state.status == Status.submitted) {
            return const Icon(
              Icons.check,
              color: Colors.lime,
            );
          }
          if (state.status == Status.submitting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(
            child: Text('Something Went Wrong..'),
          );
        },
      ),
      label: BlocConsumer<ShareBloc, ShareState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == Status.initial) {
            widget.shareFieldController.clear();
            Navigator.of(context).pop();
            widget.swipeController.swipe();
          }
        },
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == Status.failed) {
            return const Dialog();
          }
          if (state.status == Status.initial) {
            return const Text(
              'Submit',
              //style: TextStyle(color: Colors.white),
            );
          }
          if (state.status == Status.submitted) {
            return const Text('Submitted!');
          }
          if (state.status == Status.submitting) {
            return const Text('Submitting...');
          }
          return const Center(
            child: Text('Something Went Wrong..'),
          );
        },
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
