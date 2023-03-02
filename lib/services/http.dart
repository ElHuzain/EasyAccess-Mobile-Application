import 'dart:convert';
import 'package:http/http.dart' as http;

class Http {
  static String baseUrl = "http://192.168.1.6:3030";
  static dynamic client = http.Client();

  static Future<dynamic> get(String api) async {
    var url = Uri.parse(baseUrl + api);

    try {
      var response = await client.get(url);
      print(response);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Exception.");
      }
    } catch (err) {
      print(err);
    }
  }

  static Future<dynamic> post(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    try {
      var response = await client.post(url, body: object);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(response.body);
      }
    } catch (err) {
      print(err);
      // return "fail";
    }
  }
}
