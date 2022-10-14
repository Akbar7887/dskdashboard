import 'package:dskdashboard/models/Kompleks.dart';
import 'package:dskdashboard/models/picture_home.dart';
import 'package:dskdashboard/service/api.dart';
import 'package:dskdashboard/service/api_doma.dart';

import '../models/doma.dart';

class Repository {
  final Api api = Api();
  final ApiDoma apiDoma = ApiDoma();

  Future<List<dynamic>> getall(String url) => api.getAll(url);

  Future<bool> login(String user, String passwor) => api.login(user, passwor);

  Future delete(String url, Map<String, dynamic> param) =>
      api.delete(url, param);

  Future<dynamic> save(String url, dynamic object) => api.save(url, object);

  Future<List<Doma>> getDom(String komleks_id) => apiDoma.getDoms(komleks_id);

  Future<dynamic> savedom(
          String url, dynamic object, Map<String, dynamic> param) =>
      apiDoma.postDom(url, object, param);

  Future<List<PictureHome>> getImage(String id) => api.getPicture(id);

  Future<PictureHome> webImage(String url, bool web, String id) =>
      api.webImage(url, web, id);
}
