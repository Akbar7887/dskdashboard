import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controller/Controller.dart';
import '../models/Kompleks.dart';
import '../ui.dart';

final Controller _controller = Get.find();

final _keyformkompleks = GlobalKey<FormState>();
TextEditingController _titleControl = TextEditingController();
TextEditingController _customerContoller = TextEditingController();
TextEditingController _deskriptionContoller = TextEditingController();
TextEditingController _typehouseControl = TextEditingController();
TextEditingController _statusbuildingControl = TextEditingController();
TextEditingController _dateprojectControl = TextEditingController();
var formatter = new DateFormat('yyyy-MM-dd');
Uint8List? _webImage;
Uint8List? _webImage0;
Uint8List? _webImage1;

class KomleksPage extends GetView<Controller> {
  const KomleksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        ListView(
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
                      backgroundColor: MaterialStateProperty.all(
                          Colors.black54)),
                  onPressed: () {
                    _controller.kompleks = Kompleks().obs;
                    _webImage = null;
                    _webImage0 = null;
                    _webImage1 = null;

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
                        key: UniqueKey(),
                        sortAscending: true,
                        sortColumnIndex: 0,
                        headingRowColor: MaterialStateProperty.all(
                            Colors.black54),
                        headingTextStyle: TextStyle(color: Colors.white),
                        columns: [
                          DataColumn(label: Text("№")),
                          DataColumn(label: Text("Наименование")),
                          DataColumn(label: Text("Состояние")),
                          DataColumn(label: Text("Заказщик")),
                          DataColumn(label: Text("Изменить")),
                          DataColumn(label: Text("Удалить")),
                        ],
                        rows: _controller.komplekses.value.map((e) {
                          return DataRow(cells: [
                            DataCell(Text(
                                (_controller.komplekses.value.indexOf(e) + 1)
                                    .toString())),
                            DataCell(Text(e.title!)),
                            DataCell(Text(e.statusbuilding!)),
                            DataCell(Text(e.customer!)),
                            DataCell(IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _controller.kompleks.value = e;
                                _webImage = null;
                                _webImage0 = null;
                                _webImage1 = null;

                                showdialogwidget(context);
                              },
                            )),
                            DataCell(IconButton(
                              icon: Icon(Icons.delete_forever),
                              onPressed: () {
                                Map<String, dynamic> param = {
                                  'id': e.id.toString()
                                };
                                _controller
                                    .removeById(
                                    "kompleks/remove", e.id.toString())
                                    .then((value) {
                                  _controller.komplekses.value.remove(e);
                                  _controller.komplekses.refresh();
                                }).catchError((onError) {
                                  print(onError);
                                });
                              },
                            )),
                          ]);
                        }).toList())))
          ],
        ));
  }

  // Widget removeImage(BuildContext context, setState, String filename,
  //     Uint8List? web) {
  //   return
  // }

  Widget getColunImage(BuildContext context, setState, String? path,
      Uint8List? web) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
       web == null?
      Image.network(
          path == null
              ? ""
              : "${Ui.url}kompleks/download/house/${path}",
          width: 100,
          height: 100, errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Icon(Icons.photo);
      })
      : Container(
          child: Image.memory(
            web,
            width: 100,
            height: 100,
          ),
        ),
      SizedBox(
        height: 50,
      ),
      ElevatedButton(
          onPressed: () async {
            _controller
                .removeImage("kompleks/removeimage",
                _controller.kompleks.value.id.toString(), path!)
                .then((value) {
              setState(() {
                web = null;
              });
            });
          },
          child: Icon(Icons.delete_forever_sharp)),
      SizedBox(
        height: 10,
      ),
      ElevatedButton(
          onPressed: () async {
            XFile? image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image != null) {
              var f = await image.readAsBytes();
              setState(() {
                web = f;
              });
            }
          },
          child: Text("Загрузить фото.."))
    ]);
  }

  Future<void> showdialogwidget(BuildContext context) {
    if (_controller.kompleks.value.id != null) {
      _titleControl.text = _controller.kompleks.value.title!;
      _dateprojectControl.text = _controller.kompleks.value.dateproject!;
      _customerContoller.text = _controller.kompleks.value.customer!;
      _statusbuildingControl.text = _controller.kompleks.value.statusbuilding!;
      _typehouseControl.text = _controller.kompleks.value.typehouse!;
      _deskriptionContoller.text = _controller.kompleks.value.description!;
    } else {
      _titleControl.clear();
      _dateprojectControl.clear();
      _customerContoller.clear();
      _statusbuildingControl.clear();
      _typehouseControl.clear();
      _deskriptionContoller.clear();
    }

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            // key: UniqueKey(),
            title: Text('Комплекс'),
            content: SafeArea(
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Form(
                              key: _keyformkompleks,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          (_controller.kompleks.value.id !=
                                              null)
                                              ? Text(
                                              '№ ${_controller.kompleks.value.id
                                                  .toString()}')
                                              : Text('№'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width / 3,
                                            child: TextFormField(
                                                controller: _titleControl,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
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
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)))),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width / 3,
                                            child: TextFormField(
                                                controller: _typehouseControl,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
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
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)))),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width / 3,
                                            child: TextFormField(
                                                controller: _statusbuildingControl,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
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
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)))),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width / 3,
                                            // height: MediaQuery.of(context).size.height / 2,
                                            child: TextFormField(
                                                controller: _customerContoller,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
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
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)))),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width / 3,
                                            // height: MediaQuery.of(context).size.height / 2,
                                            child: TextFormField(
                                                controller: _dateprojectControl,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
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
                                                          formatter
                                                              .format(
                                                              selectedDate);
                                                    }
                                                  });
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                      new FocusNode());
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
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)))),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width / 1.1,
                                            // height: MediaQuery.of(context).size.height / 2,
                                            child: TextFormField(
                                                controller: _deskriptionContoller,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
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
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black)))),
                                          ),
                                        ],
                                      )),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            getColunImage(
                                                context,
                                                setState,
                                                _controller
                                                    .kompleks.value
                                                    .mainimagepath!,
                                                _webImage == null? null: _webImage),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            getColunImage(
                                                context,
                                                setState,
                                                _controller.kompleks.value
                                                    .mainimagepathfirst!,
                                                _webImage0 == null? null: _webImage0),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        getColunImage(
                                            context,
                                            setState,
                                            _controller.kompleks.value
                                                .mainimagepathsecond!,
                                            _webImage1 == null? null: _webImage1),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )));
                    })),
            actions: <Widget>[
              TextButton(
                child: Text('Сохранить'),
                onPressed: () {
                  if (_controller.kompleks.value.id == null) {
                    _controller.kompleks.value = Kompleks();
                  } else {}

                  if (!_keyformkompleks.currentState!.validate()) {
                    return;
                  }

                  _controller.kompleks.value.title =
                      _titleControl.text.trim();
                  _controller.kompleks.value.dateproject =
                      _dateprojectControl.text.trim();
                  _controller.kompleks.value.customer =
                      _customerContoller.text;
                  _controller.kompleks.value.statusbuilding =
                      _statusbuildingControl.text.trim();
                  _controller.kompleks.value.typehouse =
                      _typehouseControl.text.trim();
                  _controller.kompleks.value.description =
                      _deskriptionContoller.text.trim();
                  // Map<String, dynamic> param = {'name': _nameControl.text};

                  _controller
                      .save("kompleks/save", _controller.kompleks.value)
                      .then((value) {
                    _controller.kompleks.value = Kompleks.fromJson(value);
                    // if (_webImage!.isNotEmpty ||
                    //     _webImage0!.isNotEmpty ||
                    //     _webImage1!.isNotEmpty) {
                    if (_webImage != null) {
                      _controller.postImageKompleks(
                          "kompleks/upload",
                          _controller.kompleks.value.id.toString(),
                          "1",
                          _webImage!,
                          "${_controller.kompleks.value.id.toString()}.png");
                    }
                    if (_webImage0 != null) {
                      _controller.postImageKompleks(
                          "kompleks/upload",
                          _controller.kompleks.value.id.toString(),
                          "2",
                          _webImage0!,
                          "${_controller.kompleks.value.id.toString()}.png");
                    }
                    if (_webImage1 != null) {
                      _controller.postImageKompleks(
                          "kompleks/upload",
                          _controller.kompleks.value.id.toString(),
                          "3",
                          _webImage1!,
                          "${_controller.kompleks.value.id.toString()}.png");
                    }

                    _webImage = null;
                    _webImage0 = null;
                    _webImage1 = null;
                    // }
                    _controller.fetchAll("kompleks/get", Kompleks());
                    _controller.komplekses.refresh();
                    Navigator.of(dialogContext).pop();
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
}
