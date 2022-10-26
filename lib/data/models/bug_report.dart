import 'package:cloud_firestore/cloud_firestore.dart';

class BugReport {
  String report;
  String deviceType;
  String userId;
  String userEmail;
  String userName;
  BugReport(
      {required this.report,
      required this.deviceType,
      required this.userId,
      required this.userEmail,
      required this.userName});

  BugReport copyWith({
    String? report,
    String? deviceType,
    String? userId,
    String? userEmail,
    String? userName,
  }) {
    return BugReport(
        report: report ?? this.report,
        deviceType: deviceType ?? this.deviceType,
        userId: userId ?? this.userId,
        userEmail: userEmail ?? this.userEmail,
        userName: userName ?? this.userName);
  }

  Map<String, dynamic> toMap() {
    return {
      'report': report,
      'deviceType': deviceType,
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
    };
  }

  factory BugReport.fromDocument(DocumentSnapshot snapshot) {
    return BugReport(
      report: snapshot['report'],
      deviceType: snapshot['deviceType'],
      userId: snapshot['userId'],
      userEmail: snapshot['userEmail'],
      userName: snapshot['userName'],
    );
  }
}
