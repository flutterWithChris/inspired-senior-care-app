import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/purchases/purchases_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

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
          context.pop();
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
                    packages.addAll([
                      state.offerings
                          ?.getOffering('subscriptions')!
                          .getPackage('Individual (Monthly)'),
                      state.offerings
                          ?.getOffering('subscriptions')!
                          .getPackage('Individual (Yearly)'),
                    ]);

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
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          SizedBox(
                              width: 325,
                              height: 160,
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
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 8.0),
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: InkWell(
                                customBorder: const StadiumBorder(),
                                radius: 30,
                                onTap: () => Navigator.pop(context),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.black45,
                                  radius: 16,
                                  child: Icon(Icons.close),
                                ),
                              ),
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
  void initState() {
    context
        .read<PurchasesBloc>()
        .add(SelectPackage(package: widget.packages[0]!));
    super.initState();
  }

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
                              } else if (dropdownValue == 'Yearly') {
                                context.read<PurchasesBloc>().add(SelectPackage(
                                    package: widget.packages[1]!));
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
