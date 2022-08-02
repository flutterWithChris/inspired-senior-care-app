import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:inspired_senior_care_app/bloc/view_response/view_response_cubit.dart';

// * Takes in two infinite scroll controllers & links their scroll position.
// * ScrollLinkMode controls the 'order' of the scroll.

enum ScrollLinkMode { onPrimary, onSecondary, synced }

class LinkedInfiniteScrollControllers extends StatefulWidget {
  final InfiniteScrollController primaryController;
  final InfiniteScrollController secondaryController;
  final ScrollLinkMode scrollLinkMode;

  const LinkedInfiniteScrollControllers(
      {required this.primaryController,
      required this.secondaryController,
      required this.scrollLinkMode,
      Key? key})
      : super(key: key);

  @override
  State<LinkedInfiniteScrollControllers> createState() =>
      _LinkedInfiniteScrollControllersState();
}

class _LinkedInfiniteScrollControllersState
    extends State<LinkedInfiniteScrollControllers> {
  @override
  LinkedInfiniteScrollControllers get widget => super.widget;
  @override
  void initState() {
    InfiniteScrollController primary = widget.primaryController;
    InfiniteScrollController secondary = widget.secondaryController;
    ScrollLinkMode mode = widget.scrollLinkMode;
    ViewResponseCubit viewResponseCubit = ViewResponseCubit();
    int currentPositionIndex = 0;

    switch (mode) {
      case ScrollLinkMode.onPrimary:
        {
          primary.addListener(() {
            currentPositionIndex = primary.selectedItem;
            setState(() {
              secondary.animateToItem(currentPositionIndex);
            });
          });
        }
        break;

      case ScrollLinkMode.onSecondary:
        {
          secondary.addListener(() {
            primary.animateToItem(secondary.selectedItem);
          });
          break;
        }

      case ScrollLinkMode.synced:
        {
          primary.addListener(() {
            secondary.animateToItem(primary.selectedItem);
          });
          secondary.addListener(() {
            primary.animateToItem(secondary.selectedItem);
          });
          break;
        }

      default:
        {
          primary.addListener(() {
            secondary.animateToItem(primary.selectedItem);
          });
          secondary.addListener(() {
            primary.animateToItem(secondary.selectedItem);
          });
        }
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
