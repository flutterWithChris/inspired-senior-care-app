import 'package:cloud_firestore/cloud_firestore.dart';

class BugReport {
  String report;
  String deviceType;
  String userId;
  String userEmail;
  BugReport({
    required this.report,
    required this.deviceType,
    required this.userId,
    required this.userEmail,
  });

  BugReport copyWith({
    String? report,
    String? deviceType,
    String? userId,
    String? userEmail,
  }) {
    return BugReport(
      report: report ?? this.report,
      deviceType: deviceType ?? this.deviceType,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'report': report,
      'deviceType': deviceType,
      'userId': userId,
      'userEmail': userEmail,
    };
  }

  factory BugReport.fromDocument(DocumentSnapshot snapshot) {
    return BugReport(
      report: snapshot['report'],
      deviceType: snapshot['deviceType'],
      userId: snapshot['userId'],
      userEmail: snapshot['userEmail'],
    );
  }
}
