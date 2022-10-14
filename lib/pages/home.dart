import 'package:dskdashboard/bloc/bloc_event.dart';
import 'package:dskdashboard/bloc/bloc_state.dart';
import 'package:dskdashboard/bloc/doma_bloc.dart';
import 'package:dskdashboard/bloc/image_Bloc.dart';
import 'package:dskdashboard/bloc/kompleks_bloc.dart';
import 'package:dskdashboard/pages/doma_page.dart';
import 'package:dskdashboard/pages/image_page.dart';
import 'package:dskdashboard/pages/komleks_page.dart';
import 'package:dskdashboard/service/repository.dart';
import 'package:dskdashboard/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Row(
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
                                      borderRadius: BorderRadius.circular(10),
                                      side:
                                          BorderSide(color: Colors.white54)))),
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
                    height: 3,
                  ),
                  Container(
                      height: 70,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side:
                                          BorderSide(color: Colors.white54)))),
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
                    height: 3,
                  ),
                  Container(
                      height: 70,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side:
                                          BorderSide(color: Colors.white54)))),
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
    );
  }

  selectPage() {
    switch (page) {
      case 1:
        return KomleksPage();
      case 2:
        return DomaPage();
      case 3:
        return ImagePage();
    }
  }
}
