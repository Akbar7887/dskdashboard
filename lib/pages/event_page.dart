import 'package:dskdashboard/models/Events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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

  @override
  void initState() {
    sourceMeneger = SourceMeneger(listEvent: _controller.eventslist.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
      ],
    );
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
