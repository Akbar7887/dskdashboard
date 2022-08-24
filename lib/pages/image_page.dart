import 'package:dskdashboard/bloc/doma_bloc.dart';
import 'package:dskdashboard/models/Kompleks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/bloc_state.dart';
import '../bloc/kompleks_bloc.dart';
import '../models/doma.dart';
import '../ui.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  List<Kompleks> _listKomleks = [];
  Kompleks? _kompleks;
  List<Doma> _listDoma = [];
  Doma? _doma;
  DomaBloc? _domaBloc;

  @override
  Widget build(BuildContext context) {
    _domaBloc = BlocProvider.of<DomaBloc>(context);

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
          _listKomleks.sort((a, b) => a.id!.compareTo(b.id!));

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
    return ListView(
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
                            child: Text(e.name!),
                          );
                        }).toList(),
                        value: _kompleks,
                        onChanged: (Kompleks? newValue) {
                          _domaBloc!
                              .getDoma(newValue!.id.toString())
                              .then((value) {
                            setState(() {
                              _kompleks = newValue;
                              _listDoma = value;
                              if(_listDoma.length > 0){
                                _doma = _listDoma.first;
                              }
                            });
                            _listDoma.sort((a, b) => a.id!.compareTo(b.id!));
                          });
                        })),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: DropdownButton<Doma>(
                        isExpanded: true,
                        hint: Text("Дома"),
                        items: _listDoma.map<DropdownMenuItem<Doma>>((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e.name!),
                          );
                        }).toList(),
                        value: _doma,
                        onChanged: (Doma? newValue) {
                          // domaBloc.getDoma(newValue!.id.toString()).then((value) {
                          //   _listDoma = value;

                          setState(() {
                            _doma = newValue;
                          });
                          // _listDoma!.sort((a,b) => a.id!.compareTo(b.id!));
                        })),
              ],
            )),


      ],
    );
  }
}
