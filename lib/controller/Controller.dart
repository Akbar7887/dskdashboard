import 'dart:typed_data';

import 'package:dskdashboard/models/Dom.dart';
import 'package:dskdashboard/models/Events.dart';
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
  RxList<ImageNews> imageNewses = <ImageNews>[].obs;
  Rx<ImageNews> imageNews = ImageNews().obs;
  RxList<Events> eventslist = <Events>[].obs;
  Rx<Events> events = Events().obs;

  @override
  onInit() {
    fetchAll("kompleks/v1/get", Kompleks());
    fetchAll("make/v1/get", Make()).then((value) {
      if (makes.length != 0) {
        make.value = makes.value.first;
      }
    });
    fetchAll("meneger/v1/get", Meneger());
    fetchAll("job/v1/get", Job());
    fetchAll("news/v1/get", News());
    fetchAll("event/v1/get", Events());
    super.onInit();
  }

  Future<bool> login(String username, String password) async {
    return await _api.login(username, password);
  }

  Future<dynamic> save(String url, dynamic object) async {
    return await _api.save(url, object);
  }

  Future<dynamic> saveWithParentId(
      String url, dynamic object, String id) async {
    return await _api.saveWithParentId(url, object, id);
  }

  Future<List<dynamic>> getById(String url, String id) {
    return _api.getById(url, id);
  }

  Future<void> fetchAll(String url, dynamic obj) {
    return _api.getAll(url).then((value) {
      if (obj is Kompleks) {
        komplekses.value = value.map((e) => Kompleks.fromJson(e)).toList();
        if (komplekses.length != 0) {
          kompleks.value = komplekses.value.first;
          if (kompleks.value.domSet!.length != 0) {
            kompleks.value.domSet?.sort((a, b) => a.id!.compareTo(b.id!));
            doms.value = kompleks.value.domSet!;
            if (doms.length != 0) {
              dom.value = doms.value.first;
              if (dom.value.imagedom!.length != 0) {
                imagedoms.value = dom.value.imagedom!;
                if (imagedoms.value.length != 0) {
                  imagedom.value = imagedoms.value.first;
                }
              }
            }
          }
        }
      }
      if (obj is Dom) {
        doms.value = value.map((e) => Dom.fromJson(e)).toList();
        doms.value.sort((a,b) => a.id!.compareTo(b.id!));

      }
      if (obj is Make) {
        makes.value = value.map((e) => Make.fromJson(e)).toList();
        makes.value.sort((a,b) => a.id!.compareTo(b.id!));

      }
      if (obj is Meneger) {
        menegers.value = value.map((e) => Meneger.fromJson(e)).toList();
        if (menegers.value.length != 0) {
          meneger.value = menegers.value.first;
        }
        menegers.value.sort((a,b) => a.id!.compareTo(b.id!));

      }
      if(obj is Job){
        jobs.value = value.map((e) => Job.fromJson(e)).toList();
        if(jobs.value.length != 0){
          job.value = jobs.value.first;
        }
        jobs.value.sort((a,b) => a.id!.compareTo(b.id!));
      }
      if(obj is News){
        newses.value = value.map((e) => News.fromJson(e)).toList();
        newses.value.sort((a,b) => a.id!.compareTo(b.id!));
        if(newses.value.length != 0){
          news.value = newses.value.first;
          if(news.value.imageNewsList!.length != 0){
            imageNews.value = news.value.imageNewsList!.first;
            imageNewses.value = news.value.imageNewsList!;
            imageNewses.value.sort((a,b) => a.id!.compareTo(b.id!));
          }
        }
      }
      if(obj is Events){
        eventslist.value = value.map((e) => Events.fromJson(e)).toList();
        if(jobs.value.length != 0){
          events.value = eventslist.value.first;
        }
        eventslist.value.sort((a,b) => a.id!.compareTo(b.id!));
      }
    });
  }

  Future<dynamic> saveVideo(String url, String id , Uint8List? object, String videoname) async {
    return await _api.saveVideo(url, id, object, videoname);
  }

  Future<dynamic> postWebImage(
      String url, String nameparam, String id, bool web) {
    return _api.postWebImage(url, nameparam, id, web);
  }

  Future<dynamic> postImage(String url, String id, Uint8List data) {
    return _api.postImage(url, id, data);
  }

  Future<bool> deletebyId(String url, String id) async {
    return await _api.deletebyId(url, id);
  }

  Future<bool> postImageKompleks(
      String url, String id, List<Uint8List?> data, String filename) {
    return _api.postImageKompleks(url, id, data, filename);
  }

  Future<bool> postImageList(
      String url, String id, List<Uint8List?> data) {
    return _api.postImageList(url, id, data);
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
