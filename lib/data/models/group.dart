import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String? groupName;
  final String? groupId;
  final List<String>? groupMemberIds;
  final List<String>? groupManagerIds;

  const Group({
    this.groupName,
    this.groupId,
    this.groupMemberIds,
    this.groupManagerIds,
  });

  Group copyWith({
    String? groupName,
    String? groupId,
    List<String>? groupMemberIds,
    List<String>? groupManagerIds,
  }) {
    return Group(
      groupName: groupName ?? this.groupName,
      groupId: groupId ?? this.groupId,
      groupMemberIds: groupMemberIds ?? this.groupMemberIds,
      groupManagerIds: groupManagerIds ?? this.groupManagerIds,
    );
  }

  static Group fromSnapshot(DocumentSnapshot snap) {
    Group user = Group(
        groupName: snap['groupName'],
        groupId: snap['groupId'],
        groupMemberIds: snap['groupMemberIds'],
        groupManagerIds: snap['groupManagerIds']);

    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'groupId': groupId,
      'groupMemberIds': groupMemberIds,
      'groupManagerIds': groupManagerIds,
    };
  }

  static const empty = Group(groupId: '');

  bool get isEmpty => this == Group.empty;
  bool get isNotEmpty => this != Group.empty;
}
