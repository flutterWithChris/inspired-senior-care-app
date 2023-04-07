import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/deck/deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/comment_notification.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/notifications/comment_notification_repository.dart';

part 'comment_notification_event.dart';
part 'comment_notification_state.dart';

class CommentNotificationBloc
    extends Bloc<CommentNotificationEvent, CommentNotificationState> {
  final CommentNotificationRepository _commentNotificationRepository;
  final DatabaseRepository _databaseRepository;
  final ProfileBloc _profileBloc;
  StreamSubscription? _profileBlocStream;
  final CardBloc _cardBloc;
  final DeckCubit _deckCubit;
  List<CommentNotification> commentNotificationsList = [];
  Stream<List<CommentNotification>>? commentNotifications;
  StreamSubscription? commentNotificationsStream;
  CommentNotificationBloc(
      {required CommentNotificationRepository commentNotificationRepository,
      required DatabaseRepository databaseRepository,
      required CardBloc cardBloc,
      required ProfileBloc profileBloc,
      required DeckCubit deckCubit})
      : _commentNotificationRepository = commentNotificationRepository,
        _databaseRepository = databaseRepository,
        _cardBloc = cardBloc,
        _deckCubit = deckCubit,
        _profileBloc = profileBloc,
        super(CommentNotificationInitial()) {
    _profileBlocStream = _profileBloc.stream.listen((state) {
      if (state is ProfileLoaded) {
        commentNotificationsList = [];
        commentNotificationsStream = commentNotificationRepository
            .getCommentNotifications(state.user.id!)
            .listen((event) {
          print('Getting comment notifications...');

          if (!listEquals(commentNotificationsList, event)) {
            print('List not equal, adding to list');
            for (final CommentNotification commentNotification in event) {
              if (!commentNotificationsList.contains(commentNotification)) {
                commentNotificationsList.add(commentNotification);
              }
            }
          }
          add(LoadCommentNotifications(userId: state.user.id!));
        });
      } else if (state is ProfileFailed) {
        commentNotificationsStream?.cancel();
      }
    });

    on<LoadCommentNotifications>((event, emit) async {
      emit(CommentNotificationLoading());
      commentNotificationsList = [];
      commentNotificationsStream = commentNotificationRepository
          .getCommentNotifications(event.userId)
          .listen((event) {
        print('Getting comment notifications...');

        if (!listEquals(commentNotificationsList, event)) {
          print('List not equal, adding to list');
          for (final CommentNotification commentNotification in event) {
            if (!commentNotificationsList.contains(commentNotification)) {
              commentNotificationsList.add(commentNotification);
            }
          }
        }
      });

      print('Loading comment notifications...');
      Future.delayed(const Duration(seconds: 2));
      emit(CommentNotificationLoaded(
          commentNotifications: commentNotificationsList));
    });
    on<ClickCommentNotification>((event, emit) async {
      Category category = await _databaseRepository
          .getCategoryFuture(event.commentNotification.categoryName);
      emit(CommentNotificationClicked());
      print('category: ${category.name}');
      _cardBloc.add(LoadCards(category: category));
      _deckCubit.loadDeck(category, event.commentNotification.cardNumber);
      event.context.go('/categories/deck-page', extra: category);
      await Future.delayed(const Duration(seconds: 2));
      add(LoadCommentNotifications(userId: event.userId));
    });
  }
}
