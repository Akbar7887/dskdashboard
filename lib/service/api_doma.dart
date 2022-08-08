import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/doma.dart';
import 'package:http/http.dart' as http;

import '../ui.dart';

class ApiDoma {
  FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<Doma>> getDoms(String kompleks_id) async {
    String? token = await _storage.read(key: "token");

    Map<String, dynamic> param = {'id': kompleks_id};

    Uri uri = Uri.parse("${Ui.url}les/dom").replace(queryParameters: param);
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.get(uri, headers: hedersWithToken);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      return json.map((e) => Doma.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<Doma> postDom(
      String url, dynamic object, Map<String, dynamic> param) async {
    String? token = await _storage.read(key: "token");

    Uri uri = Uri.parse("${Ui.url}les/${url}").replace(queryParameters: param);
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.post(uri,
        headers: hedersWithToken, body: json.encode(object));

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      return Doma.fromJson(json);
    } else {
      throw Exception("Error");
    }
  }
}
