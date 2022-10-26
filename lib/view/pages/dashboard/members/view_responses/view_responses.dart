import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/manage/response_interaction_cubit.dart';
import 'package:inspired_senior_care_app/bloc/manage/view_response_deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/bloc/view_response/response_bloc.dart';
import 'package:inspired_senior_care_app/cubits/response/response_deck_cubit.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/response.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ViewResponses extends StatefulWidget {
  @override
  State<ViewResponses> createState() => _ViewResponsesState();
}

class _ViewResponsesState extends State<ViewResponses> {
  bool isSwipeDisabled = false;

  bool isCardZoomed = false;

  final InfiniteScrollController deckScrollController =
      InfiniteScrollController();

  final InfiniteScrollController textFieldScrollController =
      InfiniteScrollController();

  @override
  Widget build(BuildContext context) {
    int currentCardIndex =
        context.watch<ViewResponseDeckCubit>().currentCardNumber;

    return BlocListener<CardBloc, CardState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is CardsLoading) {}
        if (state is CardsLoaded) {}
      },
      child: Scaffold(
        bottomSheet: ViewResponsesSheet(
          textFieldScrollController: textFieldScrollController,
          deckScrollController: deckScrollController,
        ),
        backgroundColor: Colors.grey.shade200,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: BlocConsumer<ViewResponseDeckCubit, ViewResponseDeckState>(
            listener: (context, state) {
              if (state.status == ViewResponseDeckStatus.swiped) {
                if (currentCardIndex < 12) {
                  //currentCardIndex++;
                  // deckScrollController.animateToItem(currentCardIndex);
                }
              }
            },
            builder: (context, state) {
              return AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 1000),
                child: BlocBuilder<CardBloc, CardState>(
                  builder: (context, state) {
                    if (state is CardsLoaded) {
                      //context.loaderOverlay.hide();
                      return AppBar(
                        toolbarHeight: 50,
                        centerTitle: true,
                        title: Text(state.category.name),
                        backgroundColor: state.category.categoryColor,
                      );
                    }
                    return AppBar(
                      toolbarHeight: 50,
                      centerTitle: true,
                      title: LoadingAnimationWidget.prograssiveDots(
                          color: Colors.white, size: 20),
                      backgroundColor: Colors.grey,
                    );
                  },
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: const MainBottomAppBar(),
        body: SafeArea(
          child: BlocBuilder<CardBloc, CardState>(
            builder: (context, state) {
              if (state is CardsLoading) {
                return Center(
                    child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.vertical,
                  spacing: 12,
                  children: [
                    LoadingAnimationWidget.horizontalRotatingDots(
                        color: Colors.blueAccent, size: 30),
                    const Text('Loading Cards...')
                  ],
                ));
              }
              if (state is CardsLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: AnimatedSlide(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 200),
                          offset: isCardZoomed
                              ? const Offset(0, -0.33)
                              : const Offset(0, -0.0),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 500),
                            scale: isCardZoomed ? 1.1 : 1.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                SizedBox(
                                  height: 500,
                                  child: BlocListener<ViewResponseDeckCubit,
                                      ViewResponseDeckState>(
                                    listener: (context, state) {
                                      // TODO: implement listener

                                      if (state.status ==
                                          ViewResponseDeckStatus.zoomed) {
                                        isCardZoomed = true;
                                      } else if (state.status ==
                                          ViewResponseDeckStatus.unzoomed) {
                                        isCardZoomed = false;
                                      }
                                    },
                                    child: Deck(
                                        textFieldScrollController:
                                            textFieldScrollController,
                                        deckScrollController:
                                            deckScrollController),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Visibility(
                          visible: isSwipeDisabled ? true : false,
                          child: ViewResponsesButton(
                            textFieldScrollController:
                                textFieldScrollController,
                            deckScrollController: deckScrollController,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('Something Went Wrong!'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class CardCounter extends StatelessWidget {
  final InfiniteScrollController deckScrollController;
  const CardCounter({
    required this.deckScrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentCardIndex =
        context.watch<ViewResponseDeckCubit>().currentCardNumber;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              User user = state.user;
              return BlocBuilder<CardBloc, CardState>(
                builder: (context, state) {
                  if (state is CardsLoaded) {
                    Category currentCategory = state.category;
                    String category = state.category.name;

                    bool categoryStarted =
                        user.currentCard!.containsKey(currentCategory.name);
                    if (!categoryStarted) {}
                    if (categoryStarted) {
                      Map<String, int> progressList = user.currentCard!;
                      int currentCardIndex =
                          progressList[currentCategory.name]!;

                      deckScrollController.animateToItem(currentCardIndex - 1);
                    }
                    return CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 32,
                      child: Text(
                        '$currentCardIndex/${currentCategory.totalCards}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }
                  return const Text('Something Went Wrong..');
                },
              );
            }
            return const Text('?');
          },
        ),
        BlocBuilder<CardBloc, CardState>(
          builder: (context, state) {
            if (state is CardsLoaded) {
              double percentageComplete =
                  currentCardIndex / state.category.totalCards!;
              return SizedBox(
                height: 64,
                width: 64,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      state.category.progressColor),
                  value: percentageComplete,
                ),
              );
            }
            return const Text('Something Went Wrong..');
          },
        )
      ],
    );
  }
}

class Deck extends StatefulWidget {
  final InfiniteScrollController deckScrollController;
  final InfiniteScrollController textFieldScrollController;

  const Deck(
      {Key? key,
      required this.deckScrollController,
      required this.textFieldScrollController})
      : super(key: key);

  @override
  State<Deck> createState() => _DeckState();
}

class _DeckState extends State<Deck> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state) {
        if (state is CardsLoading) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.inkDrop(
                    color: Colors.blueAccent, size: 30.0),
                const SizedBox(
                  height: 8.0,
                ),
                const Text('Loading Cards...')
              ],
            ),
          );
        }
        if (state is CardsLoaded) {
          List<String> cardImageUrls = state.cardImageUrls;
          return BlocBuilder<ResponseBloc, ResponseState>(
            builder: (context, state) {
              if (state is ResponseLoading) {
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.blue, size: 30),
                );
              }
              if (state is ResponseLoaded) {
                return InfiniteCarousel.builder(
                  loop: false,
                  controller: widget.deckScrollController,
                  velocityFactor: 0.3,
                  itemCount: state.responses?.length ?? 1,
                  itemExtent: 330,
                  onIndexChanged: (p0) {
                    widget.textFieldScrollController.animateToItem(p0,
                        curve: Curves.easeOutQuad,
                        duration: const Duration(seconds: 1));
                    context.read<ResponseDeckCubit>().scrollDeck(p0);
                  },
                  itemBuilder: (context, itemIndex, realIndex) {
                    return BlocBuilder<ResponseDeckCubit, ResponseDeckState>(
                      builder: (context, state) {
                        if (state.status == ScrollStatus.scrolled ||
                            state.status == ScrollStatus.stopped) {
                          // widget.deckScrollController
                          //     .animateToItem(state.index);
                        }
                        return InfoCard(
                          cardNumber: itemIndex + 1,
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('Something Went Wrong...'),
                );
              }
            },
          );
        } else {
          return const Center(
            child: Text('Error Loading Cards!'),
          );
        }
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
  final InfiniteScrollController deckScrollController;
  final InfiniteScrollController textFieldScrollController;
  final String categoryName;
  final TextEditingController shareFieldController = TextEditingController();

  ShareButton(
      {required this.deckScrollController,
      required this.categoryName,
      required this.textFieldScrollController,
      super.key});

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
        var deckCubit = context.read<ViewResponseDeckCubit>();
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
                        textFieldScrollController: textFieldScrollController,
                        deckScrollController: deckScrollController,
                        shareFieldController: shareFieldController,
                      ),
                      SendButton(
                        categoryName: categoryName,
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
  final InfiniteScrollController deckScrollController;
  final InfiniteScrollController textFieldScrollController;
  final TextEditingController shareFieldController = TextEditingController();

  ViewResponsesButton(
      {required this.deckScrollController,
      required this.textFieldScrollController,
      super.key});

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
        var deckCubit = context.read<ViewResponseDeckCubit>();
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
                        textFieldScrollController: textFieldScrollController,
                        deckScrollController: deckScrollController,
                        shareFieldController: shareFieldController,
                      ),
                      BlocBuilder<ResponseInteractionCubit,
                          ResponseInteractionState>(
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
                                context
                                    .read<ResponseInteractionCubit>()
                                    .likeResponse();
                              },
                              icon: const Icon(
                                FontAwesomeIcons.heart,
                                size: 22,
                              ));
                        },
                      ),
                      /*   SendButton(
                        categoryName: cat,
                        shareFieldController: shareFieldController,
                      ),*/
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

