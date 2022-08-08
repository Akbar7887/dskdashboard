import 'dart:convert';

import 'package:dskdashboard/models/Kompleks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../ui.dart';

class Api {
  FlutterSecureStorage _storage = FlutterSecureStorage();

  // Map<String, String> header = {
  //   'Content-Type': 'application/json',
  //
  //   // 'Access-Control-Allow-Origin': '*',
  //   // 'Access-Control-Allow-Credentials': 'true',
  //   // 'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  //   // 'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept'
  // };

  Future<List<Kompleks>> getKompleks() async {
    String? token = await _storage.read(key: "token");

    Uri uri = Uri.parse("${Ui.url}les/kompleks");
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.get(uri, headers: hedersWithToken);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      return json.map((e) => Kompleks.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<bool> login(String user, String passwor) async {
    Map<String, String> data = {'username': user, 'password': passwor};
    Map<String, String> header1 = {
      "Content-Type": "application/x-www-form-urlencoded", //
      // "Authorization": "Bearer $token",
    };

    // final uri = Uri.parse();
    final uri = Uri.parse('${Ui.url}login');
    var response = await http.post(uri,
        body: data, headers: header1, encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> l = jsonDecode(utf8.decode(response.bodyBytes));
      _storage.write(key: 'token', value: l['access_token']);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> delete(String url, Map<String, dynamic> param) async {
    String? token = await _storage.read(key: "token");

    Uri uri = Uri.parse("${Ui.url}les/${url}").replace(queryParameters: param);
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response =
        await http.post(uri, headers: hedersWithToken);

    if (response.statusCode == 200) {
      // final dynamic json = jsonDecode(utf8.decode(response.bodyBytes));

      return true;
    } else {
      throw Exception("Error");
    }
  }

  Future<bool> post(String url, dynamic object) async {
    String? token = await _storage.read(key: "token");

    Uri uri = Uri.parse("${Ui.url}les/${url}");
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response =
    await http.post(uri, headers: hedersWithToken, body: json.encode(object));

    if (response.statusCode == 200) {
      // final dynamic json = jsonDecode(utf8.decode(response.bodyBytes));

      return true;
    } else {
      throw Exception("Error");
    }
  }


}
