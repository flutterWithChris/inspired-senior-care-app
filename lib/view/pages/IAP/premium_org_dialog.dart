import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/bloc/purchases/purchases_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

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
        if (state is PurchasesFailed) {
          return Dialog(
            child: SizedBox(
                height: 150,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 60.0,
                    ),
                    Text(
                      'Error fetching subscription status!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ))),
          );
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
                    return Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                        child: Text(
                          'Upgrade Organization!',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      SizedBox(
                          width: 325,
                          height: 160,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: OrganizationOfferCard(
                              packages: packages,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24.0, bottom: 8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Package? package =
                                  context.read<PurchasesBloc>().selectedPackage;
                              context.read<PurchasesBloc>().add(AddPurchase(
                                  package: package ?? packages[0]!));
                              // Navigator.pop(context);
                            },
                            child: const Text('Subscribe')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Subscribe & instantly gain access to the rest of the cards!',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]);
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

class OrganizationOfferCard extends StatefulWidget {
  final List<Package?> packages;
  const OrganizationOfferCard({super.key, required this.packages});

  @override
  State<OrganizationOfferCard> createState() => _OrganizationOfferCardState();
}

List<String> menuItemList2 = ['Monthly', 'Yearly'];

class _OrganizationOfferCardState extends State<OrganizationOfferCard> {
  String dropdownValue = menuItemList2.first;

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
