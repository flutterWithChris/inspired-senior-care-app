import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/deck/deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/bloc/purchases/purchases_bloc.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/view/pages/IAP/premium_org_dialog.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';

class ManagerShareDeckPage extends StatefulWidget {
  final Category category;
  const ManagerShareDeckPage({super.key, required this.category});

  @override
  State<ManagerShareDeckPage> createState() => _ManagerShareDeckPageState();
}

class _ManagerShareDeckPageState extends State<ManagerShareDeckPage> {
  bool isSwipeDisabled = true;
  bool isCategoryComplete = false;

  int currentCard = 0;
  InfiniteScrollController deckScrollController = InfiniteScrollController();

  @override
  void initState() {
    // TODO: implement initState
    if (context
            .read<ProfileBloc>()
            .state
            .user
            .currentCard![widget.category.name] ==
        widget.category.totalCards) {
      isSwipeDisabled = false;
      isCategoryComplete = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isCardZoomed = false;
    final InfiniteScrollController deckScrollController =
        InfiniteScrollController();

    final GlobalKey<FormState> shareFieldFormKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BlocConsumer<DeckCubit, DeckState>(
          listener: (context, state) {
            if (state.status == DeckStatus.zoomed) {}
          },
          builder: (context, state) {
            if (state.status == DeckStatus.zoomed) {
              return Visibility(
                visible: false,
                child: AppBar(
                  toolbarHeight: 50,
                  centerTitle: true,
                  title: const Text(''),
                ),
              );
            }
            return BlocConsumer<CardBloc, CardState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is CardsLoaded) {
                  return Visibility(
                    visible: !isCardZoomed,
                    child: Animate(
                      effects: const [SlideEffect(curve: Curves.easeInOutSine)],
                      child: AppBar(
                        toolbarHeight: 50,
                        centerTitle: true,
                        title: Text(state.category.name),
                        backgroundColor: state.category.categoryColor,
                      ),
                    ),
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
            );
          },
        ),
      ),
      bottomNavigationBar: const MainBottomAppBar(),
      body: BlocBuilder<PurchasesBloc, PurchasesState>(
        builder: (context, state) {
          bool? isSubscribed =
              context.watch<PurchasesBloc>().state.isSubscribed;
          //  int currentCard = context.watch<DeckCubit>().currentCardNumber;

          if (state is PurchasesLoading) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.blue, size: 30),
            );
          }
          if (state is PurchasesLoaded) {
            {
              Offerings? offerings = state.offerings;
              // print(offerings?.all.toString());
              bool? isSubscribed = state.isSubscribed;
              return BlocBuilder<CardBloc, CardState>(
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
                    // if (currentCard == state.category.totalCards) {
                    //   isSwipeDisabled = false;
                    // }
                    if (context.read<DeckCubit>().state.status ==
                        DeckStatus.completed) {
                      isCategoryComplete = true;
                      isSwipeDisabled = false;
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => showDialog(
                                context: context,
                                builder: (context) {
                                  return const DeckCompleteDialog();
                                },
                              ));
                    }

                    if (currentCard - 1 >=
                            (widget.category.totalCards! / 2).round() &&
                        (isSubscribed == false || isSubscribed == null)) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => showDialog(
                                // barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return WillPopScope(
                                      onWillPop: () {
                                        Navigator.popUntil(
                                            context,
                                            ModalRoute.withName(
                                                'manager-categories-share'));
                                        return Future.value(false);
                                      },
                                      child:
                                          const PremiumOrganizationOfferDialog());
                                },
                              ));
                    }
                    return Flex(
                      direction: Axis.vertical,
                      children: [
                        Flexible(
                          flex: 6,
                          child: IgnorePointer(
                            ignoring: isCardZoomed == false &&
                                isCategoryComplete == false,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              clipBehavior: Clip.antiAlias,
                              padding: const EdgeInsets.only(top: 40),
                              reverse: true,
                              child: AnimatedSlide(
                                curve: Curves.decelerate,
                                duration: const Duration(milliseconds: 200),
                                offset: isCardZoomed
                                    ? const Offset(0, -0.1)
                                    : const Offset(0, -0.0),
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 250),
                                  scale: isCardZoomed ? 1.1 : 1.0,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      SizedBox(
                                        height: 500,
                                        //  width: 330,
                                        child: IgnorePointer(
                                          ignoring: isSwipeDisabled,
                                          child: BlocListener<DeckCubit,
                                              DeckState>(
                                            listener: (context, state) {
                                              // TODO: implement listener
                                              if (state.status ==
                                                  DeckStatus.completed) {
                                                setState(() {
                                                  isSwipeDisabled = false;
                                                });
                                              }
                                              if (state.status ==
                                                  DeckStatus.zoomed) {
                                                setState(() {
                                                  isCardZoomed = true;
                                                });
                                              } else if (state.status ==
                                                  DeckStatus.unzoomed) {
                                                setState(() {
                                                  isCardZoomed = false;
                                                });
                                              }
                                            },
                                            child: Deck(
                                                deckScrollController:
                                                    deckScrollController),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: isSwipeDisabled ? true : false,
                                        child: Positioned(
                                          right: 24,
                                          top: -12,
                                          child: Animate(
                                            effects: const [
                                              SlideEffect(
                                                  delay: Duration(
                                                      milliseconds: 600),
                                                  duration: Duration(
                                                      milliseconds: 250),
                                                  curve: Curves.easeOutBack,
                                                  begin: Offset(1.5, 0),
                                                  end: Offset(0, 0))
                                            ],
                                            child: CardCounter(
                                                category: widget.category,
                                                deckScrollController:
                                                    deckScrollController),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 100),
                            opacity: isCardZoomed ? 0 : 1.0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, bottom: 24.0),
                              child: ShareButton(
                                  category: state.category,
                                  formKey: shareFieldFormKey,
                                  categoryName: state.category.name),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('Something Went Wrong!'),
                    );
                  }
                },
              );
            }
          } else {
            return const Center(
              child: Text('Something Went Wrong...'),
            );
          }
        },
      ),
    );
  }
}

