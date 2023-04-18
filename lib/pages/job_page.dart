import 'package:dskdashboard/controller/Controller.dart';
import 'package:dskdashboard/models/Job.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/Joblist.dart';

final _keyformjobs = GlobalKey<FormState>();
TextEditingController _vacancyControl = TextEditingController();
TextEditingController _departmentContoller = TextEditingController();
List<TextEditingController> _listConrtoller = [];
List<bool> _listtitle = [];
List<bool> _listenable = [];
final Controller _controller = Get.put(Controller());
var formatter = new DateFormat('yyyy-MM-dd');


class JobPage extends StatelessWidget {

  void fillListController() {
    _listConrtoller = [];
    _listtitle = [];
    _listenable = [];

    _controller.joslists.value.map((e) {
      TextEditingController _texcontoller = TextEditingController();
      _texcontoller.text = e.description == null ? "" : e.description!;
      _listConrtoller.add(_texcontoller);
      _listtitle.add(e.title == null ? false : e.title!);
      _listenable.add(e.title == null ? true : false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
      children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            "Вакансии",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Divider(),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black54)),
              onPressed: () {
                _controller.job = Job().obs;
                _controller.joslists.value = [];

                showdialogwidget(context);
              },
              child: Text("Добавить")),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            // color: Colors.black87,
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: DataTable(
                    key: UniqueKey(),
                    sortAscending: true,
                    sortColumnIndex: 0,
                    headingRowColor: MaterialStateProperty.all(Colors.blue),
                    headingTextStyle: TextStyle(color: Colors.white),
                    columns: [
                      DataColumn(label: Text("№")),
                      DataColumn(label: Text("Вакансия")),
                      DataColumn(label: Text("Департамент")),
                      DataColumn(label: Text("Изменить")),
                      DataColumn(label: Text("Удалить")),
                    ],
                    rows: _controller.jobs.value.map((e) {
                      return DataRow(cells: [
                        DataCell(Text((_controller.jobs.value.indexOf(e) + 1)
                            .toString())),
                        DataCell(Text(e.vacancy!)),
                        DataCell(Text(e.department!)),
                        DataCell(IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _controller.job.value = e;
                            _controller.joslists.value =
                                _controller.job.value.joblist!;
                            fillListController();
                            showdialogwidget(context);
                          },
                        )),
                        DataCell(IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            _controller
                                .removeById("job/remove", e.id.toString())
                                .then((value) {
                              _controller.fetchAll("job/get", Job());
                            }).catchError((onError) {
                              print(onError);
                            });
                          },
                        )),
                      ]);
                    }).toList())))
      ],
    ));
  }

  Future<void> showdialogwidget(BuildContext context) {
    if (_controller.job.value.id != null) {
      _vacancyControl.text = _controller.job.value.vacancy!;
      _departmentContoller.text = _controller.job.value.department!;
    } else {
      _vacancyControl.clear();
      _departmentContoller.clear();
    }

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            // fillListController();
            void removeItem(int idx) {
              setState(() {
                _controller.joslists.value.removeAt(idx);
              });
            }

            return AlertDialog(
              // key: UniqueKey(),
              title: Text('Вакансия'),
              content: Container(
                  height: MediaQuery.of(context).size.height / 1.1,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Form(
                      key: _keyformjobs,
                      child: Row(children: [
                        Expanded(
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (_controller.job.value.id != null)
                                  ? Text(
                                      '№ ${_controller.job.value.id.toString()}')
                                  : Text('№'),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                    controller: _vacancyControl,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Просим заполнить вакансию";
                                      }
                                    },
                                    style: GoogleFonts.openSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w200,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        //Theme.of(context).backgroundColor,
                                        labelText: "Вакансия",
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
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                    controller: _departmentContoller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Просим заполнить Департамент";
                                      }
                                    },
                                    style: GoogleFonts.openSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w200,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        //Theme.of(context).backgroundColor,
                                        labelText: "Департамент",
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
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            flex: 2,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          Joblist joblist = Joblist();
                                          _controller.joslists.value
                                              .add(joblist);
                                          fillListController();
                                        });
                                      },
                                      child: Text("Добавить")),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                      child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: DataTable(
                                              headingRowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.blue),
                                              columnSpacing: 150,
                                              headingTextStyle: TextStyle(
                                                  color: Colors.white),
                                              columns: [
                                                DataColumn(
                                                    label: Text("Заголовок")),
                                                DataColumn(
                                                    label: Text("Описание")),
                                                DataColumn(
                                                    label: Text("Изменить")),
                                                DataColumn(
                                                    label: Text("Удалить")),
                                              ],
                                              rows: _controller.joslists.value
                                                  .map((e) {
                                                return DataRow(cells: [
                                                  DataCell(
                                                    Checkbox(
                                                      value: _listtitle[
                                                          _controller
                                                              .joslists.value
                                                              .indexOf(e)],
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          _listtitle[_controller
                                                              .joslists.value
                                                              .indexOf(
                                                                  e)] = value!;
                                                        });
                                                        e.title = value;
                                                      },
                                                    ),
                                                  ),
                                                  DataCell(
                                                    TextFormField(
                                                      controller:
                                                          _listConrtoller[
                                                              _controller
                                                                  .joslists
                                                                  .value
                                                                  .indexOf(e)],
                                                      enabled: _listenable[
                                                          _controller
                                                              .joslists.value
                                                              .indexOf(e)],
                                                      showCursor: _listenable[
                                                          _controller
                                                              .joslists.value
                                                              .indexOf(e)],
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Просим заполнить описание";
                                                        }
                                                      },
                                                      onChanged: (newvalue) {
                                                        e.description =
                                                            newvalue;
                                                      },
                                                    ),
                                                  ),
                                                  DataCell(IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      setState(() {
                                                        _listenable[_controller
                                                                .joslists.value
                                                                .indexOf(e)] =
                                                            !_listenable[
                                                                _controller
                                                                    .joslists
                                                                    .value
                                                                    .indexOf(
                                                                        e)];
                                                      });
                                                    },
                                                  )),
                                                  DataCell(IconButton(
                                                    icon: Icon(
                                                        Icons.delete_forever),
                                                    onPressed: () {
                                                      removeItem(_controller
                                                          .joslists.value
                                                          .indexOf(e));

                                                      _controller
                                                          .removeById(
                                                              "job/removeitem",
                                                              e.id.toString())
                                                          .then((value) {
                                                        setState(() {
                                                          _controller.fetchAll(
                                                              "job/get", Job());
                                                        });
                                                      });
                                                    },
                                                  )),
                                                ]);
                                              }).toList()))),
                                ])),
                      ]))),
              actions: <Widget>[
                TextButton(
                  child: Text('Сохранить'),
                  onPressed: () {
                    if (_controller.job.value.id == null) {
                      _controller.job.value = Job();
                    } else {}

                    if (!_keyformjobs.currentState!.validate()) {
                      return;
                    }

                    _controller.job.value.vacancy = _vacancyControl.text;
                    _controller.job.value.department =
                        _departmentContoller.text;
                    _controller.job.value.joblist = _controller.joslists.value;
                    _controller
                        .save("job/save", _controller.job.value)
                        .then((value) {
                      _controller.fetchAll("job/get", Job()).then((value) {
                        // _controller.jobs.refresh();
                        Navigator.of(dialogContext).pop();
                      });

                      // _webImage = null;
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
        });
  }
}
