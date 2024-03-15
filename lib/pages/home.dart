import 'package:dskdashboard/controller/Controller.dart';
import 'package:dskdashboard/pages/event_page.dart';
import 'package:dskdashboard/pages/image_page.dart';
import 'package:dskdashboard/pages/komleks_page.dart';
import 'package:dskdashboard/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'doma_page.dart';
import 'job_page.dart';
import 'make_page.dart';
import 'meneger_page.dart';
import 'news_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Controller _controller = Get.put(Controller());
  int page = 1;
  double height = 50;

  @override
  void initState() {
    super.initState();
    // kompleksBloc = BlocProvider.of<KompleksBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            flexibleSpace: Container(
              padding: EdgeInsets.only(left: 100),
              alignment: Alignment.centerLeft,
              child: Text(
                Ui.company,

              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.red,
                  child: ListView(
                    children: [
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Справочники",
                          style: Ui.fonttext,
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Container(
                          height: height,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: page == 1
                                                  ? Colors.white
                                                  : Colors.white54)))),
                              // color: Colors.black54,
                              onPressed: () {
                                setState(() {
                                  page = 1;
                                });
                              },
                              child: Text(
                                "Комплексы",
                                style: Ui.fonttext,
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: height,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: page == 2
                                                  ? Colors.white
                                                  : Colors.white54)))),
                              // color: Colors.black54,
                              onPressed: () {
                                setState(() {
                                  page = 2;
                                  // kompleksBloc.add(BlocLoadEvent());
                                });
                              },
                              child: Text(
                                "Дома",
                                style: Ui.fonttext,
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: height,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: page == 3
                                                  ? Colors.white
                                                  : Colors.white54)))),
                              // color: Colors.black54,
                              onPressed: () {
                                setState(() {
                                  page = 3;
                                  // kompleksBloc.add(BlocLoadEvent());
                                });
                              },
                              child: Text(
                                "Фото материалы (Комплекс, Дома)",
                                style: Ui.fonttext,
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: height,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: page == 4
                                                  ? Colors.white
                                                  : Colors.white54)))),
                              // color: Colors.black54,
                              onPressed: () {
                                setState(() {
                                  page = 4;
                                  // kompleksBloc.add(BlocLoadEvent());
                                });
                              },
                              child: Text(
                                "Каталоги",
                                style: Ui.fonttext,
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: height,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: page == 5
                                                  ? Colors.white
                                                  : Colors.white54)))),
                              // color: Colors.black54,
                              onPressed: () {
                                setState(() {
                                  page = 5;
                                  // kompleksBloc.add(BlocLoadEvent());
                                });
                              },
                              child: Text(
                                "Руководство",
                                style: Ui.fonttext,
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: height,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: page == 6
                                                  ? Colors.white
                                                  : Colors.white54)))),
                              // color: Colors.black54,
                              onPressed: () {
                                setState(() {
                                  page = 6;
                                  // kompleksBloc.add(BlocLoadEvent());
                                });
                              },
                              child: Text(
                                "Новости",
                                style: Ui.fonttext,
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: height,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: page == 7
                                                  ? Colors.white
                                                  : Colors.white54)))),
                              // color: Colors.black54,
                              onPressed: () {
                                setState(() {
                                  page = 7;
                                  // kompleksBloc.add(BlocLoadEvent());
                                });
                              },
                              child: Text(
                                "Вакансия",
                                style: Ui.fonttext,
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: height,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: page == 7
                                                  ? Colors.white
                                                  : Colors.white54)))),
                              // color: Colors.black54,
                              onPressed: () {
                                setState(() {
                                  page = 8;
                                  // kompleksBloc.add(BlocLoadEvent());
                                });
                              },
                              child: Text(
                                "События",
                                style: Ui.fonttext,
                              )))
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: selectPage(),
              ),
            ],
          ),
        ));
  }

  selectPage() {
    switch (page) {
      case 1:
        return KomleksPage();
      case 2:
        return DomaPage();
      case 3:
        return ImagePage();
      case 4:
        return MakePage();
      case 5:
        return MenegerPage();
      case 6:
        return NewsPage();
      case 7:
        return JobPage();
      case 8:
        return EventPage();
    }
  }
}
