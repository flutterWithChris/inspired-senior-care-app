import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String? groupName;
  final String? groupId;
  final List<String>? groupMemberIds;
  final List<String>? groupManagerIds;
  final String? featuredCategory;

  const Group({
    this.groupName,
    this.groupId,
    this.groupMemberIds,
    this.groupManagerIds,
    this.featuredCategory
  });

  Group copyWith({
    String? groupName,
    String? groupId,
    List<String>? groupMemberIds,
    List<String>? groupManagerIds,
    String? featuredCategory,
  }) {
    return Group(
      groupName: groupName ?? this.groupName,
      groupId: groupId ?? this.groupId,
      groupMemberIds: groupMemberIds ?? this.groupMemberIds,
      groupManagerIds: groupManagerIds ?? this.groupManagerIds,
      featuredCategory: featuredCategory ?? this.featuredCategory,
    );
  }

  static Group fromSnapshot(DocumentSnapshot snap) {
    Group group = Group(
        groupName: snap['groupName'],
        groupId: snap['groupId'],
        groupMemberIds: List.from(snap['groupMemberIds']),
        groupManagerIds: List.from(snap['groupManagerIds']),
        featuredCategory: snap['featuredCategory']
        );

    return group;
  }

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'groupId': groupId,
      'groupMemberIds': groupMemberIds,
      'groupManagerIds': groupManagerIds,
      'featuredCategory': featuredCategory,
    };
  }

  static const empty = Group(groupId: '');

  bool get isEmpty => this == Group.empty;
  bool get isNotEmpty => this != Group.empty;
}
