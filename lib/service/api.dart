import 'dart:convert';
import 'package:dskdashboard/models/picture_home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../ui.dart';

class Api {
  String? token;
  FlutterSecureStorage _storage = FlutterSecureStorage();

  // Map<String, String> header = {
  //   'Content-Type': 'application/json',
  //
  //   // 'Access-Control-Allow-Origin': '*',
  //   // 'Access-Control-Allow-Credentials': 'true',
  //   // 'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  //   // 'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept'
  // };
  Future<List<dynamic>> getAll(String url) async {
    token = await _storage.read(key: "token");
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    Uri uri = Uri.parse("${Ui.url}${url}");
    final response = await http.get(uri, headers: hedersWithToken);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      return json; //json.map((e) => Catalog.fromJson(e)).toList();
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
      await _storage.write(key: 'token', value: l['access_token']);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> delete(String url, Map<String, dynamic> param) async {
    String? token = await _storage.read(key: "token");

    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: param);
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.put(uri, headers: hedersWithToken);

    if (response.statusCode == 200) {
      // final dynamic json = jsonDecode(utf8.decode(response.bodyBytes));

      return true;
    } else {
      throw Exception("Error");
    }
  }

Future<bool> save(String url, dynamic object) async {
  String? token = await _storage.read(key: "token");

  Uri uri = Uri.parse("${Ui.url}${url}");
  Map<String, String> hedersWithToken = {
    "Content-type": "application/json",
    "Authorization": "Bearer $token"
  };
  final response = await http.post(uri,
      headers: hedersWithToken, body: json.encode(object));

  if (response.statusCode == 200) {
    // final dynamic json = jsonDecode(utf8.decode(response.bodyBytes));

    return true;
  } else {
    throw Exception("Error");
  }
}

Future<List<PictureHome>> getPicture(String id) async {
  String? token = await _storage.read(key: "token");
  Map<String, dynamic> parm = {'id': id};

  Uri uri = Uri.parse("${Ui.url}les/imageall").replace(queryParameters: parm);
  Map<String, String> hedersWithToken = {
    "Content-type": "application/json",
    "Authorization": "Bearer $token"
  };
  final response = await http.get(uri, headers: hedersWithToken);

  if (response.statusCode == 200) {
    final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

    return json.map((e) => PictureHome.fromJson(e)).toList();
  } else {
    throw Exception("Error");
  }
}

Future<PictureHome> webImage(String url, bool web, String id) async {
  Map<String, dynamic> param = {"web": web.toString(), "id": id};

  String? token = await _storage.read(key: "token");

  Uri uri = Uri.parse("${Ui.url}les/${url}").replace(queryParameters: param);
  Map<String, String> hedersWithToken = {
    "Content-type": "application/json",
    "Authorization": "Bearer $token"
  };
  final response = await http.put(uri, headers: hedersWithToken);

  if (response.statusCode == 200) {
    final dynamic json = jsonDecode(utf8.decode(response.bodyBytes));

    return PictureHome.fromJson(json);
  } else {
    throw Exception("Error");
  }


}
}
