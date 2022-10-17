import 'package:dskdashboard/models/Kompleks.dart';

import '../models/ImageData.dart';

abstract class BlocState {}

class BlocEmtyState extends BlocState {}

class BlocLoadingState extends BlocState {}

class BlocErrorState extends BlocState {}

class KompleksLoadedState extends BlocState {
  List<Kompleks> loadedKomleks;

  KompleksLoadedState({required this.loadedKomleks});
}

class PictureLoadedState extends BlocState{

  List<ImageDom> loadedPicture;
  PictureLoadedState({required this.loadedPicture});
}