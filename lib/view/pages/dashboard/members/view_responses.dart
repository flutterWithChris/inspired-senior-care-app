import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:inspired_senior_care_app/bloc/manage/response_interaction_cubit.dart';
import 'package:inspired_senior_care_app/bloc/manage/view_response_deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/view_response/view_response_cubit.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class ViewResponses extends StatefulWidget {
  const ViewResponses({Key? key}) : super(key: key);

  @override
  State<ViewResponses> createState() => _ViewResponseDeckPageState();
}

class _ViewResponseDeckPageState extends State<ViewResponses> {
  // bool isSwipeDisabled = true;
  int currentCardIndex = 1;
  late InfiniteScrollController deckScrollController;
  late InfiniteScrollController responseFieldScrollController;

  late LinkedScrollControllerGroup _scrollControllers;
  final ViewResponseCubit _viewResponseCubit = ViewResponseCubit();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollControllers = LinkedScrollControllerGroup();
    deckScrollController = InfiniteScrollController();
    responseFieldScrollController = InfiniteScrollController();
    deckScrollController.addListener(() {
      _viewResponseCubit.scroll(deckScrollController.selectedItem);
      print(deckScrollController.selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController responseTextFieldController = TextEditingController();
    ScrollController controller = ScrollController();
    return Scaffold(
      // * Bottom Sheet

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
              // deckScrollController.previousItem();
              context.read<ViewResponseDeckCubit>().resetDeck();
            }
            if (state.status == ViewResponseDeckStatus.swiped &&
                currentCardIndex < 12) {
              currentCardIndex++;
              print(currentCardIndex);
              // deckScrollController.nextItem();
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
      body: SingleChildScrollView(
        //scrollDirection: Axis.horizontal,
        controller: controller,
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SizedBox(
                        height: 450,
                        child: InfiniteCarousel.builder(
                          onIndexChanged: (p0) {
                            if (currentCardIndex > p0) {
                              context
                                  .read<ViewResponseDeckCubit>()
                                  .unswipeDeck();
                            } else {
                              context.read<ViewResponseDeckCubit>().swipeDeck();
                            }
                          },
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
              );
            }),
            ResponseBottomSheet(
              responseFieldController: responseTextFieldController,
              deckScrollController: deckScrollController,
            ),
          ],
        ),
      ),
    );
  }
}

class ResponseBottomSheet extends StatefulWidget {
  final TextEditingController responseFieldController;
  final InfiniteScrollController deckScrollController;
  const ResponseBottomSheet({
    required this.deckScrollController,
    required this.responseFieldController,
    Key? key,
  }) : super(key: key);

  @override
  State<ResponseBottomSheet> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ResponseBottomSheet> {
  final InfiniteScrollController scrollController = InfiniteScrollController();
  final ViewResponseCubit _viewResponseCubit = ViewResponseCubit();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.deckScrollController.addListener(() {
      scrollController.animateToItem(widget.deckScrollController.selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController responseTextFieldController =
        widget.responseFieldController;

    return SizedBox(
      height: 175,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          color: Colors.transparent,
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocProvider(
                  create: (context) => ResponseInteractionCubit(),
                  child: SizedBox(
                    height: 175,
                    child: BlocConsumer<ViewResponseCubit, ViewResponseState>(
                      listener: (context, state) {
                        // TODO: implement listener
                        if (state.scrollStatus == ScrollStatus.scrolling) {
                          // scrollController
                          //     .animateToItem(state.currentCardIndex);
                        }
                      },
                      buildWhen: (previous, current) =>
                          previous.currentCardIndex != current.currentCardIndex,
                      builder: (context, state) {
                        return InfiniteCarousel.builder(
                            controller: scrollController,
                            itemCount: 12,
                            itemExtent: 350,
                            itemBuilder: (context, index, realIndex) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ResponseTextField(
                                  responseTextFieldController:
                                      responseTextFieldController,
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ),
                /* PageButtons(
                            responseTextFieldController:
                                responseTextFieldController,
                          ),*/
              ]),
        ),
      ),
    );
  }
}

class ResponseTextField extends StatefulWidget {
  final TextEditingController responseTextFieldController;

  const ResponseTextField({
    required this.responseTextFieldController,
    Key? key,
  }) : super(key: key);

  @override
  State<ResponseTextField> createState() => _ResponseTextFieldState();
}

class _ResponseTextFieldState extends State<ResponseTextField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.responseTextFieldController.text =
        'This is a response to the cards above! Here would be something thoughtful that reflects the lesson taught via this card.';
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
              controller: widget.responseTextFieldController,
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
