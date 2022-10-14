import 'package:dskdashboard/bloc/doma_bloc.dart';
import 'package:dskdashboard/bloc/kompleks_bloc.dart';
import 'package:dskdashboard/models/Kompleks.dart';
import 'package:dskdashboard/models/doma.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DomaPage extends StatefulWidget {
  const DomaPage({Key? key}) : super(key: key);

  @override
  State<DomaPage> createState() => _DomaPageState();
}

class _DomaPageState extends State<DomaPage> {
  List<Kompleks>? _listKompleks = [];
  List<Doma>? _listDoma = [];
  late KompleksBloc kompleksBloc;
  late DomaBloc domaBloc;
  Kompleks? _kompleks;
  TextEditingController _nameControl = TextEditingController();
  GlobalKey _keyform = GlobalKey<FormState>();
  Doma? _doma;

  @override
  void initState() {
    super.initState();
    kompleksBloc = BlocProvider.of<KompleksBloc>(context);
    domaBloc = BlocProvider.of<DomaBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();

    kompleksBloc.close();
    domaBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return mainList(context);
  }

  Widget mainList(BuildContext context) {
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
                items: _listKompleks!.map<DropdownMenuItem<Kompleks>>((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.title!),
                  );
                }).toList(),
                value: _kompleks,
                onChanged: (Kompleks? newValue) {
                  domaBloc.getDoma(newValue!.id.toString()).then((value) {
                    _listDoma = value;

                    setState(() {
                      _kompleks = newValue;
                    });
                    // _listDoma!.sort((a,b) => a.id!.compareTo(b.id!));
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
                  _doma = null;
                  showdialogwidget(context, setState);
                },
                child: Text("Добавить")),
          ),
          SizedBox(
            height: 10,
          ),
          getDataTable(context, setState)
        ],
      );
    });
  }

  Widget getDataTable(BuildContext context, setState) {
    return DataTable(
        columns: [
          DataColumn(label: Text("№")),
          DataColumn(label: Text("Наименование")),
          DataColumn(label: Text("Изменить")),
          DataColumn(label: Text("Удалить")),
        ],
        rows: _listDoma!.map((e) {
          return DataRow(cells: [
            DataCell(Text((_listDoma!.indexOf(e) + 1).toString())),
            DataCell(Text(e.name!)),
            DataCell(IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _doma = e;
                showdialogwidget(context, setState).then((value) {
                  // setState(() {
                  //   _listDoma = value;
                  // });
                });
              },
            )),
            DataCell(IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                Map<String, dynamic> param = {'id': e.id.toString()};
                domaBloc.remove("domdelete", param).then((value) {
                  domaBloc.getDoma(_kompleks!.id.toString()).then((value) {
                    setState(() {
                      _listDoma = value;
                    });
                  });
                  // kompleksBloc.add(BlocLoadEvent());
                }).catchError((onError) {
                  print(onError);
                });
              },
            )),
          ]);
        }).toList());
  }

  Future<void> showdialogwidget(BuildContext context, setState) {
    if (_doma != null) {
      _nameControl.text = _doma!.name!;
    } else {
      _nameControl.text = "";
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
                (_kompleks != null)
                    ? Text('№ ${_doma?.id.toString()}')
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
                              return "Просим заполнить пользователя";
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
                if (_doma == null) {
                  _doma = Doma();
                  _doma!.kompleks = _kompleks;
                  _doma!.name = _nameControl.text;
                } else {
                  _doma!.name = _nameControl.text;
                }
                Map<String, dynamic> param = {'id': _kompleks!.id.toString()};

                domaBloc.save("postdom", _doma, param).then((value) {
                  Navigator.of(dialogContext).pop();

                  domaBloc.getDoma(_kompleks!.id.toString()).then((value) {
                    setState(() {
                      _listDoma = value;
                    });
                  }); // Dismiss alert dialog
                }).catchError((error) {
                  print(error);
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
