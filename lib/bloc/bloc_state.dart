import 'package:dskdashboard/models/Kompleks.dart';
import 'package:dskdashboard/models/News.dart';

import '../models/ImageDom.dart';
import '../models/Job.dart';
import '../models/Make.dart';
import '../models/Meneger.dart';

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

class MakeLoadedState extends BlocState {
  List<Make> loadedMake;

  MakeLoadedState({required this.loadedMake});
}

class MenegerLoadedState extends BlocState {
  List<Meneger> loadedMeneger;

  MenegerLoadedState({required this.loadedMeneger});
}

class NewsLoadedState extends BlocState {
  List<News> loadedNews;

  NewsLoadedState({required this.loadedNews});
}

class JobLoadedState extends BlocState {
  List<Job> loadedJob;

  JobLoadedState({required this.loadedJob});
}