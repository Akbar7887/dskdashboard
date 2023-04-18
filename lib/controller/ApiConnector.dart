import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/ImageDom.dart';
import '../ui.dart';

class ApiConnector extends GetConnect {
  String? token;
  FlutterSecureStorage _storage = FlutterSecureStorage();
  Map<String, String> header = {
    'Content-Type': 'application/json; charset=utf-8',
    // 'charset': 'utf-8',
    // 'Accept': 'application/json',
  };

  Future<List<dynamic>> getAll(String url) async {
    token = await _storage.read(key: "token");
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    Uri uri = Uri.parse("${Ui.url}${url}");
    final response = await http.get(uri, headers: hedersWithToken);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(
          response.bodyBytes)); //json.map((e) => Catalog.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<List<dynamic>> getById(String url, String id) async {
    token = await _storage.read(key: "token");
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    Map<String, dynamic> parm = {'id': id};

    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: parm);
    final response = await http.get(uri, headers: hedersWithToken);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(
          response.bodyBytes)); //json.map((e) => Catalog.fromJson(e)).toList();
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

  Future<dynamic> save(String url, dynamic object) async {
    String? token = await _storage.read(key: "token");

    Uri uri = Uri.parse("${Ui.url}${url}");
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.post(uri,
        headers: hedersWithToken, body: jsonEncode(object));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Error");
    }
  }

  Future<dynamic> saveWithDom(String url, dynamic object, String dom_id) async {
    String? token = await _storage.read(key: "token");
    Map<String, dynamic> parm = {'dom_id': dom_id};

    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: parm);
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.post(uri,
        headers: hedersWithToken, body: jsonEncode(object));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Error");
    }
  }

  Future<dynamic> saveWithParentId(String url, dynamic object, String id) async {
    String? token = await _storage.read(key: "token");
    Map<String, dynamic> parm = {'id': id};

    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: parm);
    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.post(uri,
        headers: hedersWithToken, body: jsonEncode(object));
    if (response.statusCode == 200 || response.statusCode == 201) {
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

  Future<bool> postImageKompleks(
      String url, String id, List<Uint8List?> data, String filename) async {
    token = await _storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    final uri = Uri.parse('${Ui.url}${url}');
    var request = await http.MultipartRequest('POST', uri);
    request.fields['id'] = id;
    // request.fields['filename'] = filename;

    request.headers.addAll(hedersWithToken);

    if (data[0] != null) {
      request.files.add(await http.MultipartFile.fromBytes("file", data[0]!,
          filename: filename));
    }
    if (data[1] != null) {
      request.files.add(await http.MultipartFile.fromBytes("file", data[1]!,
          filename: filename));
    }
    if (data[2] != null) {
      request.files.add(await http.MultipartFile.fromBytes("file", data[2]!,
          filename: filename));
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postImageList(
      String url, String id, List<Uint8List?> datas, String filename) async {
    token = await _storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    final uri = Uri.parse('${Ui.url}${url}');
    var request = await http.MultipartRequest('POST', uri);
    request.fields['id'] = id;
    // request.fields['filename'] = filename;

    request.headers.addAll(hedersWithToken);

    datas.forEach((element) async{
      request.files.add(await http.MultipartFile.fromBytes("file", element!,
          filename: filename));
    });


    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> postWebImage(
      String url, String nameparam, String id, bool web) async {
    String? token = await _storage.read(key: "token");

    Map<String, String> param = {nameparam: web.toString(), "id": id};

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

  Future<bool> deletebyId(String url, String id) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: {"id": id});

    final response = await http.delete(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw false;
    }
  }

  Future<dynamic> saveImage(String url, String id, Uint8List data) async {
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

  Future<dynamic> saveVideo(String url, String id, Uint8List data) async {
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
        .add(http.MultipartFile.fromBytes("file", list, ));

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeByid(String url, String id) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: {"id": id});

    final response = await http.put(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Error");
    }
  }

  Future<bool> removeImage(String url, String id, String filename) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Uri uri = Uri.parse("${Ui.url}${url}")
        .replace(queryParameters: {"filename": filename, "id": id});

    final response = await http.put(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw false;
    }
  }
}
