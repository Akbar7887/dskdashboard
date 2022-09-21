import 'dart:ui';

import 'package:dskdashboard/bloc/bloc_event.dart';
import 'package:dskdashboard/bloc/bloc_state.dart';
import 'package:dskdashboard/models/picture_home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/repository.dart';

class ImageBloc extends Cubit<BlocState>{

  final Repository repository;

  ImageBloc({required this.repository}) : super(BlocEmtyState());

  Future<List<PictureHome>> getImage(String id)  async {
   return await repository.getImage(id);
  }

  Future<PictureHome> putWeb(String url, bool web, String id) async{
    return await repository.webImage(url, web, id);
  }
}