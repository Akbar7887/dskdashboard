import 'package:dskdashboard/pages/first_page.dart';
import 'package:dskdashboard/pages/home.dart';
import 'package:dskdashboard/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'controller/Controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // setPathUrlStrategy();

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

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Ui.company,
      theme: ThemeData(
        backgroundColor: Colors.black,
        bottomAppBarColor: Colors.black,
        textTheme: TextTheme(),
        // fontFamily: Ui.font,
        // textTheme: TextTheme(bodyText1: ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //primarySwatch: Colors.black87,
      ),
      initialRoute: '/',
      initialBinding: HomeBindings(),
      getPages: [
        GetPage(name: '/home', page: () => Home()),
        GetPage(name: '/', page: () => FirstPage()),
        // GetPage(name: '/kompleksdetails', page: () => KompleksDetailesPage()),
      ],
    );
  }
}
