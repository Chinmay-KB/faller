import 'dart:convert';
import 'package:faller/creds.dart';
import 'package:http/http.dart' as http;

class FcmPush {
  static Future<bool> postRequest() async {
    // todo - fix baseUrl
    var url = 'https://fcm.googleapis.com/fcm/send';
    var body = json.encode({
      "to": "/topics/faller",
      "priority": "high",
      "data": {"title": "Title", "body": "Body", "priority": "high"},
    });

    print('Body: $body');

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'key=${Credentials.SERVER_KEY}'
      },
      body: body,
    );

    // todo - handle non-200 status code, etc
    return response.statusCode == 200;
  }
}
