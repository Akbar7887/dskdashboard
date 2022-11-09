import 'dart:typed_data';

import 'package:dskdashboard/service/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/bloc_event.dart';
import '../bloc/bloc_state.dart';
import '../bloc/make_bloc.dart';
import '../models/Catalog.dart';
import '../models/Make.dart';
import '../ui.dart';

class MakePage extends StatefulWidget {
  const MakePage({Key? key}) : super(key: key);

  @override
  State<MakePage> createState() => _MakePageState();
}

class _MakePageState extends State<MakePage> {
  List<Make> _listMake = [];
  Make? _make;
  TextEditingController _nameContoller = TextEditingController();
  TextEditingController _descriptionContoller = TextEditingController();
  final _keymake = GlobalKey<FormState>();
  Uint8List? _webImage;
  Catalog? _catalog;
  bool _read = true;
  List<Map<String, TextEditingController>> _listController = [];
  List<Catalog> _listCatalogs = [];
  MakeBloc? makeBloc;
  Repository _repository = Repository();

  // getListControl() {
  //   _listController = [
  //   ];
  // }
  //{"name": "", "concrete": "", "heigth": "", "length": "", "mass": "", "volume": "",  "description": "наименование"},

  @override
  void initState() {
    super.initState();
    // getListControl();
    makeBloc = BlocProvider.of<MakeBloc>(context);
  }

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

            if (_make != null) {
              _make =
                  _listMake.firstWhere((element) => element.id == _make!.id);
              _listCatalogs = _make!.catalogs!;
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
                _listCatalogs = [];
                _listController = [];
                showDialogMake();
              },
              child: Text("Добавить"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
            )),
        Container(child: dataTable(context))
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
              _webImage = null;
              _listController = [];

              _listCatalogs = (_make!.catalogs == null ? [] : _make!.catalogs)!;
              _listCatalogs.sort((a, b) => a.id!.compareTo(b.id!));
              fillController();
              showDialogMake();
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

  Future<void> showDialogMake() async {
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
                                          _make == null
                                              ? ''
                                              : '${Ui.url}make/download/makes/${_make!.imagepath}',
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
                                _listCatalogs.add(catalog);
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
                  if (_make == null) {
                    _make = Make();
                  }
                  filllistCatalog();
                  _make!.catalogs = _listCatalogs;
                  _make!.name = _nameContoller.text;
                  _make!.description = _descriptionContoller.text;
                  makeBloc!.save("make/save", _make!).then((value) {
                    _make = Make.fromJson(value);
                    if (_webImage != null) {
                      makeBloc!
                          .postWeb(
                              "make/upload", _make!.id.toString(), _webImage!)
                          .then((value) {
                        _webImage = null;
                        makeBloc!.add(BlocLoadEvent());
                        Navigator.pop(
                            dialogContext, true); // Dismiss alert dialog
                      });
                    } else {
                      makeBloc!.add(BlocLoadEvent());
                      Navigator.pop(dialogContext, true); // D
                    }

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
    _listCatalogs.forEach((element) {
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
      _listCatalogs[_listController.indexOf(element)].name =
          element["name"]!.text;
      _listCatalogs[_listController.indexOf(element)].heigth =
          element["heigth"]!.text;
      _listCatalogs[_listController.indexOf(element)].weigth =
          element["weigth"]!.text;
      _listCatalogs[_listController.indexOf(element)].volume =
          element["volume"]!.text;
      _listCatalogs[_listController.indexOf(element)].length =
          element["length"]!.text;
      _listCatalogs[_listController.indexOf(element)].mass =
          element["mass"]!.text;
      _listCatalogs[_listController.indexOf(element)].concrete =
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
          rows: _listCatalogs
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
                          _repository.delete("catalog/remove",
                              {"id": e.id.toString()}).then((value) {
                            setState(() {
                              _listCatalogs.remove(e);
                              fillController();
                            });
                          }).catchError((e) {
                            setState(() {
                              _listCatalogs.remove(e);
                              fillController();

                            });
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