class ViewResponsesSheet extends StatelessWidget {
  final InfiniteScrollController deckScrollController;
  final InfiniteScrollController textFieldScrollController;
  final TextEditingController shareFieldController = TextEditingController();

  ViewResponsesSheet(
      {required this.deckScrollController,
      required this.textFieldScrollController,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        height: 200,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              ShareTextField(
                textFieldScrollController: textFieldScrollController,
                deckScrollController: deckScrollController,
                shareFieldController: shareFieldController,
              ),
            ]),
      ),
    );
  }
}

class ShareTextField extends StatefulWidget {
  final TextEditingController shareFieldController;
  final InfiniteScrollController deckScrollController;
  final InfiniteScrollController textFieldScrollController;

  const ShareTextField({
    required this.deckScrollController,
    required this.shareFieldController,
    required this.textFieldScrollController,
    Key? key,
  }) : super(key: key);

  @override
  State<ShareTextField> createState() => _ShareTextFieldState();
}

class _ShareTextFieldState extends State<ShareTextField> {
  @override
  Widget build(BuildContext context) {
    bool reachedCharacterLimit = false;
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state) {
        /* if(state is CardsFailed) {
          return ErrorOutput(message: state.message);
        }*/
        if (state is CardsLoading) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.blue, size: 30),
          );
        }
        if (state is CardsLoaded) {
          Category currentCategory = state.category;
          return BlocBuilder<ResponseBloc, ResponseState>(
            builder: (context, state) {
              if (state is ResponseLoading) {
                return LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.blue, size: 30);
              }
              if (state is ResponseFailed) {
                return const Center(
                  child: Text('Error Fetching Responses!'),
                );
              }
              if (state is ResponseLoaded) {
                List<Response> responses = state.responses!;
                return Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              color: Colors.grey.shade300,
                              spreadRadius: 5),
                        ]),
                    child: InfiniteCarousel.builder(
                      velocityFactor: 0.3,
                      controller: widget.textFieldScrollController,
                      loop: false,
                      itemCount: responses.length,
                      itemExtent: 360,
                      onIndexChanged: (p0) {
                        widget.deckScrollController.animateToItem(p0,
                            curve: Curves.easeOutQuad,
                            duration: const Duration(seconds: 1));
                        context.read<ResponseDeckCubit>().scrollDeck(p0);
                      },
                      itemBuilder: (context, itemIndex, realIndex) {
                        print('Response Count: ${responses.length}');
                        print('Item Index: $itemIndex');
                        print('Real Index: $realIndex');
                        final ScrollController textFieldScrollController =
                            ScrollController();

                        return Container(
                          height: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              BlocBuilder<ResponseDeckCubit, ResponseDeckState>(
                            buildWhen: (previous, current) =>
                                current.status != previous.status,
                            builder: (context, state) {
                              if (state.status == ScrollStatus.scrolled ||
                                  state.status == ScrollStatus.stopped) {
                                if (realIndex - 1 > responses.length) {
                                  widget.shareFieldController.text =
                                      'No Response Submitted Yet!';
                                } else {
                                  String currentResponse = responses
                                      .elementAt((state.index))
                                      .response;
                                  widget.shareFieldController.text =
                                      currentResponse;
                                }
                                return TextField(
                                  controller: widget.shareFieldController,
                                  autofocus: false,
                                  readOnly: true,
                                  textAlignVertical: TextAlignVertical.top,
                                  textAlign: TextAlign.start,
                                  minLines: 4,
                                  maxLines: 4,
                                  decoration: const InputDecoration.collapsed(
                                      hintText: 'Share your response..'),
                                );
                              }
                              widget.shareFieldController.text =
                                  responses[0].response;
                              if (widget.shareFieldController.text.characters
                                      .length >
                                  100) {
                                reachedCharacterLimit = true;
                              }
                              return Scrollbar(
                                radius: const Radius.circular(12.0),
                                controller: textFieldScrollController,
                                thumbVisibility: reachedCharacterLimit,
                                // trackVisibility: reachedCharacterLimit,
                                child: TextField(
                                  onChanged: (value) {},
                                  scrollController: textFieldScrollController,
                                  controller: widget.shareFieldController,
                                  autofocus: false,
                                  readOnly: true,
                                  textAlignVertical: TextAlignVertical.top,
                                  textAlign: TextAlign.start,
                                  minLines: 4,
                                  maxLines: 4,
                                  decoration: const InputDecoration.collapsed(
                                      hintText: 'Share your response..'),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ));
              } else {
                return const Center(
                  child: Text('Someting Went Wrong'),
                );
              }
            },
          );
        }
        return const Center(
          child: Text('Something Went Wrong...'),
        );
      },
    );
  }
}

