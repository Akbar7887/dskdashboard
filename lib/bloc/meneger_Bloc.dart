import 'dart:typed_data';

import 'package:dskdashboard/bloc/bloc_event.dart';
import 'package:dskdashboard/models/Meneger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/repository.dart';
import 'bloc_state.dart';

class MenegerBloc extends Bloc<BlocEvent, BlocState> {
  final Repository repository;

  MenegerBloc({required this.repository}) : super(BlocEmtyState()) {
    on<BlocLoadEvent>((event, emit) async {
      emit(BlocLoadingState());
      try {
        final json = await repository.getall("meneger/get");

        final loadedMeneger = json.map((e) => Meneger.fromJson(e)).toList();
        emit(MenegerLoadedState(loadedMeneger: loadedMeneger));
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

  Future remove(String url, Map<String, dynamic> param) async {
    return await repository.delete(url, param);
  }
}
