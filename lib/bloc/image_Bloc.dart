import 'dart:ui';

import 'package:dskdashboard/bloc/bloc_event.dart';
import 'package:dskdashboard/bloc/bloc_state.dart';
import 'package:dskdashboard/models/ImageData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/repository.dart';

class ImageBloc extends Cubit<BlocState>{

  final Repository repository;

  ImageBloc({required this.repository}) : super(BlocEmtyState());

  Future<List<ImageDom>> getImage(String id)  async {
   return await repository.getImage(id);
  }

  // Future<PictureHome> putWeb(String url, String id) async{
  //   return await repository.webImage(url,  id);
  // }
}