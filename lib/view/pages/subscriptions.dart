import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/purchases/purchases_bloc.dart';
import 'package:inspired_senior_care_app/globals.dart';
import 'package:inspired_senior_care_app/view/pages/main/deck_page.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/entitlement_info_wrapper.dart';

import '../../bloc/profile/profile_bloc.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: MainTopAppBar()),
      bottomNavigationBar: const MainBottomAppBar(),
      body: BlocBuilder<PurchasesBloc, PurchasesState>(
        builder: (context, state) {
          if (state is PurchasesLoading) {
            return LoadingAnimationWidget.inkDrop(
                color: Colors.blue, size: 30.0);
          }
          if (state is PurchasesLoaded) {
            CustomerInfo? customerInfo =
                context.watch<PurchasesBloc>().state.customerInfo;
            print(
                'Subscriptions ${customerInfo?.allPurchasedProductIdentifiers}');
            return ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 16.0, bottom: 16.0),
                  child: Text(
                    'My Subscriptions',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.black87),
                  ),
                ),
                if (customerInfo?.allPurchasedProductIdentifiers.isNotEmpty ==
                    true)
                  for (EntitlementInfo entitlementInfo
                      in customerInfo!.entitlements.active.values)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 175,
                          width: 300,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Created On: ${DateTime.parse(entitlementInfo.originalPurchaseDate).month}-${DateTime.parse(entitlementInfo.originalPurchaseDate).day}-${DateTime.parse(entitlementInfo.originalPurchaseDate).year}',
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        'Expires On: ${DateTime.parse(entitlementInfo.expirationDate!).month}-${DateTime.parse(entitlementInfo.expirationDate!).day}-${DateTime.parse(entitlementInfo.expirationDate!).year}',
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        capitalizeAllWord(entitlementInfo
                                            .productIdentifier
                                            .replaceAll('_', ' ')),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(fontSize: 18),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            state.products!
                                                .firstWhere((element) =>
                                                    element.identifier ==
                                                    entitlementInfo
                                                        .productIdentifier)
                                                .priceString
                                                .capitalize(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(fontSize: 16),
                                          ),
                                          entitlementInfo.isActive
                                              ? Wrap(
                                                  spacing: 7.0,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                      CircleAvatar(
                                                        radius: 3,
                                                        backgroundColor: Colors
                                                            .green.shade400,
                                                      ),
                                                      const Text(
                                                        'Active',
                                                      )
                                                    ])
                                              : Wrap(
                                                  spacing: 7.0,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: const [
                                                      CircleAvatar(
                                                        radius: 3,
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                      Text(
                                                        'Inactive',
                                                      )
                                                    ]),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      entitlementInfo.willRenew
                                          ? const Text.rich(
                                              TextSpan(children: [
                                                TextSpan(text: 'Will Renew:  '),
                                                TextSpan(
                                                    text: 'Yes',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ]),
                                            )
                                          : const Text.rich(
                                              TextSpan(children: [
                                                TextSpan(text: 'Will Renew:  '),
                                                TextSpan(
                                                    text: 'No',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ]),
                                            )
                                    ],
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () {},
                                      child: const Text('Cancel Subscription'))
                                ],
                              ),
                            ),
                          )),
                    ),
                if (state.isSubscribed == false)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 150,
                        width: 300,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('No Active Subscriptions'),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          if (context
                                                  .read<ProfileBloc>()
                                                  .state
                                                  .user
                                                  .type ==
                                              'user') {
                                            return const PremiumIndividualOfferDialog();
                                          } else {
                                            return const PremiumOrganizationOfferDialog();
                                          }
                                        },
                                      );
                                    },
                                    child: const Text('Subscribe Now'))
                              ]),
                        )),
                  )
              ],
            );
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
