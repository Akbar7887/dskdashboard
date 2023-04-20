import 'package:dskdashboard/controller/Controller.dart';
import 'package:dskdashboard/models/Kompleks.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/Dom.dart';

// List<Kompleks>? _listKomleks = [];
// List<Dom>? _listDoma = [];
// Kompleks? _kompleks;
// Dom? _doma;
TextEditingController _nameControl = TextEditingController();
final _keyform = GlobalKey<FormState>();
final Controller _controller = Get.find();
Kompleks? _dropdownKompleks = _controller.komplekses.value.length != 0
    ? _controller.komplekses.value[0]
    : null;

class DomaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return ListView(
        children: [
          Container(
            height: 50,
            alignment: Alignment.center,
            child: Text(
              "Дома",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Divider(),
          Container(
              padding: EdgeInsets.only(left: 100, right: 100),
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
                value: _dropdownKompleks,
                onChanged: (Kompleks? newValue) {
                  setState(() {
                    _dropdownKompleks = newValue!;
                    _controller.kompleks.value = newValue;
                    _controller.doms.value = newValue.domSet!;
                  });
                },
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black54)),
                onPressed: () {
                  _controller.dom = Dom().obs;
                  showdialogwidget(context);
                },
                child: Text("Добавить")),
          ),
          SizedBox(
            height: 10,
          ),
          getDataTable(context)
        ],
      );
    });
  }

  Widget getDataTable(BuildContext context) {
    return Obx(() => DataTable(
            columns: [
              DataColumn(label: Text("№")),
              DataColumn(label: Text("Наименование")),
              DataColumn(label: Text("Изменить")),
              DataColumn(label: Text("Удалить")),
            ],
            rows: _controller.doms.value.map((e) {
              return DataRow(cells: [
                DataCell(
                    Text((_controller.doms.value.indexOf(e) + 1).toString())),
                DataCell(Text(e.name!)),
                DataCell(IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _controller.dom.value = e;
                    showdialogwidget(context);
                  },
                )),
                DataCell(IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () {
                    _controller
                        .removeById("kompleks/removedom", e.id.toString())
                        .then((value) {
                      _controller.doms.value.remove(e);
                      _controller.doms.refresh();
                    });
                  },
                )),
              ]);
            }).toList()));
  }

  Future<void> showdialogwidget(BuildContext context) {
    if (_controller.dom.value.id != null) {
      _nameControl.text = _controller.dom.value!.name!;
    } else {
      _nameControl.clear();
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Справочник Дома'),
          content: Container(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (_controller.kompleks.value != null)
                    ? Text('№ ${_controller.dom.value!.id.toString()}')
                    : Text('№'),
                SizedBox(
                  height: 30,
                ),
                Container(
                    width: 400,
                    child: Form(
                      key: _keyform,
                      child: TextFormField(
                          controller: _nameControl,
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
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)))),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Сохранить'),
              onPressed: () {
                if (!_keyform.currentState!.validate()) {
                  return;
                }
                if (_controller.dom.value.id == null) {
                  _controller.dom.value = Dom();
                  // _doma!.kompleks = _kompleks;
                  _controller.dom.value.name = _nameControl.text;
                } else {
                  _controller.dom.value.name = _nameControl.text;
                }
                _controller
                    .saveWithParentId("dom/save", _controller.dom.value,
                        _dropdownKompleks!.id.toString())
                    .then((value) {
                  _controller
                      .getById("dom/v1/get", _dropdownKompleks!.id.toString())
                      .then((value) {
                    _controller.doms.value =
                        value.map((e) => Dom.fromJson(e)).toList();
                    _controller.doms.refresh();
                    Navigator.of(dialogContext).pop();
                  });
                  // _controller.fetchAll("kompleks/get", Kompleks());
                }).whenComplete(() {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
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
      },
    );
  }
}
