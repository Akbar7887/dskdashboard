import 'package:dskdashboard/bloc/bloc_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/Make.dart';
import '../service/repository.dart';
import 'bloc_state.dart';

class MakeBloc extends Bloc<BlocEvent, BlocState> {
  final Repository repository;

  MakeBloc({required this.repository}) : super(BlocEmtyState()) {
    on<BlocLoadEvent>((event, emit) async {
      emit(BlocLoadingState());
      try {
        final json = await repository.getall("make/get");

        final loadedMake = json.map((e) => Make.fromJson(e)).toList();
        emit(MakeLoadedState(loadedMake: loadedMake));
      } catch (_) {
        throw Exception(BlocErrorState());
      }
    });

    on<BlocClearEvent>((event, emit) => emit(BlocEmtyState()));
  }
}
