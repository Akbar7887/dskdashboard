import 'dart:io';
import 'dart:typed_data';

import 'package:dskdashboard/models/Dom.dart';
import 'package:dskdashboard/models/ImageDom.dart';
import 'package:dskdashboard/models/ImageNews.dart';
import 'package:dskdashboard/models/Job.dart';
import 'package:dskdashboard/models/Joblist.dart';
import 'package:dskdashboard/models/Kompleks.dart';
import 'package:dskdashboard/models/Meneger.dart';
import 'package:dskdashboard/models/News.dart';
import 'package:get/get.dart';
import '../models/Catalog.dart';
import '../models/Make.dart';
import 'ApiConnector.dart';

class Controller extends GetxController {
  final _api = ApiConnector();
  RxList<Catalog> catalogs = <Catalog>[].obs;
  Rx<Catalog> catalog = Catalog().obs;
  RxList<Dom> doms = <Dom>[].obs;
  Rx<Dom> dom = Dom().obs;
  RxList<ImageDom> imagedoms = <ImageDom>[].obs;
  Rx<ImageDom> imagedom = ImageDom().obs;
  RxList<Job> jobs = <Job>[].obs;
  Rx<Job> job = Job().obs;
  RxList<Joblist> joslists = <Joblist>[].obs;
  Rx<Joblist> joslist = Joblist().obs;
  RxList<Kompleks> komplekses = <Kompleks>[].obs;
  Rx<Kompleks> kompleks = Kompleks().obs;
  RxList<Make> makes = <Make>[].obs;
  Rx<Make> make = Make().obs;
  RxList<Meneger> menegers = <Meneger>[].obs;
  Rx<Meneger> meneger = Meneger().obs;
  RxList<News> newses = <News>[].obs;
  Rx<News> news = News().obs;

  @override
  onInit() {
    fetchAll("kompleks/get", Kompleks());
    super.onInit();
  }

  Future<bool> login(String username, String password) async {
    return await _api.login(username, password);
  }

  Future<dynamic> save(String url, dynamic object) async {
    return await _api.save(url, object);
  }

  fetchAll(String url, dynamic obj) {
    return _api.getAll(url).then((value) {
      if (obj is Kompleks) {
        komplekses.value = value.map((e) => Kompleks.fromJson(e)).toList();
      }
    });
  }

  Future<bool> deletebyId(String url, String id) async {
    return await _api.deletebyId(url, id);
  }

  Future<bool> postImageKompleks(
      String url, String id, List<File?> data) {
    return _api.postImageKompleks(url, id, data);
  }

  Future<bool> removeById(String url, String id) async {
    return await _api.removeByid(url, id);
  }

  Future<bool> removeImage(String url, String id, String filename) async {
    return await _api.removeImage(url, id, filename);
  }
}

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Controller>(() => Controller());
  }
}
