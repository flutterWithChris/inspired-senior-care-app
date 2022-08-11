import 'package:cloud_firestore/cloud_firestore.dart';

class Response {
  final String response;

  Response({
    required this.response,
  });

  static Response fromSnapshot(DocumentSnapshot snap, int cardNumber) {
    Response response = Response(
      response: snap[cardNumber.toString()],
    );
    print('${snap.get(cardNumber.toString())}: fetched');
    return response;
  }
}
