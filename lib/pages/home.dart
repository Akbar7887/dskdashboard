import 'package:dskdashboard/bloc/bloc_event.dart';
import 'package:dskdashboard/bloc/bloc_state.dart';
import 'package:dskdashboard/bloc/image_Bloc.dart';
import 'package:dskdashboard/bloc/kompleks_bloc.dart';
import 'package:dskdashboard/models/Make.dart';
import 'package:dskdashboard/pages/doma_page.dart';
import 'package:dskdashboard/pages/image_page.dart';
import 'package:dskdashboard/pages/komleks_page.dart';
import 'package:dskdashboard/pages/make_page.dart';
import 'package:dskdashboard/pages/meneger_page.dart';
import 'package:dskdashboard/pages/news_page.dart';
import 'package:dskdashboard/service/repository.dart';
import 'package:dskdashboard/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/job_bloc.dart';
import '../bloc/make_bloc.dart';
import '../bloc/meneger_Bloc.dart';
import '../bloc/news_bloc.dart';
import 'job_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int page = 1;
  late KompleksBloc kompleksBloc;

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
                style: GoogleFonts.openSans(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        body: RepositoryProvider(
            create: (context) => Repository(),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (context) =>
                        KompleksBloc(repository: context.read<Repository>())
                          ..add(BlocLoadEvent())),
                BlocProvider(
                    create: (context) =>
                        ImageBloc(repository: context.read<Repository>())),
                BlocProvider(
                    create: (context) =>
                        MakeBloc(repository: context.read<Repository>())
                          ..add(BlocLoadEvent())),
                BlocProvider(
                    create: (context) =>
                        MenegerBloc(repository: context.read<Repository>())
                          ..add(BlocLoadEvent())),
                BlocProvider(
                    create: (context) =>
                        NewsBloc(repository: context.read<Repository>())
                          ..add(BlocLoadEvent())),
                BlocProvider(
                    create: (context) =>
                        JobBloc(repository: context.read<Repository>())
                          ..add(BlocLoadEvent())),
              ],
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.black54,
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
                              height: 70,
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
                              height: 70,
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
                              height: 70,
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
                              height: 70,
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
                              height: 70,
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
                              height: 70,
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
                              height: 70,
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
            )));
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
    }
  }
}