class CardCounter extends StatefulWidget {
  final Category category;
  final InfiniteScrollController deckScrollController;
  const CardCounter({
    required this.category,
    required this.deckScrollController,
    Key? key,
  }) : super(key: key);

  @override
  State<CardCounter> createState() => _CardCounterState();
}

class _CardCounterState extends State<CardCounter> {
  double percentageComplete = 0.0;
  int currentCard = 0;
  @override
  void initState() {
    super.initState();
    User currentUser = context.read<ProfileBloc>().state.user;
    bool categoryStarted =
        currentUser.currentCard!.containsKey(widget.category.name);
    if (categoryStarted) {
      currentCard = currentUser.currentCard![widget.category.name]!;
      percentageComplete = (currentCard - 1) / widget.category.totalCards!;
    }
  }

  @override
  Widget build(BuildContext context) {
    Category category = widget.category;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              User user = state.user;
              return BlocBuilder<CardBloc, CardState>(
                  builder: (context, state) {
                currentCard = context.watch<DeckCubit>().currentCardNumber;
                if (state is CardsLoaded) {
                  Category currentCategory =
                      context.watch<CardBloc>().state.category!;
                  bool categoryStarted =
                      user.currentCard!.containsKey(currentCategory.name);
                  // * Checking if Category has been started.
                  if (!categoryStarted) {
                    percentageComplete = 0.0;
                    currentCard = 0;
                  }
                  if (categoryStarted) {
                    int currentCard =
                        context.watch<DeckCubit>().currentCardNumber;
                    context.read<DeckCubit>().updateCardNumber(currentCard);
                    if (currentCard < currentCategory.totalCards!) {
                      Future.delayed(const Duration(milliseconds: 500),
                          () async {
                        await widget.deckScrollController
                            .animateToItem(currentCard);
                      });
                      context.read<DeckCubit>().updateCardNumber(currentCard);
                      if (currentCard < currentCategory.totalCards! + 1) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          widget.deckScrollController
                              .animateToItem(currentCard - 1);
                        });
                      } else {
                        context.read<DeckCubit>().completeDeck();
                      }

                      return CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 32,
                        child: Text(
                          '${(currentCard - 1)}/${currentCategory.totalCards}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    } else {
                      return CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 32,
                        child: Text(
                          '0/${currentCategory.totalCards}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    }
                  }
                  return const Text('Something Went Wrong..');
                } else {
                  return const Text('Something Went Wrong..');
                }
              });
            }
            return const Text('?');
          },
        ),
        BlocBuilder<DeckCubit, DeckState>(
          buildWhen: (previous, current) =>
              previous.currentCardNumber != current.currentCardNumber,
          builder: (context, state) {
            return SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                    context.watch<CardBloc>().state.category!.progressColor),
                value: percentageComplete == 0
                    ? 0.0
                    : ((currentCard - 1) / category.totalCards!),
              ),
            );
          },
        )
      ],
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
          return InfiniteCarousel.builder(
            center: true,
            loop: false,
            controller: deckScrollController,
            itemCount: state.cardImageUrls.length,
            itemExtent: 330,
            itemBuilder: (context, itemIndex, realIndex) {
              return InfoCard(
                cardNumber: itemIndex + 1,
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
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Text(
                  'You\'ve completed this category. Be proud of yourself!',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Unlock Deck')),
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
  final Category category;
  final GlobalKey<FormState> formKey;
  final String categoryName;
  final TextEditingController shareFieldController = TextEditingController();

  ShareButton(
      {required this.category,
      required this.categoryName,
      required this.formKey,
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
        context.read<DeckCubit>().zoomDeck();

        // * Shows Bottom Sheet for Response
        var bottomSheet = showBottomSheet(
          backgroundColor: Colors.transparent,
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
                        formKey: formKey,
                        shareFieldController: shareFieldController,
                      ),
                      SendButton(
                        category: category,
                        formKey: formKey,
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
          context.read<DeckCubit>().unzoomDeck();
        });
      },
    );
  }
}

class ViewResponsesButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController shareFieldController = TextEditingController();

  ViewResponsesButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(fixedSize: const Size(200, 36)),
      label: const Text('View Response'),
      icon: const Icon(
        FontAwesomeIcons.eye,
        size: 16,
      ),
      onPressed: () async {
        // * Zoom Deck on Press

        context.read<DeckCubit>().zoomDeck();
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
                        formKey: formKey,
                        shareFieldController: shareFieldController,
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
        await viewResponseBottomSheet.closed.then((value) {
          context.read<DeckCubit>().unzoomDeck();
        });
      },
    );
  }
}

