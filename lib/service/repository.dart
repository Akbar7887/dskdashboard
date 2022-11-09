import 'dart:typed_data';

import 'package:dskdashboard/models/ImageDom.dart';
import 'package:dskdashboard/service/api.dart';

class Repository {
  final Api api = Api();

  Future<List<dynamic>> getall(String url) => api.getAll(url);

  Future<bool> login(String user, String passwor) => api.login(user, passwor);

  Future delete(String url, Map<String, dynamic> param) =>
      api.delete(url, param);

  Future deleteAll(String url, Map<String, dynamic> param) =>
      api.deleteAll(url, param);

  Future<dynamic> save(String url, dynamic object) => api.save(url, object);

  Future<dynamic> savewithdom(String url, dynamic object, String dom_id) => api.saveWithDom(url, object, dom_id);

  Future<List<ImageDom>> getImage(String id) => api.getPicture(id);

  Future<bool> webImage(String url, String id, Uint8List data) =>
      api.postImage(url, id, data);

  Future<dynamic> postwebImage(String url,String nameparam, String id, bool web) async {
    return await api.postWebImage(url, nameparam, id, web);
  }

  Future<dynamic> saveImage(
      String url, String id, Uint8List data) async {
    return await api.saveImage(url, id, data);
  }

}
