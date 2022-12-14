import 'package:dskdashboard/bloc/kompleks_bloc.dart';
import 'package:dskdashboard/models/Kompleks.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/bloc_event.dart';
import '../bloc/bloc_state.dart';
import '../models/Dom.dart';

class DomaPage extends StatefulWidget {
  const DomaPage({Key? key}) : super(key: key);

  @override
  State<DomaPage> createState() => _DomaPageState();
}

class _DomaPageState extends State<DomaPage> {
  List<Kompleks>? _listKomleks = [];
  List<Dom>? _listDoma = [];
  Kompleks? _kompleks;
  Dom? _doma;
  KompleksBloc? kompleksBloc;

  TextEditingController _nameControl = TextEditingController();
  final _keyform = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    kompleksBloc = BlocProvider.of<KompleksBloc>(context);
    // domaBloc = BlocProvider.of<DomaBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();

    // kompleksBloc.close();
    // domaBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KompleksBloc, BlocState>(
      builder: (context, state) {
        if (state is BlocEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is BlocLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is KompleksLoadedState) {
          //
          _listKomleks = state.loadedKomleks;
          _listKomleks!.sort((a, b) => a.id!.compareTo(b.id!));
          if (_kompleks != null) {
            _kompleks = _listKomleks!
                .firstWhere((element) => element.id == _kompleks!.id);
            _listDoma = _kompleks!.domSet;
          }

          return mainList(context);
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

  Widget mainList(BuildContext context) {
    return main(context);
  }

  Widget main(BuildContext context) {
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
                items: _listKomleks!.map<DropdownMenuItem<Kompleks>>((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.title!),
                  );
                }).toList(),
                value: _kompleks,
                onChanged: (Kompleks? newValue) {
                  setState(() {
                    _kompleks = newValue;
                    _listDoma = newValue!.domSet!;
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
          getDataTable(context)
        ],
      );
    });
  }

  Widget getDataTable(BuildContext context) {
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
                kompleksBloc?.remove("kompleks/removedom",
                    {"id": e.id.toString()}).then((value) {
                  // setState(() {
                  //   _listDoma!.remove(value);
                  // });
                  kompleksBloc!.add(BlocLoadEvent());

                  // _listDoma.
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
                if (_doma == null) {
                  _doma = Dom();
                  // _doma!.kompleks = _kompleks;
                  _doma!.name = _nameControl.text;
                } else {
                  _doma!.name = _nameControl.text;
                }
                _kompleks!.domSet = [];
                _kompleks!.domSet!.add(_doma!);

                kompleksBloc!.save("kompleks/save", _kompleks).then((value) {
                  kompleksBloc!.add(BlocLoadEvent());
                  Navigator.of(dialogContext).pop();
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