class ShareTextField extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController shareFieldController;

  const ShareTextField({
    required this.formKey,
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
        child: Form(
          key: formKey,
          child: TextFormField(
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
            minLines: 4,
            maxLines: 4,
            decoration: const InputDecoration.collapsed(
                hintText: 'Share your response..'),
          ),
        ),
      ),
    );
  }
}

class SendButton extends StatefulWidget {
  final Category category;
  final GlobalKey<FormState> formKey;
  final String categoryName;
  final TextEditingController shareFieldController;

  const SendButton(
      {required this.category,
      required this.categoryName,
      required this.shareFieldController,
      required this.formKey,
      Key? key})
      : super(key: key);

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  @override
  Widget build(BuildContext context) {
    int currentCard = context.watch<DeckCubit>().currentCardNumber;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(fixedSize: const Size(240, 42)),
      onPressed: () async {
        if (widget.formKey.currentState!.validate()) {
          context.read<ShareBloc>().add(SubmitPressed(
              categoryName: widget.categoryName,
              cardNumber: currentCard,
              response: widget.shareFieldController.text));

          if (currentCard == (widget.category.totalCards! + 1)) {
            //context.read<DeckCubit>().resetDeck();
            widget.shareFieldController.clear();
            Navigator.pop(context);
            context.read<DeckCubit>().completeDeck();
          } else {
            await Future.delayed(const Duration(seconds: 2));
            if (!mounted) return;

            context.read<DeckCubit>().incrementCardNumber(
                context.read<ProfileBloc>().state.user, widget.categoryName);
            context.read<DeckCubit>().swipeDeck();
            context.read<DeckCubit>().resetDeck();
            widget.shareFieldController.clear();

            Navigator.pop(context);
          }
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
                  borderRadius: BorderRadius.circular(25.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Center(
                    child: LoadingAnimationWidget.discreteCircle(
                        color: Colors.blueAccent, size: 30.0),
                  ),
                  imageUrl: state.cardImageUrls[cardNumber - 1],
                  height: 195,
                  fit: BoxFit.fitHeight,
                ),
              ));
        } else {
          return const Center(
            child: Text('Something Went Wrong!'),
          );
        }
      },
    );
  }
}
