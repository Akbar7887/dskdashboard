import 'package:dskdashboard/bloc/job_bloc.dart';
import 'package:dskdashboard/bloc/meneger_Bloc.dart';
import 'package:dskdashboard/bloc/make_bloc.dart';
import 'package:dskdashboard/bloc/news_bloc.dart';
import 'package:dskdashboard/pages/first_page.dart';
import 'package:dskdashboard/pages/home.dart';
import 'package:dskdashboard/service/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';

import 'bloc/bloc_event.dart';
import 'bloc/image_Bloc.dart';
import 'bloc/kompleks_bloc.dart';

void main() {
  runApp(const MyApp());
}

MaterialColor primaryColorShades = MaterialColor(
  0xFF49494F,
  <int, Color>{
    50: Color(0xFF49494F),
    100: Color(0xFF49494F),
    200: Color(0xFF49494F),
    300: Color(0xFF49494F),
    400: Color(0xFF49494F),
    500: Color(0xFF49494F),
    600: Color(0xFF49494F),
    700: Color(0xFF49494F),
    800: Color(0xFF49494F),
    900: Color(0xFF49494F),
  },
);


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                //fontFamily://
                primarySwatch: primaryColorShades,
              ),
              // home: FirstPage(),
              initialRoute: "/",
              routes: {
                '/home': (context) => Home(),
                '/': (context) => FirstPage(),
              },
            );
  }
}
