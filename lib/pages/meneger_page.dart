import 'dart:typed_data';
import 'package:dskdashboard/controller/Controller.dart';
import 'package:dskdashboard/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/Meneger.dart';



final _keyMeneger = GlobalKey<FormState>();

class MenegerPage extends  StatefulWidget {
  @override
  State<MenegerPage> createState() => _MenegerPageState();
}

class _MenegerPageState extends State<MenegerPage> {
  late SourceMeneger sourceMeneger;
  TextEditingController _nameControl = TextEditingController();
  TextEditingController _phoneControl = TextEditingController();
  TextEditingController _emailControl = TextEditingController();
  TextEditingController _postControl = TextEditingController();
  Uint8List? _webImage;
  final Controller _controller = Get.put(Controller());


  @override
  void initState() {
    sourceMeneger = SourceMeneger(listMeneger: _controller.menegers.value);

    super.initState();
  }

  Future<void> showDialogMeneger(BuildContext context) async {
    if (_controller.meneger.value.id != null) {
      _nameControl.text = _controller.meneger.value.name!;
      _phoneControl.text = _controller.meneger.value.phone!;
      _emailControl.text = _controller.meneger.value.email!;
      _postControl.text = _controller.meneger.value.post!;
    } else {
      _nameControl.clear();
      _phoneControl.clear();
      _emailControl.clear();
      _postControl.clear();
    }
    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Добавить Руководителя'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Form(
                      key: _keyMeneger,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: TextFormField(
                                controller: _nameControl,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Просим заплнить ФИО";
                                  }
                                },
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    //Theme.of(context).backgroundColor,
                                    labelText: "ФИО",
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
                                controller: _phoneControl,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Просим заплнить телефон";
                                  }
                                },
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    //Theme.of(context).backgroundColor,
                                    labelText: "Телефон",
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
                                controller: _emailControl,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Просим заплнить эл. почту";
                                  }
                                },
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    //Theme.of(context).backgroundColor,
                                    labelText: "Эл. почта ",
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
                                controller: _postControl,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Просим заплнить должность";
                                  }
                                },
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    //Theme.of(context).backgroundColor,
                                    labelText: "Должность",
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
                                        _controller.meneger.value.id == null
                                            ? ""
                                            : '${Ui.url}meneger/v1/download/meneger/${_controller.meneger.value.imagepath}',
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2,
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          return Icon(Icons.photo);
                                        },
                                        // loadingBuilder: (BuildContext context,
                                        //     Widget child,
                                        //     ImageChunkEvent? loadingProgress) {
                                        //   return Center(
                                        //     child: CircularProgressIndicator(),
                                        //   );
                                        // },
                                      )
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
                      )));
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Сохранить'),
              onPressed: () {
                if (!_keyMeneger.currentState!.validate()) {
                  return;
                }

                if (_controller.meneger.value.id == null) {
                  _controller.meneger.value = Meneger();
                }

                _controller.meneger.value.name = _nameControl.text;
                _controller.meneger.value.email = _emailControl.text;
                _controller.meneger.value.phone = _phoneControl.text;
                _controller.meneger.value.post = _postControl.text;

                _controller
                    .save("meneger/save", _controller.meneger.value)
                    .then((value) {
                  Meneger men = Meneger.fromJson(value);
                  if (_webImage != null) {
                    _controller
                        .postImage(
                            "meneger/upload", men.id.toString(), _webImage!)
                        .then((value) {
                      _controller
                          .fetchAll("meneger/v1/get", Meneger())
                          .then((value) {
                            setState(() {
                              sourceMeneger = SourceMeneger(listMeneger: _controller.menegers.value);
                            });

                        Navigator.of(dialogContext).pop();
                      });
                    });
                  } else {
                    _controller
                        .fetchAll("meneger/v1/get", Meneger())
                        .then((value) {
                      setState(() {
                        sourceMeneger = SourceMeneger(listMeneger: _controller.menegers.value);
                      });

                      Navigator.of(dialogContext).pop();
                    });
                  }
                });
              },
            ),
            TextButton(
              child: Text('Отменить'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                "Руководство",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Divider(),
            Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    onPressed: () {
                      _webImage = null;
                      _controller.meneger = Meneger().obs;
                      showDialogMeneger(context);
                      // setState(() {
                      //   Meneger meneger = Meneger();
                      //   _listMeneger.add(meneger);
                      // });
                    },
                    child: Text("Добавить"))),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                        headerColor: Colors.blue,
                        rowHoverTextStyle: TextStyle(color: Colors.white)),
                    child: SfDataGrid(
                        source: sourceMeneger,

                        // headerGridLinesVisibility: GridLinesVisibility.vertical,
                        allowEditing: true,
                        columnWidthMode: ColumnWidthMode.fill,
                        selectionMode: SelectionMode.single,
                        navigationMode: GridNavigationMode.cell,
                        allowSorting: true,
                        onCellTap: (cell) {
                          if (cell.rowColumnIndex.columnIndex == 5) {
                            _controller.meneger.value = _controller.menegers
                                .value[cell.rowColumnIndex.rowIndex - 1];
                            _webImage = null;
                            showDialogMeneger(context);
                          }
                          if (cell.rowColumnIndex.columnIndex == 6) {
                            _controller.meneger.value = _controller.menegers
                                .value[cell.rowColumnIndex.rowIndex - 1];
                            _controller
                                .removeById("meneger/remove",
                                    _controller.meneger.value.id.toString())
                                .then((value) {
                              _controller.fetchAll("meneger/v1/get", Meneger());
                            });
                          }
                        },
                        columns: [
                          GridColumn(
                              columnName: "id",
                              label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '№',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              columnName: "name",
                              label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'ФИО',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              columnName: "phone",
                              label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'телефон',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              columnName: "email",
                              label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'э-почта',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              columnName: "post",
                              label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'должность',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              columnName: "edit",
                              label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Изменить',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              columnName: "delete",
                              label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Удалить',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                        ])))
          ],
        ));
  }

  DataGridCellDoubleTapDetails(
      {required RowColumnIndex rowColumnIndex, required GridColumn column}) {}
}

class SourceMeneger extends DataGridSource {
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  SourceMeneger({required List<Meneger> listMeneger}) {
    _listDataRow = listMeneger
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'id',
                  value: (listMeneger.indexOf(e) + 1).toString()),
              DataGridCell<String>(columnName: "name", value: e.name),
              DataGridCell<String>(columnName: "phone", value: e.phone),
              DataGridCell<String>(columnName: "email", value: e.email),
              DataGridCell<String>(columnName: "post", value: e.post),
              DataGridCell<Icon>(columnName: "edit", value: Icon(Icons.edit)),
              DataGridCell<Icon>(
                  columnName: "delete", value: Icon(Icons.delete)),
            ]))
        .toList();
  }

  List<DataGridRow> _listDataRow = [];

  List<DataGridRow> get rows => _listDataRow;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(row.getCells()[1].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(row.getCells()[2].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(row.getCells()[3].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(row.getCells()[4].value.toString()),
      ),
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.edit)),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.delete),
      ),
    ]);
  }
}
