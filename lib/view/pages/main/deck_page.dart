import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/deck/deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/bloc/purchases/purchases_bloc.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

class DeckPage extends StatefulWidget {
  final Category category;
  const DeckPage({super.key, required this.category});

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  bool isSwipeDisabled = true;
  bool isCategoryComplete = false;
  bool isCardZoomed = false;
  int currentCard = 0;
  bool? isSubscribed;
  InfiniteScrollController deckScrollController = InfiniteScrollController();

  @override
  void initState() {
    // TODO: implement initState
    if (context
            .read<ProfileBloc>()
            .state
            .user
            .currentCard![widget.category.name] ==
        widget.category.totalCards! + 1) {
      isSwipeDisabled = false;
      isCategoryComplete = true;
    }
    currentCard = context
            .read<ProfileBloc>()
            .state
            .user
            .currentCard![widget.category.name] ??
        0;
    isSubscribed = context.read<PurchasesBloc>().state.isSubscribed;
    print('Init Is Subscribed: $isSubscribed');
    print('Init Current Card Is: $currentCard');
    // if (currentCard >= (widget.category.totalCards! / 2).round() &&
    //     (isSubscribed == false || isSubscribed == null)) {
    //   print('Is Subscribed: $isSubscribed');
    //   WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
    //         barrierDismissible: false,
    //         context: context,
    //         builder: (context) {
    //           return WillPopScope(
    //               onWillPop: () {
    //                 context.read<ProfileBloc>().state.user.type == 'user'
    //                     ? Navigator.popUntil(
    //                         context, ModalRoute.withName('categories'))
    //                     : Navigator.popUntil(context,
    //                         ModalRoute.withName('manager-categories-share'));

    //                 return Future.value(false);
    //               },
    //               child: context.read<ProfileBloc>().state.user.type == 'user'
    //                   ? const PremiumIndividualOfferDialog()
    //                   : const PremiumOrganizationOfferDialog());
    //         },
    //       ));
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        effects: const [
                          SlideEffect(curve: Curves.easeInOutSine)
                        ],
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
          print('Card Number: $currentCard');

          if (state is PurchasesLoading) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.blue, size: 30),
            );
          }
          if (state is PurchasesLoaded) {
            Offerings? offerings = state.offerings;
            // print(offerings?.all.toString());
            bool? isSubscribed =
                context.watch<PurchasesBloc>().state.isSubscribed;

            return BlocBuilder<CardBloc, CardState>(builder: (context, state) {
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
                if (currentCard == state.category.totalCards) {
                  //   isSwipeDisabled = false;
                  // }
                  if (context.read<DeckCubit>().state.status ==
                      DeckStatus.completed) {
                    isCategoryComplete = true;
                    isSwipeDisabled = false;
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) async => await showDialog(
                              context: context,
                              builder: (context) {
                                return const DeckCompleteDialog();
                              },
                            ));
                  }
                }
                // print(
                //     'Condition 1: ${currentCard >= (widget.category.totalCards! / 2).round()}');
                // print(
                //     'Condition 2: ${(isSubscribed == false || isSubscribed == null)}');
                if (currentCard >= (widget.category.totalCards! / 2).round() &&
                    (isSubscribed == false || isSubscribed == null)) {
                  print('Satisfied Conditions***');
                  print('Is Subscribed: $isSubscribed');
                  print('Current Card Is: $currentCard');
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) async => await showDialog(
                            barrierDismissible: false,
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

                return Flex(
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 4,
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 36.0),
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
                                      child: BlocListener<DeckCubit, DeckState>(
                                        listener: (context, state) {
                                          // TODO: implement listener
                                          if (state.status ==
                                              DeckStatus.completed) {
                                            isSwipeDisabled = false;
                                          }
                                          if (state.status ==
                                              DeckStatus.zoomed) {
                                            isCardZoomed = true;
                                          } else if (state.status ==
                                              DeckStatus.unzoomed) {
                                            isCardZoomed = false;
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
                                      right: 20,
                                      top: -20,
                                      child: CardCounter(
                                          deckScrollController:
                                              deckScrollController),
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
                          padding:
                              const EdgeInsets.only(top: 24.0, bottom: 24.0),
                          child: Visibility(
                            visible: isSwipeDisabled ? true : false,
                            child: ShareButton(
                                category: state.category,
                                formKey: shareFieldFormKey,
                                categoryName: state.category.name),
                          ),
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
            });
          } else {
            return const Center(
              child: Text('Somehting Went Wrong...'),
            );
          }
        }));
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
    double progress = 0.0;
    int currentCard = context.watch<DeckCubit>().currentCardNumber;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            double percentComplete = 0.0;
            if (state is ProfileLoaded) {
              User user = state.user;
              return BlocBuilder<CardBloc, CardState>(
                builder: (context, state) {
                  if (state is CardsLoaded) {
                    Category currentCategory = state.category;
                    bool categoryStarted =
                        user.currentCard!.containsKey(currentCategory.name);
                    percentComplete =
                        (currentCard) / state.cardImageUrls.length;
                    if (categoryStarted) {
                      Map<String, int> progressList =
                          context.watch<ProfileBloc>().state.user.currentCard!;
                    }
                    // Checking if Category has been started.
                    if (!categoryStarted) {
                      percentComplete = 0.0;
                      progress = 0.0;
                    }
                    if (categoryStarted) {
                      progress =
                          (((currentCard - 1) / currentCategory.totalCards!) *
                              100);
                      Map<String, int> progressList = user.currentCard!;
                      currentCard = progressList[currentCategory.name]!;
                      context.read<DeckCubit>().updateCardNumber(currentCard);
                      print(
                          '$currentCard is the current card & progress is: ${(percentComplete * 100)}');

                      if (currentCard < currentCategory.totalCards! + 1) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          deckScrollController.animateToItem(currentCard - 1);
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
                },
              );
            }
            return const Text('?');
          },
        ),
        BlocBuilder<CardBloc, CardState>(
          builder: (context, state) {
            if (state is CardsLoaded) {
              //int currentCard = context.watch<DeckCubit>().currentCardNumber;
              double percentageComplete =
                  ((currentCard - 1) / state.cardImageUrls.length);
              return SizedBox(
                height: 60,
                width: 60,
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

class Deck extends StatelessWidget {
  final InfiniteScrollController deckScrollController;
  const Deck({
    Key? key,
    required this.deckScrollController,
  }) : super(key: key);

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
            //anchor: -20.0,
            // physics: const PageScrollPhysics(),
            center: true,
            loop: false,
            controller: deckScrollController,
            velocityFactor: 0.3,
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

class PremiumIndividualOfferDialog extends StatefulWidget {
  const PremiumIndividualOfferDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<PremiumIndividualOfferDialog> createState() =>
      _PremiumOfferDialogState();
}

double borderTopOffset = 65;

class _PremiumOfferDialogState extends State<PremiumIndividualOfferDialog> {
  String? selectedOffer;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchasesBloc, PurchasesState>(
      listener: (context, state) {
        if (state is PurchasesUpdated) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is PurchasesLoading) {
          return LoadingAnimationWidget.inkDrop(color: Colors.blue, size: 30.0);
        }
        if (state is PurchasesLoaded) {
          List<Package?> packages = [];

          return Dialog(
            backgroundColor: Colors.grey.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
              child: BlocBuilder<PurchasesBloc, PurchasesState>(
                builder: (context, state) {
                  if (state is PurchasesLoading) {
                    return LoadingAnimationWidget.inkDrop(
                        color: Colors.blue, size: 30.0);
                  }
                  if (state is PurchasesLoaded) {
                    if (context.watch<ProfileBloc>().state.user.type ==
                        'user') {
                      packages.addAll([
                        state.offerings
                            ?.getOffering('subscriptions')!
                            .getPackage('Individual (Monthly)'),
                        state.offerings
                            ?.getOffering('subscriptions')!
                            .getPackage('Individual (Yearly)'),
                      ]);
                      print('Got ${packages.length} Offerings');
                    } else if (context.watch<ProfileBloc>().state.user.type ==
                        'manager') {
                      packages.addAll([
                        state.offerings
                            ?.getOffering('subscriptions')!
                            .getPackage('Organization (Monthly)'),
                        state.offerings
                            ?.getOffering('subscriptions')!
                            .getPackage('Organization (Annual)')
                      ]);
                    }

                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 8.0),
                            child: Text(
                              'Upgrade To Keep Going!',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          SizedBox(
                              width: 325,
                              height: 150,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: IndividualOfferCard(
                                  packages: packages,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24.0, right: 24.0, bottom: 8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Package? package = context
                                      .read<PurchasesBloc>()
                                      .selectedPackage;

                                  context.read<PurchasesBloc>().add(AddPurchase(
                                      package: package ?? packages[0]!));

                                  // Navigator.pop(context);
                                },
                                child: const Text('Subscribe')),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'Subscribe & instantly gain access to the rest of the cards!',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ]),
                        Positioned(
                          top: -25,
                          right: -5,
                          child: SizedBox(
                            height: 40,
                            child: CloseButton(
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('Something Went Wrong...'),
                    );
                  }
                },
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Something Went Wrong...'),
          );
        }
      },
    );
  }
}

class PremiumOrganizationOfferDialog extends StatefulWidget {
  const PremiumOrganizationOfferDialog({
    Key? key,
  }) : super(key: key);
  @override
  State<PremiumOrganizationOfferDialog> createState() =>
      _PremiumOrganizationOfferDialogState();
}

class _PremiumOrganizationOfferDialogState
    extends State<PremiumOrganizationOfferDialog> {
  String? selectedOffer;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchasesBloc, PurchasesState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is PurchasesLoading) {
          return LoadingAnimationWidget.inkDrop(color: Colors.blue, size: 30.0);
        }
        if (state is PurchasesLoaded) {
          List<Package?> packages = [];
          return Dialog(
            backgroundColor: Colors.grey.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
              child: BlocBuilder<PurchasesBloc, PurchasesState>(
                builder: (context, state) {
                  if (state is PurchasesLoading) {
                    return LoadingAnimationWidget.inkDrop(
                        color: Colors.blue, size: 30.0);
                  }
                  if (state is PurchasesLoaded) {
                    if (context.watch<ProfileBloc>().state.user.type ==
                        'user') {
                      packages.addAll([
                        state.offerings
                            ?.getOffering('subscriptions')!
                            .getPackage('Individual (Monthly)'),
                        state.offerings
                            ?.getOffering('subscriptions')!
                            .getPackage('Individual (Yearly)'),
                      ]);
                      print('Got ${packages.length} Offerings');
                    } else if (context.watch<ProfileBloc>().state.user.type ==
                        'manager') {
                      packages.addAll([
                        state.offerings
                            ?.getOffering('subscriptions')!
                            .getPackage('Organization (Monthly)'),
                        state.offerings
                            ?.getOffering('subscriptions')!
                            .getPackage('Organization (Annual)')
                      ]);
                    }
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 8.0),
                            child: Text(
                              'Upgrade Organization!',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          SizedBox(
                              width: 325,
                              height: 160,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: OrganizationOfferCard(
                                  packages: packages,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24.0, right: 24.0, bottom: 8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Package? package = context
                                      .read<PurchasesBloc>()
                                      .selectedPackage;
                                  context.read<PurchasesBloc>().add(AddPurchase(
                                      package: package ?? packages[0]!));
                                  // Navigator.pop(context);
                                },
                                child: const Text('Subscribe')),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'Subscribe & instantly gain access to the rest of the cards!',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ]),
                        Positioned(
                          top: -25,
                          right: -5,
                          child: SizedBox(
                            height: 40,
                            child: CloseButton(
                              onPressed: () {
                                context.pop();
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('Something Went Wrong...'),
                    );
                  }
                },
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Something Went Wrong...'),
          );
        }
      },
    );
  }
}

int selectedOffer = 0;
String? selectedTerm;

class IndividualOfferCard extends StatefulWidget {
  final List<Package?> packages;
  const IndividualOfferCard({super.key, required this.packages});

  @override
  State<IndividualOfferCard> createState() => _IndividualOfferCardState();
}

List<String> menuItemList = ['Monthly', 'Yearly'];

class _IndividualOfferCardState extends State<IndividualOfferCard> {
  String dropdownValue = menuItemList.first;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchasesBloc, PurchasesState>(
      builder: (context, state) {
        if (state is PurchasesLoading) {
          return LoadingAnimationWidget.inkDrop(color: Colors.blue, size: 30.0);
        }
        if (state is PurchasesLoaded) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 140,
              width: 280,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 1.618,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Individual',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (dropdownValue == 'Monthly')
                                Text(
                                  '${widget.packages[0]?.storeProduct.priceString}/mo.',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              if (dropdownValue == 'Yearly')
                                Text(
                                  '${widget.packages[1]?.storeProduct.priceString}/yr.',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.orange.shade800,
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                          )),
                      subtitle: const Text(
                          'Unlock access to all cards & categories.'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton<String>(
                            isDense: true,
                            underline: const SizedBox(),
                            borderRadius: BorderRadius.circular(20),
                            value: dropdownValue,
                            items: menuItemList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Chip(
                                    padding: const EdgeInsets.all(4.0),
                                    backgroundColor: Colors.blueAccent,
                                    visualDensity: VisualDensity.compact,
                                    label: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        )),
                                  ));
                            }).toList(),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                              if (dropdownValue == 'Monthly') {
                                context.read<PurchasesBloc>().add(SelectPackage(
                                    package: widget.packages[0]!));
                                print('Monthly Selected');
                              } else if (dropdownValue == 'Yearly') {
                                context.read<PurchasesBloc>().add(SelectPackage(
                                    package: widget.packages[1]!));
                                print('Yearly Selected');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]);
        } else {
          return const Center(
            child: Text('Something Went Wrong..'),
          );
        }
      },
    );
  }
}

