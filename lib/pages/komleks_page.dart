import 'package:dskdashboard/bloc/bloc_state.dart';
import 'package:dskdashboard/bloc/kompleks_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../bloc/bloc_event.dart';
import '../models/Kompleks.dart';

List<Kompleks> _listKomleks = [];
late KompleksBloc kompleksBloc;
Kompleks? kompleks;
GlobalKey _keyName = GlobalKey();
TextEditingController _titleControl = TextEditingController();
TextEditingController _customerContoller = TextEditingController();
TextEditingController _deskriptionContoller = TextEditingController();
TextEditingController _typehouseControl = TextEditingController();
TextEditingController _statusbuildingControl = TextEditingController();
TextEditingController _dateprojectControl = TextEditingController();
var formatter = new DateFormat('yyyy-MM-dd');

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
                      DataColumn(label: Text("Состояние")),
                      DataColumn(label: Text("Заказщик")),
                      DataColumn(label: Text("Изменить")),
                      DataColumn(label: Text("Удалить")),
                    ],
                    rows: _listKomleks.map((e) {
                      return DataRow(cells: [
                        DataCell(
                            Text((_listKomleks.indexOf(e) + 1).toString())),
                        DataCell(Text(e.title!)),
                        DataCell(Text(e.statusbuilding!)),
                        DataCell(Text(e.customer!)),
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
                                .remove("kompleks/remove", param)
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
      _titleControl.text = kompleks!.title!;
      _dateprojectControl.text = kompleks!.dateproject!;
      _customerContoller.text = kompleks!.customer!;
      _statusbuildingControl.text = kompleks!.statusbuilding!;
      _typehouseControl.text = kompleks!.typehouse!;
      _deskriptionContoller.text = kompleks!.description!;
    } else {
      _titleControl.text = "";
      _dateprojectControl.text = "";
      _customerContoller.text = "";
      _statusbuildingControl.text = "";
      _typehouseControl.text = "";
      _deskriptionContoller.text = "";
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Комплекс'),
          content: Container(
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width / 1.1,
              child: Form(
                key: _keyName,
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
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextFormField(
                          controller: _titleControl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Просим наименование пользователя";
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextFormField(
                          controller: _typehouseControl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Тип комплекса";
                            }
                          },
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              //Theme.of(context).backgroundColor,
                              labelText: "Тип комплекса",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextFormField(
                          controller: _statusbuildingControl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Состояние комплекса";
                            }
                          },
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              //Theme.of(context).backgroundColor,
                              labelText: "Состояние комплекса",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      // height: MediaQuery.of(context).size.height / 2,
                      child: TextFormField(
                          controller: _deskriptionContoller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Описание комплекса";
                            }
                          },
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              //Theme.of(context).backgroundColor,
                              labelText: "Описание комплекса",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      // height: MediaQuery.of(context).size.height / 2,
                      child: TextFormField(
                          controller: _customerContoller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Заказщик";
                            }
                          },
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              //Theme.of(context).backgroundColor,
                              labelText: "Заказщик",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      // height: MediaQuery.of(context).size.height / 2,
                      child: TextFormField(
                          controller: _dateprojectControl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Дата";
                            }
                          },
                          onTap: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2015),
                              lastDate: DateTime(2030),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                _dateprojectControl.text =
                                    formatter.format(selectedDate);
                              }
                            });
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              //Theme.of(context).backgroundColor,
                              labelText: "Дата",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)))),
                    )
                  ],
                ),
              )),
          actions: <Widget>[
            TextButton(
              child: Text('Сохранить'),
              onPressed: () {
                if (kompleks == null) {
                  kompleks = Kompleks();
                } else {}

                kompleks!.title = _titleControl.text;
                kompleks!.dateproject = _dateprojectControl.text;
                kompleks!.customer = _customerContoller.text;
                kompleks!.statusbuilding = _statusbuildingControl.text;
                kompleks!.typehouse = _typehouseControl.text;
                kompleks!.description = _deskriptionContoller.text;
                // Map<String, dynamic> param = {'name': _nameControl.text};

                kompleksBloc.save("kompleks/save", kompleks).then((value) {
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
