import 'package:dskdashboard/models/Kompleks.dart';

import '../models/doma.dart';
import '../models/picture_home.dart';

abstract class BlocState {}

class BlocEmtyState extends BlocState {}

class BlocLoadingState extends BlocState {}

class BlocErrorState extends BlocState {}

class KompleksLoadedState extends BlocState {
  List<Kompleks> loadedKomleks;

  KompleksLoadedState({required this.loadedKomleks});
}

class DomaLoadedState extends BlocState {
  List<Doma> loadedDoma;

  DomaLoadedState({required this.loadedDoma});
}


class PictureLoadedState extends BlocState{

  List<PictureHome> loadedPicture;
  PictureLoadedState({required this.loadedPicture});
}