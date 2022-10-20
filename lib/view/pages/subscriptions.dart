import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/purchases/purchases_bloc.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
            return ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Text(
                    'My Subscriptions',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.black87),
                  ),
                ),
                state.isSubscribed == false || state.isSubscribed == null
                    ? const Center(
                        child: Text('No Subscriptions'),
                      )
                    : const Card(),
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
