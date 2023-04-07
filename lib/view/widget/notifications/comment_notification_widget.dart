import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/data/models/comment_notification.dart';

import '../../../bloc/comment_notifications/comment_notification_bloc.dart';

class CommentNotificationWidget extends StatelessWidget {
  final CommentNotification commentNotification;
  const CommentNotificationWidget(
      {super.key, required this.commentNotification});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '${commentNotification.senderName} ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const TextSpan(text: 'commented on your response!'),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${commentNotification.categoryName} - Card #${commentNotification.cardNumber}',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: FilledButton(
                  onPressed: () {
                    context.read<CommentNotificationBloc>().add(
                          ClickCommentNotification(
                              commentNotification: commentNotification,
                              userId: commentNotification.receiverId,
                              context: context),
                        );
                  },
                  child: const Text('View Comment')),
            ),
          ],
        ),
      ),
    );
  }
}
