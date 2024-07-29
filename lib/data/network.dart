import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
  final String url;
  Network(this.url);

  Future<dynamic> getJsonData() async {
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      String jsonData = response.body;
      var parsingData = jsonDecode(jsonData);
      return parsingData;
    }
  }
}
