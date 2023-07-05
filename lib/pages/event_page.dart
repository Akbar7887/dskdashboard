import 'package:dskdashboard/models/Events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../controller/Controller.dart';

class EventPage extends StatefulWidget {
  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late SourceMeneger sourceMeneger;
  final Controller _controller = Get.put(Controller());
  TextEditingController _titleControl = TextEditingController();
  TextEditingController _descriptionControl = TextEditingController();
  TextEditingController _datacreateControl = TextEditingController();
  var formatter = new DateFormat('yyyy-MM-dd');
  final _keyEvents = GlobalKey<FormState>();

  @override
  void initState() {
    sourceMeneger = SourceMeneger(listEvent: _controller.eventslist.value);
    super.initState();
  }

  Future<void> showDialogMeneger() async {
    if (_controller.news.value.id != null) {
      _titleControl.text = _controller.events.value.title!;
      _descriptionControl.text = _controller.events.value.description!;
      _datacreateControl.text =
          formatter.format(DateTime.parse(_controller.events.value.datecreate!));
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
          title: Text('Добавить события'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width/2,
                  child: Form(
                      key: _keyEvents,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        '№ ${_controller.events.value.id.toString()}'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
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
                                    height: 10,
                                  ),
                                  Container(
                                    // height: 100,
                                    // width:
                                    //     MediaQuery.of(context).size.width / 2,
                                    child: TextFormField(
                                        controller: _descriptionControl,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Просим заплнить Описание";
                                          }
                                        },
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 7,
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )),
                        ],
                      )));
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Сохранить'),
              onPressed: () {
                if (!_keyEvents.currentState!.validate()) {
                  return;
                }

                if (_controller.events.value.id == null) {
                  _controller.events.value = Events();
                }

                _controller.events.value.title = _titleControl.text;
                _controller.events.value.description = _descriptionControl.text;

                _controller
                    .save("event/save", _controller.events.value)
                    .then((value) {
                  Events event = Events.fromJson(value);
                });
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            TextButton(
              child: Text('Отменить'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // D

// ismiss alert dialog
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
                "События",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Divider(),
            Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    onPressed: () {
                      showDialogMeneger();

                    },
                    child: Text("Добавить"))),
            SizedBox(height: 10,),
            Expanded(child: dataGrid()),
          ],
        ));
  }

  Widget dataGrid() {
    return SfDataGridTheme(
        data: SfDataGridThemeData(
          headerColor: Colors.blue,
          rowHoverTextStyle: TextStyle(color: Colors.white),
        ),
        child: SfDataGrid(
          source: sourceMeneger,
          // headerGridLinesVisibility: GridLinesVisibility.vertical,
          allowEditing: true,
          columnWidthMode: ColumnWidthMode.fill,
          selectionMode: SelectionMode.single,
          navigationMode: GridNavigationMode.cell,
          allowSorting: true,
          columns: [
            GridColumn(
                columnName: "id",
                label: Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: Text(
                      '№',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
            GridColumn(
                columnName: "title",
                label: Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Заголовок',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
            GridColumn(
                columnName: "description",
                label: Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Описание',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
            GridColumn(
                columnName: "datacreate",
                label: Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Дата создания',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
            GridColumn(
                columnName: "delete",
                label: Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Удалить',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
          ],
        ));
  }
}

class SourceMeneger extends DataGridSource {
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();
  var formatter = new DateFormat('yyyy-MM-dd');

  SourceMeneger({required List<Events> listEvent}) {
    _listDataRow = listEvent
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'id',
                  value: (listEvent.indexOf(e) + 1).toString()),
              DataGridCell<String>(columnName: "title", value: e.title),
              DataGridCell<String>(
                  columnName: "description", value: e.description),
              DataGridCell<String>(
                  columnName: "datecreate",
                  value: formatter.format(DateTime.parse(e.datecreate!))),
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
        child: Icon(Icons.delete),
      ),
    ]);
  }
}
