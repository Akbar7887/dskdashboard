import 'package:dskdashboard/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/doma.dart';
import '../service/repository.dart';

class DomaBloc extends Cubit<BlocState> {
  final Repository repository;

  DomaBloc({required this.repository}) : super(BlocEmtyState()) {}

  Future<List<Doma>> getDoma(String komleks_id) async {
    return await repository.getDom(komleks_id);
  }

  Future<dynamic> save(String url, dynamic object, Map<String, dynamic> param) {
    return repository.savedom(url, object, param);
  }

  Future remove(String url, Map<String, dynamic> param) {
    return repository.delete(url, param);
  }
}
