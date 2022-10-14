import 'dart:typed_data';

import 'package:dskdashboard/models/picture_home.dart';
import 'package:dskdashboard/service/api.dart';

class Repository {
  final Api api = Api();


  Future<List<dynamic>> getall(String url) => api.getAll(url);

  Future<bool> login(String user, String passwor) => api.login(user, passwor);

  Future delete(String url, Map<String, dynamic> param) =>
      api.delete(url, param);

  Future<dynamic> save(String url, dynamic object) => api.save(url, object);


  Future<List<PictureHome>> getImage(String id) => api.getPicture(id);

  Future<bool> webImage(String url, String id, Uint8List data) =>
      api.postImage(url, id, data);
}
