import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:inspired_senior_care_app/bloc/manage/response_interaction_cubit.dart';
import 'package:inspired_senior_care_app/bloc/manage/view_response_deck_cubit.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';

class ViewResponses extends StatefulWidget {
  const ViewResponses({Key? key}) : super(key: key);

  @override
  State<ViewResponses> createState() => _ViewResponseDeckPageState();
}

class _ViewResponseDeckPageState extends State<ViewResponses> {
  // bool isSwipeDisabled = true;
  int currentCardIndex = 1;
  final InfiniteScrollController deckScrollController =
      InfiniteScrollController();
  @override
  Widget build(BuildContext context) {
    TextEditingController responseTextFieldController = TextEditingController();

    return Scaffold(
      // * Bottom Sheet
      bottomSheet: ResponseBottomSheet(
          responseFieldController: responseTextFieldController),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.redAccent,
      // * App Bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BlocConsumer<ViewResponseDeckCubit, ViewResponseDeckState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == ViewResponseDeckStatus.unswiped &&
                currentCardIndex > 1) {
              currentCardIndex--;
              print(currentCardIndex);
              deckScrollController.previousItem();
              context.read<ViewResponseDeckCubit>().resetDeck();
            }
            if (state.status == ViewResponseDeckStatus.swiped &&
                currentCardIndex < 12) {
              currentCardIndex++;
              print(currentCardIndex);
              deckScrollController.nextItem();
              context.read<ViewResponseDeckCubit>().resetDeck();
            }
          },
          builder: (context, state) {
            return AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 1000),
              child: AppBar(
                  toolbarHeight: 50, title: const Text('Inspired Senior Care')),
            );
          },
        ),
      ),
      bottomNavigationBar: const MainBottomAppBar(),
      // * Body
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<ViewResponseDeckCubit, ViewResponseDeckState>(
                  builder: (context, state) {
                var deckCubit = context.read<ViewResponseDeckCubit>();
                //deckCubit.zoomDeck();
                if (state.status == ViewResponseDeckStatus.unzoomed) {
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
                  scale: 1.2,
                  child: AnimatedSlide(
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 200),
                    offset: const Offset(0, -0.15),
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
                            top: 100,
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class ResponseBottomSheet extends StatefulWidget {
  final TextEditingController responseFieldController;
  const ResponseBottomSheet({
    required this.responseFieldController,
    Key? key,
  }) : super(key: key);

  @override
  State<ResponseBottomSheet> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ResponseBottomSheet> {
  @override
  Widget build(BuildContext context) {
    TextEditingController responseTextFieldController =
        widget.responseFieldController;
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        maxChildSize: 0.5,
        builder: (context, controller) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
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
                        BlocProvider(
                          create: (context) => ResponseInteractionCubit(),
                          child: ResponseTextField(
                            responseTextFieldController:
                                responseTextFieldController,
                          ),
                        ),
                        /* PageButtons(
                          responseTextFieldController:
                              responseTextFieldController,
                        ),*/
                      ]),
                ),
              );
            },
          );
        });
  }
}

class ResponseTextField extends StatelessWidget {
  final TextEditingController responseTextFieldController;

  const ResponseTextField({
    required this.responseTextFieldController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    color: Colors.grey.shade300,
                    spreadRadius: 5),
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
              enabled: false,
              controller: responseTextFieldController,
              expands: true,
              // autofocus: true,
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.start,
              minLines: null,
              maxLines: null,
              decoration: const InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  //isCollapsed: true,
                  hintText: 'Nothing Yet!',
                  filled: false,
                  label: Text('Response'),
                  border: InputBorder.none),
            ),
          ),
        ),
        SizedBox(
          height: 35,
          width: 350,
          child: Wrap(
            alignment: WrapAlignment.end,
            children: [
              BlocBuilder<ResponseInteractionCubit, ResponseInteractionState>(
                builder: (context, state) {
                  if (state.interaction == Interaction.liked) {
                    return IconButton(
                        onPressed: () {
                          context
                              .read<ResponseInteractionCubit>()
                              .unlikeResponse();
                        },
                        icon: const Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.redAccent,
                          size: 22,
                        ));
                  }
                  return IconButton(
                      onPressed: () {
                        context.read<ResponseInteractionCubit>().likeResponse();
                      },
                      icon: const Icon(
                        FontAwesomeIcons.heart,
                        size: 22,
                      ));
                },
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.reply,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PageButtons extends StatefulWidget {
  final TextEditingController responseTextFieldController;

  const PageButtons({required this.responseTextFieldController, Key? key})
      : super(key: key);

  @override
  State<PageButtons> createState() => _PageButtonState();
}

class _PageButtonState extends State<PageButtons> {
  @override
  Widget build(BuildContext context) {
    var deckCubit = context.read<ViewResponseDeckCubit>();

    return Wrap(
      spacing: 16,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(fixedSize: const Size(150, 32)),
          onPressed: () => deckCubit.unswipeDeck(),
          label: const Text('Previous'),
          icon: const Icon(Icons.arrow_left),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(fixedSize: const Size(150, 32)),
          onPressed: () => deckCubit.swipeDeck(),
          label: const Text('Next'),
          icon: const Icon(Icons.arrow_right),
        ),
      ],
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
