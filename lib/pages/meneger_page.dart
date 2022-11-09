import 'dart:typed_data';

import 'package:dskdashboard/bloc/meneger_Bloc.dart';
import 'package:dskdashboard/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../bloc/bloc_event.dart';
import '../bloc/bloc_state.dart';
import '../models/Meneger.dart';
import '../service/repository.dart';

class MenegerPage extends StatefulWidget {
  const MenegerPage({Key? key}) : super(key: key);

  @override
  State<MenegerPage> createState() => _MenegerPageState();
}

class _MenegerPageState extends State<MenegerPage> {
  List<Meneger> _listMeneger = [];
  late SourceMeneger sourceMeneger;
  TextEditingController _nameControl = TextEditingController();
  TextEditingController _phoneControl = TextEditingController();
  TextEditingController _emailControl = TextEditingController();
  TextEditingController _postControl = TextEditingController();
  Uint8List? _webImage;
  Meneger? _meneger;
  final _keyMeneger = GlobalKey<FormState>();
  late MenegerBloc _menegerBloc;

  // TextEditingController _nameControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _menegerBloc = BlocProvider.of(context);
  }

  Future<void> showDialogMeneger() async {
    if (_meneger != null) {
      _nameControl.text = _meneger!.name!;
      _phoneControl.text = _meneger!.phone!;
      _emailControl.text = _meneger!.email!;
      _postControl.text = _meneger!.post!;
    } else {
      _nameControl.text = "";
      _phoneControl.text = "";
      _emailControl.text = "";
      _postControl.text = "";
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
                                        _meneger == null
                                            ? ""
                                            : '${Ui.url}meneger/download/meneger/${_meneger!.imagepath}',
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

                if (_meneger == null) {
                  _meneger = Meneger();
                }

                _meneger!.name = _nameControl.text;
                _meneger!.email = _emailControl.text;
                _meneger!.phone = _phoneControl.text;
                _meneger!.post = _postControl.text;

                _menegerBloc.save("meneger/save", _meneger).then((value) {
                  Meneger men = Meneger.fromJson(value);
                  if (_webImage != null) {
                    _menegerBloc
                        .postWeb("meneger/upload", men.id.toString(),
                            _webImage!)
                        .then((value) {
                      _menegerBloc.add(BlocLoadEvent());
                      Navigator.of(dialogContext).pop();
                    });
                  } else {
                    _menegerBloc.add(BlocLoadEvent());
                    Navigator.of(dialogContext).pop();
                  }
                  // Dismiss alert dialog
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
    return BlocConsumer<MenegerBloc, BlocState>(
      builder: (context, state) {
        if (state is BlocEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is BlocLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is MenegerLoadedState) {
          //
          _listMeneger = state.loadedMeneger;
          _listMeneger.sort((a, b) => a.id!.compareTo(b.id!));
          sourceMeneger = SourceMeneger(listMeneger: _listMeneger);

          return mainWidget();
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

  Widget mainWidget() {
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
                      _meneger = null;
                      showDialogMeneger();
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
                child:SfDataGridTheme(
                  data:  SfDataGridThemeData(headerColor: Colors.blue, rowHoverTextStyle: TextStyle(color: Colors.white)),
                    child:  SfDataGrid(
                    source: sourceMeneger,

                    // headerGridLinesVisibility: GridLinesVisibility.vertical,
                    allowEditing: true,
                    columnWidthMode: ColumnWidthMode.fill,
                    selectionMode: SelectionMode.single,
                    navigationMode: GridNavigationMode.cell,
                    allowSorting: true,
                    onCellTap: (cell) {
                      if (cell.rowColumnIndex.columnIndex == 5) {
                        _meneger =
                            _listMeneger[cell.rowColumnIndex.rowIndex - 1];
                        _webImage = null;
                        showDialogMeneger();
                      }
                      if (cell.rowColumnIndex.columnIndex == 6) {
                        _meneger =
                            _listMeneger[cell.rowColumnIndex.rowIndex - 1];
                        _menegerBloc.remove("meneger/remove",
                            {"id": _meneger!.id.toString()}).then((value) {
                          _menegerBloc.add(BlocLoadEvent());
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
              DataGridCell<Icon>(columnName: "delete", value: Icon(Icons.delete)),
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
