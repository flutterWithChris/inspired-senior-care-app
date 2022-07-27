import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:inspired_senior_care_app/bloc/deck/deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({Key? key}) : super(key: key);

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  // bool isSwipeDisabled = true;
  int currentCardIndex = 1;
  final InfiniteScrollController deckScrollController =
      InfiniteScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: BlocConsumer<DeckCubit, DeckState>(
            listener: (context, state) {
              if (state.status == DeckStatus.swiped) {
                currentCardIndex++;
                deckScrollController.animateToItem(currentCardIndex - 1);
                context.read<DeckCubit>().resetDeck();
              }
            },
            builder: (context, state) {
              if (state.status == DeckStatus.zoomed) {
                return Visibility(
                  visible: false,
                  child: AppBar(
                      toolbarHeight: 50,
                      title: const Text('Inspired Senior Care')),
                );
              }
              return AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 1000),
                child: AppBar(
                  toolbarHeight: 50,
                  title: const Text('Inspired Senior Care'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: const MainBottomAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<DeckCubit, DeckState>(builder: (context, state) {
                  var deckCubit = context.read<DeckCubit>();
                  if (state.status == DeckStatus.zoomed) {
                    return AnimatedScale(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 200),
                      scale: 1.2,
                      child: AnimatedSlide(
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 200),
                        offset: const Offset(0, -0.25),
                        child: IgnorePointer(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              SizedBox(
                                height: 450,
                                child: InfiniteCarousel.builder(
                                  controller: deckScrollController,
                                  velocityFactor: 0.5,
                                  itemCount: 12,
                                  itemExtent: 300,
                                  itemBuilder: (context, itemIndex, realIndex) {
                                    return InfoCard(
                                      cardNumber: itemIndex + 1,
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                right: 35,
                                top: -0,
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
                    );
                  }
                  return AnimatedScale(
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 200),
                    scale: 1.0,
                    child: AnimatedSlide(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 200),
                      offset: const Offset(0, -0.0),
                      child: IgnorePointer(
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            SizedBox(
                              height: 500,
                              child: InfiniteCarousel.builder(
                                controller: deckScrollController,
                                velocityFactor: 0.5,
                                itemCount: 12,
                                itemExtent: 300,
                                itemBuilder: (context, itemIndex, realIndex) {
                                  return InfoCard(
                                    cardNumber: itemIndex + 1,
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              right: 25,
                              top: -5,
                              child: CircleAvatar(
                                radius: 34,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 29,
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
                  );
                }),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: ShareButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShareButton extends StatefulWidget {
  const ShareButton({
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
        var deckCubit = context.read<DeckCubit>();

        deckCubit.zoomDeck();
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
                      ),
                    ]),
              ),
            );
          },
        );
        Container();
        bottomSheet.closed.then((value) {
          deckCubit.unzoomDeck();
        });
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
  final TextEditingController shareFieldController;

  const SendButton({required this.shareFieldController, Key? key})
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
            return const SizedBox(
              height: 18,
              child: FittedBox(child: CircularProgressIndicator()),
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
            Navigator.pop(context);
            context.read<DeckCubit>().swipeDeck();
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            'lib/assets/card_contents/positive_interactions/${cardNumber.toString()}.png',
            height: 200,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
