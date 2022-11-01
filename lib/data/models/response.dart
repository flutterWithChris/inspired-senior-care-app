import 'package:cloud_firestore/cloud_firestore.dart';

class Response {
  final String response;

  Response({
    required this.response,
  });

  static Response fromSnapshot(
      DocumentSnapshot snap, final int responseNumber) {
    Response response = Response(response: snap.get(responseNumber.toString()));
    return response;
  }
}
