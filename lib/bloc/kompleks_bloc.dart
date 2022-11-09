import 'dart:typed_data';

import 'package:dskdashboard/bloc/bloc_state.dart';
import 'package:dskdashboard/service/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/Kompleks.dart';
import '../models/ImageDom.dart';
import 'bloc_event.dart';

class KompleksBloc extends Bloc<BlocEvent, BlocState> {
  final Repository repository;

  KompleksBloc({required this.repository}) : super(BlocEmtyState()) {
    on<BlocLoadEvent>((event, emit) async {
      emit(BlocLoadingState());
      try {
        final json = await repository.getall("kompleks/get");
        final loadedHouse = json.map((e) => Kompleks.fromJson(e)).toList();
        emit(KompleksLoadedState(loadedKomleks: loadedHouse));
      } catch (e) {
        emit(BlocErrorState());
      }
    });

    on<BlocClearEvent>((event, emit) async {
      emit(BlocEmtyState());
    });
  }

  // Future<List<Kompleks>> getKompleks() async {
  //   return await repository.getKompleks();
  // }

  Future remove(String url, Map<String, dynamic> param) async {
    return await repository.delete(url, param);
  }

  Future<Kompleks> save(String url, dynamic object) async {
    dynamic json = await repository.save(url, object);
    Kompleks kompleks = Kompleks.fromJson(json);
    return kompleks;
  }

  Future<bool> postWeb(String url, String id, Uint8List data) async {
    return await repository.webImage(url, id, data);
  }
}
