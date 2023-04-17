import 'dart:typed_data';

import 'package:dskdashboard/controller/Controller.dart';
import 'package:dskdashboard/models/Kompleks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/Dom.dart';
import '../models/ImageDom.dart';
import '../ui.dart';


Uint8List? _webImage;
TextEditingController _titleControl = TextEditingController();
TextEditingController _dateprojectControl = TextEditingController();
String? _imagepath;
var formatter = new DateFormat('yyyy-MM-dd');
final _keyImage = GlobalKey<FormState>();
final Controller _controller = Get.find();

class ImagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Фото материала по Комплексу и по домам",
                  style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                      color: Colors.black),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.only(left: 100, right: 100),
                child: Row(
                  children: [
                    Expanded(
                        child: DropdownButton<Kompleks>(
                            isExpanded: true,
                            hint: Text("Комплексы"),
                            items: _controller.komplekses.value
                                .map<DropdownMenuItem<Kompleks>>((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e.title!),
                              );
                            }).toList(),
                            value: _controller.kompleks.value,
                            onChanged: (Kompleks? newValue) {
                              _controller.kompleks.value = newValue!;
                              _controller.doms.value = newValue.domSet!;
                              if(_controller.doms.value.length != 0){
                                _controller.dom.value = _controller.doms.value.first;
                              }
                            })),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: DropdownButton<Dom>(
                            isExpanded: true,
                            hint: Text("Дома"),
                            items: _controller.doms.value
                                .map<DropdownMenuItem<Dom>>((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e.name!),
                              );
                            }).toList(),
                            value: _controller.dom.value,
                            onChanged: (Dom? newValue) {
                              // setState(() {
                              _controller.dom.value = newValue!;
                              _controller.imagedoms.value =
                                  _controller.dom.value.imagedom!;

                              // });
                            })),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  _imagepath = "";
                  _controller.imagedom = ImageDom().obs;
                  _webImage = null;
                  showdialog(context);
                },
                child: Text("Добавить"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _controller.imagedoms.value.length != 0
                ? Expanded(
                    child: Row(children: [
                      Expanded(child: imageTable(context)),
                      VerticalDivider(),
                      Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Card(
                                elevation: 5,
                                child: Image.network(
                                  "${Ui.url}imagedata/download/images/${_controller.imagedom.value.imagepath}",
                                  errorBuilder: (context, object, stacktrace) {
                                    return Center(child: Icon(Icons.photo));
                                  },
                                )),
                          ))
                    ]),
                  )
                : Container(),
          ],
        )));
  }

  Widget imageTable(BuildContext context) {
    var formatter = new DateFormat('yyyy-MM-dd');

    return ListView.builder(
      itemCount: _controller.imagedoms.value.length,
      itemBuilder: (BuildContext ctx, index) {
        return Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 3,
            child: Card(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                                child: Column(
                              children: [
                                Container(
                                    child: Text(formatter.format(DateTime.parse(
                                        _controller.imagedoms.value[index].datacreate!)))),
                                Container(
                                    height: 80,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                            title: Text("web"),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            onChanged: (newVlaue) {
                                              _controller
                                                  .postWebImage(
                                                      "imagedata/webimage",
                                                      "web",
                                                  _controller.imagedoms.value[index]
                                                          .id
                                                          .toString(),
                                                      newVlaue!)
                                                  .then((value) {
                                                // setState(() {
                                                _controller.imagedoms
                                                        .value[index].web =
                                                    ImageDom.fromJson(value)
                                                        .web;
                                                _controller.imagedoms.refresh();
                                                // });
                                              });
                                            },
                                            value: _controller.imagedoms.value[index].web,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                            child: CheckboxListTile(
                                          title: Text("Проект"),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (newVlaue) {
                                            _controller
                                                .postWebImage(
                                                    "imagedata/layotimage",
                                                    "layout",
                                                    _controller.imagedoms
                                                        .value[index].id
                                                        .toString(),
                                                    newVlaue!)
                                                .then((value) {
                                              // setState(() {
                                              _controller.imagedoms.value[index]
                                                      .layout =
                                                  ImageDom.fromJson(value)
                                                      .layout;
                                              _controller.imagedoms.refresh();

                                              // });
                                            });
                                          },
                                          value: _controller.imagedoms.value[index].layout,
                                        )),
                                      ],
                                    )),
                              ],
                            )),
                            Expanded(

                                child: InkWell(
                                    onTap: () {
                                      // setState(() {
                                      _controller.imagedom.value = _controller.imagedoms.value[index];
                                      // });
                                    },
                                    child: Image.network(
                                      "${Ui.url}imagedata/download/images/${_controller.imagedoms.value[index].imagepath}",
                                    ))),
                          ],
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(),
                        Container(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(text: "Коментарий: "),
                                TextSpan(
                                  text: _controller.imagedoms.value[index].name!,
                                  style: TextStyle(fontSize: 15),
                                )
                              ]),
                            )),
                        Divider(),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _imagepath = _controller.imagedoms.value[index].imagepath;
                                  _controller.imagedom.value =
                                  _controller.imagedoms.value[index];
                                  _webImage = null;
                                  showdialog(context);
                                },
                                child: Text("Изменить"),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.indigoAccent)),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _controller
                                      .removeById(
                                          "imagedata/remove",
                                          _controller.imagedoms.value[index].id
                                              .toString())
                                      .then((value) {
                                    // setState(() {
                                    //   _controller..remove(_listPicture[index]);
                                    // });
                                    // imageBloc!.getImage(_doma!.id.toString());
                                    // _kompleksBloc!.add(BlocLoadEvent());
                                  });
                                },
                                child: Text("Удалить"),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.indigoAccent)),
                              )
                            ],
                          ),
                        )
                      ],
                    ))));
      },
    );
  }

  Future<void> showdialog(BuildContext context) {
    if (_controller.imagedom.value.id != null) {
      _titleControl.text = _controller.imagedom.value.name!;
      _dateprojectControl.text = _controller.imagedom.value.datacreate!;
    } else {
      _titleControl.text = "";
      _dateprojectControl.text = "";
    }
    _dateprojectControl.text;
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Добавление фото на Дом!'),
            content: Form(
              key: _keyImage,
              child: Column(
                children: [
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
                          FocusScope.of(context).requestFocus(new FocusNode());
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextFormField(
                        controller: _titleControl,
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
                            labelText: "Комментарий",
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
                    height: 10,
                  ),
                  Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        _webImage == null
                            ? Image.network(
                                '${Ui.url}imagedata/download/images/${_imagepath}',
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.height / 2,
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
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
                                  .pickImage(source: ImageSource.gallery);
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
            actions: <Widget>[
              TextButton(
                child: Text('Сохранить'),
                onPressed: () {
                  if (!_keyImage.currentState!.validate()) {
                    return;
                  }

                  if (_controller.imagedom.value == null) {
                    _controller.imagedom.value = ImageDom();
                  }
                  _controller.imagedom.value.name = _titleControl.text;
                  _controller.imagedom.value.datacreate =
                      _dateprojectControl.text;

                  _controller
                      .saveWithParentId(
                          "imagedata/save",
                          _controller.imagedom.value,
                          _controller.dom.value.id.toString())
                      .then((value) {
                    ImageDom imagedom = ImageDom.fromJson(value);
                    if (_webImage != null) {
                      return _controller
                          .postImage("imagedata/upload", imagedom.id.toString(),
                              _webImage!)
                          .then((value) {
                        _controller.getAll();
                        _controller.imagedoms.refresh();

                        // setState(() {
                        //
                        // });
                        Navigator.of(dialogContext)
                            .pop(); // Dismiss alert dialog
                      });
                    } else {
                      Navigator.of(dialogContext).pop();
                    }
                  }).catchError((onError) {
                    print("Error");
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
      },
    );
  }
}
