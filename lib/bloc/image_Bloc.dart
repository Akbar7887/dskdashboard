import 'dart:typed_data';

import 'package:dskdashboard/bloc/bloc_state.dart';
import 'package:dskdashboard/models/ImageDom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/repository.dart';

class ImageBloc extends Cubit<BlocState> {
  final Repository repository;

  ImageBloc({required this.repository}) : super(BlocEmtyState());

  Future<List<ImageDom>> getImage(String id) async {
    return await repository.getImage(id);
  }

  Future<dynamic> save(String url, ImageDom imageDom, String dom_id) async{
    return await repository.savewithdom(url, imageDom, dom_id);
  }

  Future<dynamic> putWeb(String url, String id, bool web) async {
    return await repository.postwebImage(url, id, web);
  }

  Future remove(String url, Map<String, dynamic> param) async {
    await repository.deleteAll(url, param);
  }

  Future<dynamic> saveImage(
      String url,  String id, Uint8List data) async {
    return await repository.saveImage(url, id, data);
  }
}
