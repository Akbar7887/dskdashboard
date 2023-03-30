import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/News.dart';
import '../service/repository.dart';
import 'bloc_event.dart';
import 'bloc_state.dart';

class NewsBloc extends Bloc<BlocEvent, BlocState> {
  final Repository repository;

  NewsBloc({required this.repository}) : super(BlocEmtyState()) {
    on<BlocLoadEvent>((event, emit) async {
      emit(BlocLoadingState());
      try {
        final json = await repository.getall("news/get");

        final loadednews = json.map((e) => News.fromJson(e)).toList();
        emit(NewsLoadedState(loadedNews: loadednews));
      } catch (_) {
        throw Exception(BlocErrorState());
      }
    });

    on<BlocClearEvent>((event, emit) => emit(BlocEmtyState()));
  }
  Future<dynamic> save(String url, dynamic obj) async {
    return await repository.save(url, obj);
  }

  Future<bool> postWeb(String url, String id, Uint8List data) async {
    return await repository.webImage(url, id, data);
  }
  Future<bool> saveVideo(String url, String id, Uint8List data, String filename) async {
    return await repository.saveVideo(url, id, data, filename);
  }

  Future remove(String url, Map<String, dynamic> param) async {
    return await repository.delete(url, param);
  }
}
