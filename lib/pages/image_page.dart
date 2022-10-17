import 'package:dskdashboard/bloc/image_Bloc.dart';
import 'package:dskdashboard/models/Kompleks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../bloc/bloc_state.dart';
import '../bloc/kompleks_bloc.dart';
import '../models/Dom.dart';
import '../models/ImageData.dart';
import '../ui.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  List<Kompleks>? _listKomleks = [];
  Kompleks? _kompleks;
  List<Dom> _listDoma = [];
  Dom? _doma;

  // DomaBloc? _domaBloc;
  ImageBloc? imageBloc;
  List<ImageDom> _listPicture = [];
  FlutterSecureStorage _storage = FlutterSecureStorage();
  late Map<String, String> hedersWithToken;
  int _indexImage = 0;

  // late final Repository repository;

  Future<void> getToken() async {
    String? token = await _storage.read(key: "token");

    hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    imageBloc = BlocProvider.of<ImageBloc>(context);
    // _domaBloc = BlocProvider.of<DomaBloc>(context);
    return BlocConsumer<KompleksBloc, BlocState>(
      builder: (context, state) {
        if (state is BlocEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is BlocLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is KompleksLoadedState) {
          _listKomleks = state.loadedKomleks;
          _listKomleks!.sort((a, b) => a.id!.compareTo(b.id!));
          // _if(_listKomleks.length > 0){
          //   _doma = _listKomleks[0].;
          // }

          return mainList();
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

  Widget mainList() {
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Фото материала по Комплексу и по домам",
              style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w200,
                  color: Colors.black),
            )),
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.only(left: 100, right: 100),
            child: Row(
              children: [
                Expanded(
                    child: DropdownButton<Kompleks>(
                        isExpanded: true,
                        hint: Text("Комплексы"),
                        items:
                            _listKomleks!.map<DropdownMenuItem<Kompleks>>((e) {
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
                        })),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: DropdownButton<Dom>(
                        isExpanded: true,
                        hint: Text("Дома"),
                        items: _listDoma.map<DropdownMenuItem<Dom>>((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e.name!),
                          );
                        }).toList(),
                        value: _doma,
                        onChanged: (Dom? newValue) {
                          setState(() {
                            _doma = newValue;
                            _listPicture = _doma!.imagedom!;
                          });

                        })),
              ],
            )),
        SizedBox(
          height: 20,
        ),
        // Expanded(child: Text("ekjhglkerhge"),)
        Expanded(
          child: Row(children: [
            _doma != null ? Expanded(child: imageTable()) : Container(),
            Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    elevation: 5,
                    child: _listPicture.length > 0
                        ? Image.network(
                            "${Ui.url}les/download/images/${_listPicture[_indexImage].imagepath}",
                            headers: hedersWithToken,
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ))
          ]),
        ),
      ],
    );
  }

  Widget imageTable() {
    var formatter = new DateFormat('yyyy-MM-dd');

    return ListView.builder(
      itemCount: _listPicture.length,
      itemBuilder: (BuildContext ctx, index) {
        return Container(
            width: 70,
            height: 150,
            child: Card(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Expanded(
                                child: Text(formatter.format(DateTime.parse(
                                    _listPicture[index].datacreate!)))),
                            Container(
                                width: 100,
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _indexImage = index;
                                      });
                                    },
                                    child: Image.network(
                                      "${Ui.url}imagedata/download/images/${_listPicture[index].imagepath}",
                                      headers: hedersWithToken,
                                    ))),
                          ],
                        )),
                        Expanded(
                            child: CheckboxListTile(
                          title: Text("web"),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (newVlaue) {
                            // imageBloc!
                            //     .putWeb("webimage",
                            //         _listPicture[index].id.toString())
                            //     .then((value) {
                            //   setState(() {
                            //     // _listPicture[index].web = newVlaue;
                            //   });
                            // });
                          },
                          value: _listPicture[index].web,
                        )),
                        Divider(),
                        Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              _listPicture[index].name!,
                              style: TextStyle(fontSize: 15),
                            ))
                      ],
                    ))));
      },
    );
  }
}
