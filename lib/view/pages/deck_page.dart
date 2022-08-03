import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:inspired_senior_care_app/bloc/deck/deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';

class DeckPage extends StatelessWidget {
  //const DeckPage({Key? key}) : super(key: key);

  //@override
  //State<DeckPage> createState() => _DeckPageState();
//}

//class _DeckPageState extends State<DeckPage> {
  bool isSwipeDisabled = true;
  bool isCardZoomed = false;
  final InfiniteScrollController deckScrollController =
      InfiniteScrollController();

  @override
  Widget build(BuildContext context) {
    int currentCardIndex = context.watch<DeckCubit>().currentCardNumber;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: BlocConsumer<DeckCubit, DeckState>(
            listener: (context, state) {
              if (state.status == DeckStatus.swiped) {
                if (currentCardIndex < 12) {
                  //currentCardIndex++;
                  deckScrollController.animateToItem(currentCardIndex);
                }
              }
              if (state.status == DeckStatus.completed) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const DeckCompleteDialog();
                  },
                );
              }
            },
            builder: (context, state) {
              if (state.status == DeckStatus.zoomed) {
                return Visibility(
                  visible: false,
                  child: AppBar(
                      toolbarHeight: 50,
                      title: const Text('Positive Interactions')),
                );
              }
              return AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 1000),
                child: AppBar(
                  toolbarHeight: 50,
                  centerTitle: true,
                  title: const Text('Positive Interactions'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: const MainBottomAppBar(),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: AnimatedSlide(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 200),
                  offset: isCardZoomed
                      ? const Offset(0, -0.35)
                      : const Offset(0, -0.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SizedBox(
                        height: 500,
                        child: IgnorePointer(
                          ignoring: isSwipeDisabled,
                          child: BlocListener<DeckCubit, DeckState>(
                            listener: (context, state) {
                              // TODO: implement listener
                              if (state.status == DeckStatus.completed) {
                                isSwipeDisabled = false;
                              }
                              if (state.status == DeckStatus.zoomed) {
                                isCardZoomed = true;
                              } else if (state.status == DeckStatus.unzoomed) {
                                isCardZoomed = false;
                              }
                            },
                            child: Deck(
                                deckScrollController: deckScrollController),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isSwipeDisabled ? true : false,
                        child: Positioned(
                          right: 15,
                          top: -10,
                          child:
                              CardCounter(currentCardIndex: currentCardIndex),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Visibility(
                  visible: isSwipeDisabled ? true : false,
                  child: ShareButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardCounter extends StatelessWidget {
  const CardCounter({
    Key? key,
    required this.currentCardIndex,
  }) : super(key: key);

  final int currentCardIndex;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 34,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 29,
        child: Text(
          '$currentCardIndex/12',
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class Deck extends StatelessWidget {
  const Deck({
    Key? key,
    required this.deckScrollController,
  }) : super(key: key);

  final InfiniteScrollController deckScrollController;

  @override
  Widget build(BuildContext context) {
    return InfiniteCarousel.builder(
      controller: deckScrollController,
      velocityFactor: 0.5,
      itemCount: 12,
      itemExtent: 350,
      itemBuilder: (context, itemIndex, realIndex) {
        return InfoCard(
          cardNumber: itemIndex + 1,
        );
      },
    );
  }
}

class DeckCompleteDialog extends StatelessWidget {
  const DeckCompleteDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.topEnd,
          children: [
            Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  'All Done. Congrats!',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Wrap(
                  spacing: 15,
                  children: [
                    for (int i = 0; i < 3; i++)
                      const Icon(
                        FontAwesomeIcons.rankingStar,
                        color: Colors.yellow,
                        size: 48,
                      )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'You\'ve completed this category. Be proud of yourself!',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Review Deck')),
            ]),
            Positioned(
              top: -25,
              right: -5,
              child: SizedBox(
                height: 40,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                      backgroundColor: Colors.black54, child: CloseButton()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  final TextEditingController shareFieldController = TextEditingController();

  ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(fixedSize: const Size(200, 36)),
      label: const Text('Share Response'),
      icon: const Icon(
        FontAwesomeIcons.solidMessage,
        size: 16,
      ),
      onPressed: () {
        // * Zoom Deck on Press
        var deckCubit = context.read<DeckCubit>();
        deckCubit.zoomDeck();
        // * Shows Bottom Sheet for Response
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
    );
  }
}

class ViewResponsesButton extends StatelessWidget {
  final TextEditingController shareFieldController = TextEditingController();

  ViewResponsesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(fixedSize: const Size(200, 36)),
      label: const Text('View Response'),
      icon: const Icon(
        FontAwesomeIcons.eye,
        size: 16,
      ),
      onPressed: () {
        // * Zoom Deck on Press
        var deckCubit = context.read<DeckCubit>();
        deckCubit.zoomDeck();
        // * Shows Bottom Sheet for Response
        var viewResponseBottomSheet = showBottomSheet(
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
        viewResponseBottomSheet.closed.then((value) {
          deckCubit.unzoomDeck();
        });
      },
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
    int currentCardIndex = context.watch<DeckCubit>().currentCardNumber;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(fixedSize: const Size(240, 42)),
      onPressed: () {
        context.read<ShareBloc>().add(SubmitPressed());

        if (currentCardIndex == 12) {
          //context.read<DeckCubit>().resetDeck();
          widget.shareFieldController.clear();
          Navigator.pop(context);
          context.read<DeckCubit>().completeDeck();
        } else {
          context.read<DeckCubit>().incrementCardNumber();
          context.read<DeckCubit>().swipeDeck();
          context.read<DeckCubit>().resetDeck();
          widget.shareFieldController.clear();
          Navigator.pop(context);
        }
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
          if (state.status == Status.initial) {}
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
