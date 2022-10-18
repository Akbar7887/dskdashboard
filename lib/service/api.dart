import 'dart:convert';
import 'dart:typed_data';
import 'package:dskdashboard/models/ImageData.dart';
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

  Future<dynamic> save(String url, dynamic object) async {
    String? token = await _storage.read(key: "token");

    Uri uri = Uri.parse("${Ui.url}${url}");
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.post(uri,
        headers: hedersWithToken, body: json.encode(object));

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Error");
    }
  }

  Future<List<ImageDom>> getPicture(String id) async {
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

      return json.map((e) => ImageDom.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<bool> postImage(String url, String id, Uint8List data) async {
    token = await _storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    List<int> list = data;
    final uri = Uri.parse('${Ui.url}${url}');
    var request = await http.MultipartRequest('POST', uri);
    request.fields['id'] = id;

    request.headers.addAll(hedersWithToken);
    request.files
        .add(http.MultipartFile.fromBytes("file", list, filename: ('$id.png')));
    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> postWebImage(String url, String id, bool web) async {
    String? token = await _storage.read(key: "token");

    Map<String, String> param = {"web": web.toString(), "id": id};

    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: param);
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.put(uri, headers: hedersWithToken);

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Error");
    }
  }

  Future<bool> deleteAll(String url, Map<String, dynamic> param) async {
    String? token = await _storage.read(key: "token");

    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: param);
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.delete(uri, headers: hedersWithToken);

    if (response.statusCode == 200) {
      // final dynamic json = jsonDecode(utf8.decode(response.bodyBytes));

      return true;
    } else {
      throw Exception("Error");
    }
  }

  Future<dynamic> saveImage(String url, String id, String name, Uint8List data) async {
    token = await _storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    List<int> list = data;
    final uri = Uri.parse('${Ui.url}${url}');
    var request = await http.MultipartRequest('POST', uri);
    request.fields['dom_id'] = id;
    request.fields['name'] = name;

    request.headers.addAll(hedersWithToken);
    request.files
        .add(http.MultipartFile.fromBytes("file", list, filename: ('$id.png')));
    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