class OrganizationOfferCard extends StatefulWidget {
  final List<Package?> packages;
  const OrganizationOfferCard({super.key, required this.packages});

  @override
  State<OrganizationOfferCard> createState() => _OrganizationOfferCardState();
}

List<String> menuItemList2 = ['Monthly', 'Yearly'];

class _OrganizationOfferCardState extends State<OrganizationOfferCard> {
  String dropdownValue = menuItemList.first;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchasesBloc, PurchasesState>(
      builder: (context, state) {
        if (state is PurchasesLoading) {
          return LoadingAnimationWidget.inkDrop(color: Colors.blue, size: 30.0);
        }
        if (state is PurchasesLoaded) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 145,
              width: 280,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 1.618,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Organization',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (dropdownValue == 'Monthly')
                                Text(
                                  '${widget.packages[0]?.storeProduct.priceString}/mo.',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              if (dropdownValue == 'Yearly')
                                Text(
                                  '${widget.packages[1]?.storeProduct.priceString}/yr.',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.orange.shade800,
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                          )),
                      subtitle: const Text(
                          'Unlock full access for you & all group members.'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0, bottom: 8.0, top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton<String>(
                            isDense: true,
                            underline: const SizedBox(),
                            borderRadius: BorderRadius.circular(20),
                            value: dropdownValue,
                            items: menuItemList2
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Chip(
                                    padding: const EdgeInsets.all(4.0),
                                    backgroundColor: Colors.blueAccent,
                                    visualDensity: VisualDensity.compact,
                                    label: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        )),
                                  ));
                            }).toList(),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                              if (dropdownValue == 'Monthly') {
                                context.read<PurchasesBloc>().add(SelectPackage(
                                    package: widget.packages[0]!));
                                print('Monthly Selected');
                              } else if (dropdownValue == 'Yearly') {
                                context.read<PurchasesBloc>().add(SelectPackage(
                                    package: widget.packages[1]!));
                                print('Yearly Selected');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]);
        } else {
          return const Center(
            child: Text('Something Went Wrong..'),
          );
        }
      },
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
        var deckCubit = context.read<DeckCubit>();
        deckCubit.zoomDeck();
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
          deckCubit.unzoomDeck();
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
        viewResponseBottomSheet.closed.then((value) {
          deckCubit.unzoomDeck();
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: CachedNetworkImage(
                placeholder: (context, url) => Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: Colors.blueAccent, size: 30.0),
                ),
                imageUrl: state.cardImageUrls[cardNumber - 1],
                // height: 195,
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
