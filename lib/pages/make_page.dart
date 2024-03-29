import 'dart:typed_data';

import 'package:dskdashboard/controller/Controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../models/Catalog.dart';
import '../models/Make.dart';
import '../ui.dart';

TextEditingController _nameContoller = TextEditingController();
TextEditingController _descriptionContoller = TextEditingController();
final _keymake = GlobalKey<FormState>();
Uint8List? _webImage;
bool _read = true;
List<Map<String, TextEditingController>> _listController = [];
final Controller _controller = Get.put(Controller());

class MakePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: ListView(
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
                    _controller.make = Make().obs;
                    _webImage = null;
                    _controller.catalogs.value = [];
                    _listController = [];
                    showDialogMake(context);
                  },
                  child: Text("Добавить"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                )),
            Container(child: dataTable(context))
          ],
        )));
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
      rows: _controller.makes.value.map((e) {
        return DataRow(cells: [
          DataCell(Text((_controller.makes.value.indexOf(e) + 1).toString())),
          DataCell(Text(e.name!)),
          DataCell(Text(e.description!)),
          DataCell(IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _controller.make.value = e;
              _webImage = null;
              _controller.catalogs.value =
                  (_controller.make.value.catalogs == null
                      ? []
                      : _controller.make.value.catalogs)!;
              _controller.catalogs.value.sort((a, b) => a.id!.compareTo(b.id!));
              fillController();
              showDialogMake(context);
            },
          )),
          DataCell(IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              _controller
                  .removeById("make/delete", e.id.toString())
                  .then((value) {
                _controller.fetchAll("make/v1/get", Make()).then((value) {
                  if (_controller.makes.length != 0) {
                    _controller.make.value = _controller.makes.value.first;
                  }
                });
              });
            },
          )),
        ]);
      }).toList(),
    );
  }

  Future<void> showDialogMake(BuildContext context) async {
    if (_controller.make.value.id != null) {
      _nameContoller.text = _controller.make.value.name!;
      _descriptionContoller.text = _controller.make.value.description!;
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
          return AlertDialog(
            title: Text('Добавление каталога'),
            content: StatefulBuilder(builder: (context, setState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _keymake,
                  child: ListView(
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
                                  width: MediaQuery.of(context).size.width / 3,
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
                                  width: MediaQuery.of(context).size.width / 3,
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
                                          _controller.make.value.id == null
                                              ? ''
                                              : '${Ui.url}make/v1/download/makes/${_controller.make.value.imagepath}',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          errorBuilder: (BuildContext context,
                                              Object error,
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
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _read = false;
                                Catalog catalog = Catalog();
                                _controller.catalogs.value.add(catalog);
                              });
                              fillController();
                            },
                            child: Text("Добавить каталог"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue)),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(child: getDataTable(context))
                    ],
                  ),
                ),
              );
            }),
            actions: <Widget>[
              TextButton(
                child: Text('Сохранить'),
                onPressed: () {
                  if (!_keymake.currentState!.validate()) {
                    return;
                  }
                  ;
                  if (_controller.make.value.id == null) {
                    _controller.make.value = Make();
                  }
                  filllistCatalog();
                  _controller.make.value.catalogs = _controller.catalogs.value;
                  _controller.make.value.name = _nameContoller.text;
                  _controller.make.value.description =
                      _descriptionContoller.text;
                  _controller
                      .save("make/save", _controller.make.value)
                      .then((value) {
                    _controller.make.value = Make.fromJson(value);
                    if (_webImage != null) {
                      _controller
                          .postImage("make/upload",
                              _controller.make.value.id.toString(), _webImage!)
                          .then((value) {
                        _webImage = null;
                        // Dismiss alert dialog
                      });
                    }
                    _controller.fetchAll("make/v1/get", Make()).then((value) {
                      Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                    });
                    // Dismiss alert dialog
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
        });
  }

  void fillController() {
    _listController = [];
    _controller.catalogs.value.forEach((element) {
      TextEditingController name = TextEditingController();
      name.text = element.name == null ? "" : element.name!;
      TextEditingController heigth = TextEditingController();
      heigth.text = element.heigth == null ? "" : element.heigth!;
      TextEditingController length = TextEditingController();
      length.text = element.length == null ? "" : element.length!;
      TextEditingController mass = TextEditingController();
      mass.text = element.mass == null ? "" : element.mass!;
      TextEditingController volume = TextEditingController();
      volume.text = element.volume == null ? "" : element.volume!;
      TextEditingController weigth = TextEditingController();
      weigth.text = element.weigth == null ? "" : element.weigth!;
      TextEditingController concrete = TextEditingController();
      concrete.text = element.concrete == null ? "" : element.concrete!;

      _listController.add({
        "concrete": concrete,
        "heigth": heigth,
        "length": length,
        "mass": mass,
        "name": name,
        "volume": volume,
        "weigth": weigth
      });
    });
  }

  void filllistCatalog() {
    _listController.forEach((element) {
      _controller.catalogs.value[_listController.indexOf(element)].name =
          element["name"]!.text;
      _controller.catalogs.value[_listController.indexOf(element)].heigth =
          element["heigth"]!.text;
      _controller.catalogs.value[_listController.indexOf(element)].weigth =
          element["weigth"]!.text;
      _controller.catalogs.value[_listController.indexOf(element)].volume =
          element["volume"]!.text;
      _controller.catalogs.value[_listController.indexOf(element)].length =
          element["length"]!.text;
      _controller.catalogs.value[_listController.indexOf(element)].mass =
          element["mass"]!.text;
      _controller.catalogs.value[_listController.indexOf(element)].concrete =
          element["concrete"]!.text;
    });
  }

  Widget getDataTable(BuildContext context) {
    // fillController();
    return SingleChildScrollView(
        child: StatefulBuilder(builder: (context, setState) {
      return DataTable(
          border: TableBorder.all(
            width: 0.5,
            color: Colors.black87,
          ),
          headingRowColor: MaterialStateProperty.all(Colors.black38),
          dataTextStyle: TextStyle(fontSize: 15),
          // columnSpacing: MediaQuery.of(context).size.width / 14,
          columns: [
            DataColumn(label: Text("№")),
            DataColumn(label: Text("Название")),
            DataColumn(label: Text("ширина")),
            DataColumn(label: Text("высота")),
            DataColumn(label: Text("длина")),
            DataColumn(label: Text("Объем")),
            DataColumn(label: Text("Масса")),
            DataColumn(label: Text("Класс")),
            DataColumn(label: Text("Изменить")),
            DataColumn(label: Text("Удалить")),
          ],
          rows: _controller.catalogs.value
              .asMap()
              .map((idx, e) {
                return MapEntry(
                    idx,
                    DataRow(cells: [
                      DataCell(Text((idx + 1).toString())),
                      DataCell(TextFormField(
                        controller: _listController[idx]["name"],
                        style: TextStyle(fontSize: 15),
                        readOnly: _read,
                      )),
                      DataCell(TextFormField(
                          controller: _listController[idx]["weigth"],
                          style: TextStyle(fontSize: 15),
                          readOnly: _read)),
                      DataCell(TextFormField(
                          controller: _listController[idx]["heigth"],
                          style: TextStyle(fontSize: 15),
                          readOnly: _read)),
                      DataCell(TextFormField(
                          controller: _listController[idx]["length"],
                          style: TextStyle(fontSize: 15),
                          readOnly: _read)),
                      DataCell(TextFormField(
                          controller: _listController[idx]["volume"],
                          style: TextStyle(fontSize: 15),
                          readOnly: _read)),
                      DataCell(TextFormField(
                          controller: _listController[idx]["mass"],
                          style: TextStyle(fontSize: 15),
                          readOnly: _read)),
                      DataCell(TextFormField(
                          controller: _listController[idx]["concrete"],
                          style: TextStyle(fontSize: 15),
                          readOnly: _read)),
                      DataCell(IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            _read = !_read;
                          });
                        },
                      )),
                      DataCell(IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () {
                          _controller
                              .removeById("make/remove", e.id.toString())
                              .then((value) {
                            _controller
                                .fetchAll("make/v1/get", Make())
                                .then((value) {
                              fillController();
                            });
                          }).catchError((e) {
                            fillController();
                          });
                        },
                      )),
                    ]));
              })
              .values
              .toList());
    }));
  }
}
