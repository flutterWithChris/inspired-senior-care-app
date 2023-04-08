import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
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
  final AuthBloc _authBloc;
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
      required AuthBloc authBloc,
      required DeckCubit deckCubit})
      : _commentNotificationRepository = commentNotificationRepository,
        _databaseRepository = databaseRepository,
        _cardBloc = cardBloc,
        _deckCubit = deckCubit,
        _profileBloc = profileBloc,
        _authBloc = authBloc,
        super(CommentNotificationInitial()) {
    _authBloc.stream.listen((state) {
      if (state.authStatus == AuthStatus.authenticated && state.user != null) {
        add(LoadCommentNotifications(userId: state.user!.uid));
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
        if (!listEquals(commentNotificationsList, event)) {
          for (final CommentNotification commentNotification in event) {
            if (!commentNotificationsList.contains(commentNotification)) {
              commentNotificationsList.add(commentNotification);
            }
          }
        }
      });

      await Future.delayed(const Duration(seconds: 1));
      emit(CommentNotificationLoaded(
          commentNotifications: commentNotificationsList));
    });
    on<ClickCommentNotification>((event, emit) async {
      Category category = await _databaseRepository
          .getCategoryFuture(event.commentNotification.categoryName);
      emit(CommentNotificationClicked());
      _cardBloc.add(LoadCards(category: category));
      _deckCubit.loadDeck(category, event.commentNotification.cardNumber);
      await _commentNotificationRepository
          .deleteComment(event.commentNotification);
      event.context.go('/categories/deck-page', extra: category);
      await Future.delayed(const Duration(seconds: 2));
      add(LoadCommentNotifications(userId: event.userId));
    });
  }
}
