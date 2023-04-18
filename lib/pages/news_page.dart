import 'dart:typed_data';
import 'package:dskdashboard/controller/Controller.dart';
import 'package:dskdashboard/main.dart';
import 'package:dskdashboard/models/News.dart';
import 'package:dskdashboard/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:video_player/video_player.dart';
import '../models/Meneger.dart';
import '../widgets/video.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late SourceMeneger sourceMeneger;
  TextEditingController _titleControl = TextEditingController();
  TextEditingController _descriptionControl = TextEditingController();
  TextEditingController _datacreateControl = TextEditingController();
  Uint8List? _webImage;
  Uint8List? _webVideo;
  final _keyNews = GlobalKey<FormState>();
  var formatter = new DateFormat('yyyy-MM-dd');
  final Controller _controller = Get.put(Controller());
  String? _videoname;

  Future<void> showDialogMeneger() async {
    if (_controller.news.value.id != null) {
      _titleControl.text = _controller.news.value.title!;
      _descriptionControl.text = _controller.news.value.description!;
      _datacreateControl.text =
          formatter.format(DateTime.parse(_controller.news.value.datacreate!));
    } else {
      _titleControl.clear();
      _descriptionControl.clear();
      _datacreateControl.clear();
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
              void update() {
                setState(() {
                  if (_controller.news.value.id != null) {
                    _controller.news.value = _controller.newses.value
                        .firstWhere((element) =>
                            element.id == _controller.news.value.id);
                  }
                });
              }

              return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
                              child: Card(
                                  child: Row(
                            children: [
                              Expanded(
                                  child: Column(children: [
                                Container(
                                  child: Text(
                                    "Основное видео",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      XFile? image = await ImagePicker()
                                          .pickVideo(
                                              source: ImageSource.gallery);
                                      if (image != null) {
                                        _videoname = image.name;
                                        var f = await image.readAsBytes();
                                        setState(() {
                                          _webVideo = f;
                                        });
                                      }
                                    },
                                    child: Text("Загрузить видео..")),
                                Divider(),
                                // _webVideo == null
                                //     ?

                                Container(
                                    width: 300,
                                    height: 150,
                                    child: _controller.news.value.id != null
                                        ? VideoVistavka(
                                            url:
                                                '${Ui.url}news/download/newsvideo/${_controller.news.value.videopath}')
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          ))
                                // : Container(
                                //     child:
                                //   ),
                              ])),
                              Expanded(
                                  child: Column(children: [
                                Container(
                                  child: Text(
                                    "Основное фото",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                                    child: Text("Загрузить фото..")),
                                Divider(),
                                Container(
                                    width: 300,
                                    height: 150,
                                    child: _webImage == null
                                        ? Image.network(
                                            _controller.news.value.id == null
                                                ? ""
                                                : '${Ui.url}news/download/news/${_controller.news.value.imagepath}',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
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
                                          )),
                              ])),
                              SizedBox(
                                width: 20,
                              ),
                              VerticalDivider(),
                              Expanded(
                                  child: _controller.news.value.id == null
                                      ? Container()
                                      : Column(
                                          children: [
                                            Container(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  XFile? image =
                                                      await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                  if (image != null) {
                                                    var f = await image
                                                        .readAsBytes();
                                                    _controller
                                                        .postImage(
                                                            "news/imagenewsupload",
                                                            _controller
                                                                .news.value.id
                                                                .toString(),
                                                            f)
                                                        .then((value) {
                                                      _controller.fetchAll(
                                                          "news/get", News());
                                                    });
                                                    // setState(() {
                                                    //   _webImage = f;
                                                    // });
                                                  }
                                                },
                                                child:
                                                    Text("Добавить доп фото"),
                                              ),
                                            ),
                                            Divider(),
                                            Expanded(
                                                child: _controller
                                                            .news.value.id ==
                                                        null
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : ListView.builder(
                                                        itemCount: _controller
                                                            .news
                                                            .value
                                                            .imageNewsList!
                                                            .length,
                                                        itemBuilder:
                                                            (context, idx) {
                                                          return Container(
                                                            child: Card(
                                                                child: Image.network(
                                                                    _controller.news.value.id ==
                                                                            null
                                                                        ? ''
                                                                        : '${Ui.url}news/download/imagenews/${_controller.news.value.imageNewsList![idx].imagepath}',
                                                                    height: 200,
                                                                    width: 100,
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                              return Icon(
                                                                  Icons.photo);
                                                            })),
                                                          );
                                                        }))
                                          ],
                                        ))
                            ],
                          )))
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

                if (_controller.news.value.id == null) {
                  _controller.news.value = News();
                }

                _controller.news.value.title = _titleControl.text;
                _controller.news.value.description = _descriptionControl.text;
                _controller.news.value.datacreate = _datacreateControl.text;

                _controller
                    .save("news/save", _controller.news.value)
                    .then((value) {
                  News news = News.fromJson(value);
                  if (_webImage != null) {
                    _controller
                        .postImage(
                            "news/upload", news.id.toString(), _webImage!)
                        .then((value) {
                      _webImage = null;
                      _controller.fetchAll("news/get", News());
                    });
                  } else {
                    _controller.fetchAll("news/get", News());
                    Navigator.of(dialogContext).pop();
                  }
                  if (_webVideo != null) {
                    _controller
                        .saveVideo("news/videoupload",
                            _controller.news.value.id.toString(), _webVideo!)
                        .then((value) {
                      _webVideo = null;
                      _controller.fetchAll("news/get", News());

                      Navigator.of(dialogContext).pop();
                    });
                  } else {
                    _controller.fetchAll("news/get", News());
                  }
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog

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
                      _controller.news = News().obs;
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
                            _controller.news.value = _controller
                                .newses.value[cell.rowColumnIndex.rowIndex - 1];
                            _webImage = null;
                            showDialogMeneger();
                          }
                          if (cell.rowColumnIndex.columnIndex == 5) {
                            _controller.news.value = _controller
                                .newses.value[cell.rowColumnIndex.rowIndex - 1];
                            _controller
                                .removeById("news/remove",
                                    _controller.news.value.id.toString())
                                .then((value) {
                              _controller.fetchAll("news/get", News());
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
                  columnName: "datecreate",
                  value: formatter.format(DateTime.parse(e.datacreate!))),
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
