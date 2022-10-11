import 'package:cloud_firestore/cloud_firestore.dart';

class Invite {
  final String? inviteId;
  final String groupId;
  final String groupName;
  final String inviterId;
  final String invitedUserId;
  final String status;
  final String inviteType;
  final String inviterName;
  Invite({
    this.inviteId,
    required this.groupName,
    required this.groupId,
    required this.inviterName,
    required this.inviterId,
    required this.invitedUserId,
    required this.inviteType,
    required this.status,
  });

  Invite copyWith({
    String? inviteId,
    String? groupId,
    String? groupName,
    String? inviterId,
    String? inviterName,
    String? inviteType,
    String? invitedUserId,
    String? status,
  }) {
    return Invite(
      inviteId: inviteId ?? this.inviteId,
      inviterName: inviterName ?? this.inviterName,
      groupName: groupName ?? this.groupName,
      groupId: groupId ?? this.groupId,
      inviterId: inviterId ?? this.inviterId,
      inviteType: inviteType ?? this.inviteType,
      invitedUserId: invitedUserId ?? this.invitedUserId,
      status: status ?? this.status,
    );
  }

  static Invite fromSnapshot(DocumentSnapshot snap) {
    Invite invite = Invite(
      inviteId: snap.id,
      groupName: snap['groupName'],
      groupId: snap['groupId'],
      inviterId: snap['inviterId'],
      inviterName: snap['inviterName'],
      invitedUserId: snap['invitedUserId'],
      inviteType: snap['inviteType'],
      status: snap['status'],
    );

    return invite;
  }

  Map<String, dynamic> toMap() {
    return {
      'inviteId': inviteId,
      'groupName': groupName,
      'groupId': groupId,
      'inviterId': inviterId,
      'inviterName': inviterName,
      'inviteType': inviteType,
      'invitedUserId': invitedUserId,
      'status': status,
    };
  }
}
