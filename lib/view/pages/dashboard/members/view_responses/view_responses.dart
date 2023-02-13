import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/manage/response_interaction_cubit.dart';
import 'package:inspired_senior_care_app/bloc/manage/view_response_deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/bloc/purchases/purchases_bloc.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/bloc/view_response/response_bloc.dart';
import 'package:inspired_senior_care_app/cubits/response/response_deck_cubit.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/view/pages/IAP/premium_individual_dialog.dart';
import 'package:inspired_senior_care_app/view/pages/IAP/premium_org_dialog.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ViewResponses extends StatefulWidget {
  const ViewResponses({super.key});

  @override
  State<ViewResponses> createState() => _ViewResponsesState();
}

class _ViewResponsesState extends State<ViewResponses> {
  bool isSwipeDisabled = false;

  bool isCardZoomed = false;

  final InfiniteScrollController deckScrollController =
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
                        padding: const EdgeInsets.only(top: 24.0),
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
                                        deckScrollController:
                                            deckScrollController),
                                  ),
                                ),
                              ],
                            ),
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

  const Deck({Key? key, required this.deckScrollController}) : super(key: key);

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
          bool? isSubscribed =
              context.watch<PurchasesBloc>().state.isSubscribed;
          return InfiniteCarousel.builder(
            loop: false,
            controller: widget.deckScrollController,
            velocityFactor: 0.23,
            itemCount: context.read<ProfileBloc>().state.user.currentCard?[
                    context.read<CardBloc>().state.category?.name] ??
                1,
            itemExtent: 330,
            onIndexChanged: (p0) {
              /// Prevent user advancing to next card & show dialog if not subscribed
              if (p0 + 1 >= (state.category.totalCards! / 2).round() &&
                  (isSubscribed == false || isSubscribed == null) &&
                  ModalRoute.of(context)!.isCurrent == true) {
                widget.deckScrollController.previousItem();
                WidgetsBinding.instance
                    .addPostFrameCallback((_) async => await showDialog(
                          //   barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return WillPopScope(
                                onWillPop: () {
                                  context.pop();

                                  return Future.value(false);
                                },
                                child: context
                                            .watch<ProfileBloc>()
                                            .state
                                            .user
                                            .type ==
                                        'user'
                                    ? const PremiumIndividualOfferDialog()
                                    : const PremiumOrganizationOfferDialog());
                          },
                        ));
              }
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
                  style: Theme.of(context).textTheme.headlineSmall,
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

  final String categoryName;
  final TextEditingController shareFieldController;

  const ShareButton(
      {required this.deckScrollController,
      required this.categoryName,
      required this.shareFieldController,
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

  final TextEditingController shareFieldController;

  const ViewResponsesButton(
      {required this.deckScrollController,
      required this.shareFieldController,
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
                        deckScrollController: deckScrollController,
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

  const ViewResponsesSheet({required this.deckScrollController, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        height: 210,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              ShareTextField(
                deckScrollController: deckScrollController,
              ),
            ]),
      ),
    );
  }
}

class ShareTextField extends StatefulWidget {
  final InfiniteScrollController deckScrollController;

  const ShareTextField({
    required this.deckScrollController,
    Key? key,
  }) : super(key: key);

  @override
  State<ShareTextField> createState() => _ShareTextFieldState();
}

class _ShareTextFieldState extends State<ShareTextField> {
  final TextEditingController shareFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    widget.deckScrollController.addListener(() {
      context.read<ResponseBloc>().add(FetchResponse(
          user: context.read<MemberBloc>().state.user!,
          category: context.read<CardBloc>().state.category!,
          cardNumber: widget.deckScrollController.selectedItem + 1));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 125, maxHeight: 150),
      decoration: BoxDecoration(
          // border: context.watch<ResponseBloc>().state == ResponseLoading() ||
          //         context.watch<ShareBloc>().state == ShareState.submitting()
          //     ? Border.all(
          //         color: Colors.lightBlue.shade300.withOpacity(0.8),
          //         width: 3,
          //       )
          //     : null,
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                blurRadius: 10, color: Colors.grey.shade300, spreadRadius: 5),
          ]),
      child: Container(
        //  height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          //   color: const Color.fromARGB(255, 202, 105, 105),
          borderRadius: BorderRadius.circular(10),
        ),
        child: BlocBuilder<ResponseBloc, ResponseState>(
          builder: (context, state) {
            if (state is ResponseFailed) {
              return const Center(child: Text('Error Fetching Response'));
            }
            if (state is ResponseLoading ||
                context.watch<ShareBloc>().state == ShareState.submitting()) {
              return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.blue, size: 20));
            }
            if (state is ResponseLoaded) {
              /// Set Share Field to Response if it exists
              /// Else set it to empty string
              if (state.response != null) {
                shareFieldController.text = state.response!;
              } else {
                shareFieldController.clear();
                //    shareFieldController.text = 'No Response Submitted!';
              }
              return TextFormField(
                readOnly: true,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a response!';
                  } else {
                    return null;
                  }
                },
                controller: shareFieldController,
                autofocus: true,
                textAlignVertical: TextAlignVertical.top,
                textAlign: TextAlign.start,
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration.collapsed(
                    hintText:
                        state.response == null ? 'No Response Submitted!' : ''),
              );
            }
            return LoadingAnimationWidget.inkDrop(
                color: Colors.blue, size: 20.0);
          },
        ),
      ),
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
          return SizedBox(
            width: 330,
            child: Card(
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
