import 'package:dskdashboard/bloc/bloc_event.dart';
import 'package:dskdashboard/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/Job.dart';
import '../service/repository.dart';

class JobBloc extends Bloc<BlocEvent, BlocState> {
  final Repository repository;

  JobBloc({required this.repository}) : super(BlocEmtyState()) {
    on<BlocLoadEvent>((event, emit) async {
      emit(BlocLoadingState());
      try {
        final json = await repository.getall("job/get");

        final loadedjob = json.map((e) => Job.fromJson(e)).toList();
        emit(JobLoadedState(loadedJob: loadedjob));
      } catch (_) {
        throw Exception(BlocErrorState());
      }
    });

    on<BlocClearEvent>((event, emit) => emit(BlocEmtyState()));
  }

  Future<dynamic> save(String url, dynamic obj) async {
    return await repository.save(url, obj);
  }

  Future remove(String url, Map<String, dynamic> param) async {
    return await repository.delete(url, param);
  }

}
