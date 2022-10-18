import 'dart:typed_data';

import 'package:dskdashboard/bloc/image_Bloc.dart';
import 'package:dskdashboard/models/Kompleks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../bloc/bloc_event.dart';
import '../bloc/bloc_state.dart';
import '../bloc/kompleks_bloc.dart';
import '../models/Dom.dart';
import '../models/ImageData.dart';
import '../ui.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  List<Kompleks>? _listKomleks = [];
  Kompleks? _kompleks;
  List<Dom> _listDoma = [];
  Dom? _doma;

  // DomaBloc? _domaBloc;
  ImageBloc? imageBloc;
  List<ImageDom> _listPicture = [];
  FlutterSecureStorage _storage = FlutterSecureStorage();
  late Map<String, String> hedersWithToken;
  int _indexImage = 0;
  KompleksBloc? _kompleksBloc;
  Uint8List? _webImage;
  TextEditingController _titleControl = TextEditingController();
  TextEditingController _dateprojectControl = TextEditingController();
  String? _imagepath;
  ImageDom? _imageDom;
  var formatter = new DateFormat('yyyy-MM-dd');
  final _keyImage = GlobalKey<FormState>();

  // late final Repository repository;

  Future<void> getToken() async {
    String? token = await _storage.read(key: "token");

    hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
  }

  @override
  void initState() {
    super.initState();
    getToken();
    _kompleksBloc = BlocProvider.of<KompleksBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    imageBloc = BlocProvider.of<ImageBloc>(context);
    // _domaBloc = BlocProvider.of<DomaBloc>(context);
    return BlocConsumer<KompleksBloc, BlocState>(
      builder: (context, state) {
        if (state is BlocEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is BlocLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is KompleksLoadedState) {
          _listKomleks = state.loadedKomleks;
          _listKomleks!.sort((a, b) => a.id!.compareTo(b.id!));
          if (_kompleks != null && _doma != null) {
            _kompleks = _listKomleks!
                .firstWhere((element) => element.id == _kompleks!.id);
            _listDoma = _kompleks!.domSet!;
            _doma = _listDoma.firstWhere((element) => element.id == _doma!.id);
          }
          return mainList();
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

  Widget mainList() {
    return Padding(
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
                            items: _listKomleks!
                                .map<DropdownMenuItem<Kompleks>>((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e.title!),
                              );
                            }).toList(),
                            value: _kompleks,
                            onChanged: (Kompleks? newValue) {
                              setState(() {
                                _kompleks = newValue;
                                _listDoma = newValue!.domSet!;
                              });
                            })),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: DropdownButton<Dom>(
                            isExpanded: true,
                            hint: Text("Дома"),
                            items: _listDoma.map<DropdownMenuItem<Dom>>((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e.name!),
                              );
                            }).toList(),
                            value: _doma,
                            onChanged: (Dom? newValue) {
                              setState(() {
                                _doma = newValue;
                                _listPicture = _doma!.imagedom!;
                              });
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
                  _imageDom = null;
                  _webImage = null;
                  showdialog();
                },
                child: Text("Добавить"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _listPicture.length != 0
                ? Expanded(
                    child: Row(children: [
                      Expanded(child: imageTable()),
                      VerticalDivider(),
                      Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              elevation: 5,
                              child: _listPicture.length > 0
                                  ? Image.network(
                                      "${Ui.url}imagedata/download/images/${_listPicture[_indexImage].imagepath}",
                                      headers: hedersWithToken,
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            ),
                          ))
                    ]),
                  )
                : Container(),
          ],
        ));
  }

  Widget imageTable() {
    var formatter = new DateFormat('yyyy-MM-dd');

    return ListView.builder(
      itemCount: _listPicture.length,
      itemBuilder: (BuildContext ctx, index) {
        return Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 5,
            child: Card(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Expanded(
                                child: Text(formatter.format(DateTime.parse(
                                    _listPicture[index].datacreate!)))),
                            Container(
                                width: 100,
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _indexImage = index;
                                      });
                                    },
                                    child: Image.network(
                                      "${Ui.url}imagedata/download/images/${_listPicture[index].imagepath}",
                                      headers: hedersWithToken,
                                    ))),
                          ],
                        )),
                        Expanded(
                            child: CheckboxListTile(
                          title: Text("web"),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (newVlaue) {
                            imageBloc!
                                .putWeb(
                                    "imagedata/webimage",
                                    _listPicture[index].id.toString(),
                                    newVlaue!)
                                .then((value) {
                              setState(() {
                                _listPicture[index].web =
                                    ImageDom.fromJson(value).web;
                              });
                            });
                          },
                          value: _listPicture[index].web,
                        )),
                        Divider(),
                        Container(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(text: "Коментарий"),
                                TextSpan(
                                  text: _listPicture[index].name!,
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
                                  _imagepath = _listPicture[index].imagepath;
                                  _imageDom = _listPicture[index];
                                  showdialog();
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
                                  Map<String, dynamic> param = {
                                    "id": _listPicture[index].id.toString()
                                  };
                                  imageBloc!
                                      .remove("imagedata/remove", param)
                                      .then((value) {
                                    setState(() {
                                      _listPicture.remove(_listPicture[index]);
                                    });
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

  Future<void> showdialog() {
    if (_imageDom != null) {
      _titleControl.text = _imageDom!.name!;
      _dateprojectControl.text = _imageDom!.datacreate!;
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

                  if (_imageDom == null) {
                    _imageDom = ImageDom();
                  }
                  _imageDom!.name = _titleControl.text;
                  _imageDom!.datacreate = _dateprojectControl.text;

                  imageBloc!
                      .saveImage("imagedata/imageupload", _doma!.id.toString(),
                          _imageDom!.name!, _webImage!)
                      .then((value) {
                    _kompleksBloc!.add(BlocLoadEvent());
                    setState(() {
                      _doma = _listDoma
                          .firstWhere((element) => element.id == _doma!.id);
                    });
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
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
