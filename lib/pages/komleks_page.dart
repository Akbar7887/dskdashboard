import 'package:dskdashboard/bloc/bloc_state.dart';
import 'package:dskdashboard/bloc/kompleks_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/bloc_event.dart';
import '../models/Kompleks.dart';

List<Kompleks> _listKomleks = [];
late KompleksBloc kompleksBloc;
Kompleks? kompleks;
GlobalKey _keyName = GlobalKey();
TextEditingController _nameControl = TextEditingController();

class KomleksPage extends StatelessWidget {
  const KomleksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    kompleksBloc = BlocProvider.of<KompleksBloc>(context);

    return BlocConsumer<KompleksBloc, BlocState>(
      builder: (context, state) {
        if (state is BlocEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is BlocLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is KompleksLoadedState) {
          //
          _listKomleks = state.loadedKomleks;
          _listKomleks.sort((a, b) => a.id!.compareTo(b.id!));
          return mainWidget(context);
        }

        if (state is BlocErrorState) {
          return Center(
            child: Text("Сервер не работает!"),
          );
        }
        return SizedBox.shrink();
      },
      listener: (context, state) {},
    );
  }

  Widget mainWidget(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            "Комплексы",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Divider(),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black54)),
              onPressed: () {
                kompleks = null;
                showdialogwidget(context);
              },
              child: Text("Добавить")),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            // color: Colors.black87,
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: DataTable(
                    sortAscending: true,
                    sortColumnIndex: 0,
                    headingRowColor: MaterialStateProperty.all(Colors.black54),
                    headingTextStyle: TextStyle(color: Colors.white),
                    columns: [
                      DataColumn(label: Text("№")),
                      DataColumn(label: Text("Наименование")),
                      DataColumn(label: Text("Изменить")),
                      DataColumn(label: Text("Удалить")),
                    ],
                    rows: _listKomleks.map((e) {
                      return DataRow(cells: [
                        DataCell(
                            Text((_listKomleks.indexOf(e) + 1).toString())),
                        DataCell(Text(e.name!)),
                        DataCell(IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            kompleks = e;
                            showdialogwidget(context).then((value) {});
                          },
                        )),
                        DataCell(IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            Map<String, dynamic> param = {
                              'id': e.id.toString()
                            };
                            kompleksBloc
                                .remove("kompleksldelete", param)
                                .then((value) {
                              kompleksBloc.add(BlocLoadEvent());
                            }).catchError((onError) {
                              print(onError);
                            });
                          },
                        )),
                      ]);
                    }).toList())))
      ],
    );
  }

  Future<void> showdialogwidget(BuildContext context) {
    if (kompleks != null) {
      _nameControl.text = kompleks!.name!;
    } else {
      _nameControl.text = "";
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Справочник комплексы'),
          content: Container(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (kompleks != null)
                    ? Text('№ ${kompleks?.id.toString()}')
                    : Text('№'),
                SizedBox(
                  height: 30,
                ),
                Container(
                    width: 400,
                    child: Form(
                      key: _keyName,
                      child: TextFormField(
                          controller: _nameControl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Просим заполнить пользователя";
                            }
                          },
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              //Theme.of(context).backgroundColor,
                              labelText: "Наименование",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)))),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Сохранить'),
              onPressed: () {
                if (kompleks == null) {
                  kompleks = Kompleks();
                  kompleks!.name = _nameControl.text;
                } else {
                  kompleks!.name = _nameControl.text;
                }

                // Map<String, dynamic> param = {'name': _nameControl.text};

                kompleksBloc.save("kompleksed", kompleks).then((value) {
                  kompleksBloc.add(BlocLoadEvent());
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                }).catchError((error) {
                  print(error);
                });
              },
            ),
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}

// class KomleksPage extends StatefulWidget {
//   const KomleksPage({Key? key}) : super(key: key);
//
//   @override
//   State<KomleksPage> createState() => _KomleksPageState();
// }
//
// class _KomleksPageState extends State<KomleksPage> {
//
//   @override
//   void initState() {
//     super.initState();
//
//     //
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // kompleksBloc.add(BlocLoadEvent());
//     return
//   }
