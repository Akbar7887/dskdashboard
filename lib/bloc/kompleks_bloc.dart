import 'package:dskdashboard/bloc/bloc_state.dart';
import 'package:dskdashboard/service/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/Kompleks.dart';
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

  Future remove(String url, Map<String, dynamic> param) {
    return repository.delete(url, param);
  }

  Future<dynamic> save(String url, dynamic object) {
    return repository.save(url, object);
  }
}
