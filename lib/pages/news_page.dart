import 'dart:typed_data';

import 'package:dskdashboard/bloc/news_bloc.dart';
import 'package:dskdashboard/models/News.dart';
import 'package:dskdashboard/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../bloc/bloc_event.dart';
import '../bloc/bloc_state.dart';
import '../models/Meneger.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<News> _listNews = [];
  late SourceMeneger sourceMeneger;
  TextEditingController _titleControl = TextEditingController();
  TextEditingController _descriptionControl = TextEditingController();
  TextEditingController _datacreateControl = TextEditingController();
  Uint8List? _webImage;
  News? _news;
  final _keyNews = GlobalKey<FormState>();
  late NewsBloc _newsBloc;
  var formatter = new DateFormat('yyyy-MM-dd');

  // TextEditingController _nameControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newsBloc = BlocProvider.of(context);
  }

  Future<void> showDialogMeneger() async {
    if (_news != null) {
      _titleControl.text = _news!.title!;
      _descriptionControl.text = _news!.description!;
      _datacreateControl.text = formatter.format(DateTime.parse(_news!.datacreate!));
    } else {
      _titleControl.text = "";
      _descriptionControl.text = "";
      _datacreateControl.text = "";
    }
    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Добавить новость'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Form(
                      key: _keyNews,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: TextFormField(
                                controller: _titleControl,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Просим заплнить заголовок";
                                  }
                                },
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    //Theme.of(context).backgroundColor,
                                    labelText: "Заголовок",
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
                                controller: _descriptionControl,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Просим заплнить Описание";
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
                                controller: _datacreateControl,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Просим заплнить дату";
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
                                      _datacreateControl.text =
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
                                    labelText: "Дата создание",
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
                                        _news == null
                                            ? ""
                                            : '${Ui.url}news/download/news/${_news!.imagepath}',
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
                if (!_keyNews.currentState!.validate()) {
                  return;
                }

                if (_news == null) {
                  _news = News();
                }

                _news!.title = _titleControl.text;
                _news!.description = _descriptionControl.text;
                _news!.datacreate = _datacreateControl.text;

                _newsBloc.save("news/save", _news).then((value) {
                  Meneger men = Meneger.fromJson(value);
                  if (_webImage != null) {
                    _newsBloc
                        .postWeb(
                            "news/newsupload", men.id.toString(), _webImage!)
                        .then((value) {
                      _newsBloc.add(BlocLoadEvent());
                      Navigator.of(dialogContext).pop();
                    });
                  } else {
                    _newsBloc.add(BlocLoadEvent());
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
    return BlocConsumer<NewsBloc, BlocState>(
      builder: (context, state) {
        if (state is BlocEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is BlocLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is NewsLoadedState) {
          //
          _listNews = state.loadedNews;
          _listNews.sort((a, b) => a.id!.compareTo(b.id!));
          sourceMeneger = SourceMeneger(listNews: _listNews);

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
                "Новости",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Divider(),
            Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    onPressed: () {
                      _webImage = null;
                      _news = null;
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
                          if (cell.rowColumnIndex.columnIndex == 4) {
                            _news = _listNews[cell.rowColumnIndex.rowIndex - 1];
                            _webImage = null;
                            showDialogMeneger();
                          }
                          if (cell.rowColumnIndex.columnIndex == 5) {
                            _news = _listNews[cell.rowColumnIndex.rowIndex - 1];
                            _newsBloc.remove("news/remove",
                                {"id": _news!.id.toString()}).then((value) {
                              _newsBloc.add(BlocLoadEvent());
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
                              columnName: "title",
                              label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Заголовок',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              columnName: "description",
                              label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Описание',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              columnName: "datacreate",
                              label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Дата создания',
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
   var formatter = new DateFormat('yyyy-MM-dd');

  SourceMeneger({required List<News> listNews}) {
    _listDataRow = listNews
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'id',
                  value: (listNews.indexOf(e) + 1).toString()),
              DataGridCell<String>(columnName: "title", value: e.title),
              DataGridCell<String>(
                  columnName: "description", value: e.description),
              DataGridCell<String>(
                  columnName: "datecreate", value: formatter.format(DateTime.parse(e.datacreate!))),
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
          child: Icon(Icons.edit)),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.delete),
      ),
    ]);
  }
}