class SendButton extends StatefulWidget {
  final String categoryName;
  final TextEditingController shareFieldController;

  const SendButton(
      {required this.categoryName,
      required this.shareFieldController,
      Key? key})
      : super(key: key);

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  @override
  Widget build(BuildContext context) {
    int currentCardIndex =
        context.watch<ViewResponseDeckCubit>().currentCardNumber;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(fixedSize: const Size(240, 42)),
      onPressed: () {
        context.read<ShareBloc>().add(SubmitPressed(
            categoryName: widget.categoryName,
            cardNumber: currentCardIndex,
            response: widget.shareFieldController.text));

        if (currentCardIndex == 12) {
          //context.read<ViewResponseDeckCubit>().resetDeck();
          widget.shareFieldController.clear();
          Navigator.pop(context);
        } else {
          context.read<ViewResponseDeckCubit>().incrementCardNumber();

          context.read<ViewResponseDeckCubit>().swipeDeck();
          context.read<ViewResponseDeckCubit>().resetDeck();
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
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state) {
        if (state is CardsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CardsLoaded) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CachedNetworkImage(
                placeholder: (context, url) => Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: Colors.blueAccent, size: 30.0),
                ),
                imageUrl: state.cardImageUrls[cardNumber - 1],
                height: 195,
                fit: BoxFit.fitHeight,
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Something Went Wrong!'),
          );
        }
      },
    );
  }
}
