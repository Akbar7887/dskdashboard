import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/bloc_state.dart';
import '../bloc/make_bloc.dart';
import '../models/Catalog.dart';
import '../models/Make.dart';
import '../ui.dart';

List<Make> _listMake = [];
Make? _make;
TextEditingController _nameContoller = TextEditingController();
TextEditingController _descriptionContoller = TextEditingController();
final _keymake = GlobalKey<FormState>();
Uint8List? _webImage;
List<Catalog> _listCatalogs = [];
Catalog? _catalog;

List<Map<String, dynamic>> _listController = [
  {"contr": TextEditingController(), "title": "наименование", "read": true},
  {"contr": TextEditingController(), "title": "ширина", "read": true},
  {"contr": TextEditingController(), "title": "высота", "read": true},
  {"contr": TextEditingController(), "title": "длина", "read": true},
  {"contr": TextEditingController(), "title": "Объем", "read": true},
  {"contr": TextEditingController(), "title": "Масса", "read": true},
  {"contr": TextEditingController(), "title": "Класс", "read": true},
];

class MakePage extends StatelessWidget {
  const MakePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MakeBloc, BlocState>(
        builder: (context, state) {
          if (state is BlocEmtyState) {
            return Center(child: Text("No data!"));
          }
          if (state is BlocLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is MakeLoadedState) {
            _listMake = state.loadedMake;
            _listMake.sort((a, b) => a.id!.compareTo(b.id!));

            if (_listMake.length > 0) {
              _make = _listMake.first;
            }

            return Container(
                padding: EdgeInsets.only(left: 100, right: 100),
                child: main(context));
          }

          if (state is BlocErrorState) {
            return Center(
              child: Text("Сервер не работает!"),
            );
          }
          return SizedBox.shrink();
        },
        listener: (context, state) {});
  }

  Widget main(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            "Каталоги",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Divider(),
        Align(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
              onPressed: () {
                _make = null;
                _webImage = null;
                showDialogMake(context);
              },
              child: Text("Добавить"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
            )),
        Expanded(child: dataTable(context))
      ],
    );
  }

  Widget dataTable(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text("№")),
        DataColumn(label: Text("Наименование")),
        DataColumn(label: Text("Описание")),
        DataColumn(label: Text("Изменить")),
        DataColumn(label: Text("Удалить")),
      ],
      rows: _listMake.map((e) {
        return DataRow(cells: [
          DataCell(Text((_listMake.indexOf(e) + 1).toString())),
          DataCell(Text(e.name!)),
          DataCell(Text(e.description!)),
          DataCell(IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _make = e;
              _listCatalogs = _make!.catalogs!;
              showDialogMake(context);
            },
          )),
          DataCell(IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {},
          )),
        ]);
      }).toList(),
    );
  }

  Future<void> showDialogMake(BuildContext context) async {
    if (_make != null) {
      _nameContoller.text = _make!.name!;
      _descriptionContoller.text = _make!.description!;
      // _nameContoller.text = _make!.name!;
    } else {
      _nameContoller.text = "";
      _descriptionContoller.text = "";
    }

    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Добавление каталога'),
            content: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: Form(
                key: _keymake,
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,
                                // height: MediaQuery.of(context).size.height / 2,
                                child: TextFormField(
                                    controller: _nameContoller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Просим заполнить наименование";
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
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 0.5,
                                                color: Colors.black)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 0.5,
                                                color: Colors.black)))),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,
                                // height: MediaQuery.of(context).size.height / 2,
                                child: TextFormField(
                                    controller: _descriptionContoller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Просим заполнить описание";
                                      }
                                    },
                                    style: GoogleFonts.openSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w200,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        //Theme.of(context).backgroundColor,
                                        labelText: "Описание",
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 0.5,
                                                color: Colors.black)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 0.5,
                                                color: Colors.black)))),
                              ),
                            ],
                          ),
                          Expanded(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _webImage == null
                                        ? Image.network(
                                        '${Ui.url}make/download/makes/${_make!
                                            .imagepath}',
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            5,
                                        height:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height /
                                            3, errorBuilder:
                                        (BuildContext context, Object error,
                                        StackTrace? stackTrace) {
                                      return Icon(Icons.photo);
                                    })
                                        : Container(
                                      child: Image.memory(
                                        _webImage!,
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    // Spacer(),
                                    ElevatedButton(
                                        onPressed: () async {
                                          XFile? image = await ImagePicker()
                                              .pickImage(
                                              source: ImageSource.gallery);
                                          if (image != null) {
                                            var f = await image.readAsBytes();
                                            setState(() {
                                              _webImage = f;
                                            });
                                          }
                                        },
                                        child: Text("Загрузить фото.."))
                                  ]))
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            _catalog = null;
                            // showCatalogDialog(context);
                          },
                          child: Text("Добавить"),
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                        )),
                    Expanded(child: getDataTable(context))
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Сохранить'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
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
        });
      },
    );
  }

  Widget getDataTable(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return DataTable(
          columnSpacing: MediaQuery
              .of(context)
              .size
              .width / 14,
          columns: [
            DataColumn(label: Text("№")),
            DataColumn(label: Text("name")),
            DataColumn(label: Text("ширина")),
            DataColumn(label: Text("высота")),
            DataColumn(label: Text("длина")),
            DataColumn(label: Text("Объем")),
            DataColumn(label: Text("Масса")),
            DataColumn(label: Text("Класс")),
            DataColumn(label: Text("Изменить")),
            DataColumn(label: Text("Удалить")),
          ],
          rows: _make!.catalogs!.map((e) {
            _listController[0]["contr"].text = e.name;
            _listController[1]["contr"].text = e.weigth;
            _listController[2]["contr"].text = e.heigth;
            _listController[3]["contr"].text = e.length;
            _listController[4]["contr"].text = e.volume;
            _listController[5]["contr"].text = e.mass;
            _listController[6]["contr"].text = e.concrete;
            // _listController[7]["contr"].text = e.name;
            // _listController[8]["contr"].text = e.name;

            return DataRow(cells: [
              DataCell(Text((_make!.catalogs!.indexOf(e) + 1).toString())),
              DataCell(TextFormField(
                controller: _listController[0]["contr"],
                readOnly: _listController[0]["read"],
              )),
              DataCell(TextFormField(
                  controller: _listController[1]["contr"],
                  readOnly: _listController[1]["read"])),
              DataCell(TextFormField(
                  controller: _listController[2]["contr"],
                  readOnly: _listController[2]["read"])),
              DataCell(TextFormField(
                  controller: _listController[3]["contr"],
                  readOnly: _listController[3]["read"])),
              DataCell(TextFormField(
                  controller: _listController[4]["contr"],
                  readOnly: _listController[4]["read"])),
              DataCell(TextFormField(
                  controller: _listController[5]["contr"],
                  readOnly: _listController[5]["read"])),
              DataCell(TextFormField(
                  controller: _listController[6]["contr"],
                  readOnly: _listController[6]["read"])),
              DataCell(IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _listController.map((e) {
                      e["read"] = !e["read"];
                      print(e);
                    }).toList();
                  });
                },
              )),
              DataCell(IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {},
              )),
            ]);
          }).toList());
    });
  }
}
