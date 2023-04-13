// import 'dart:typed_data';
//
// import 'package:dskdashboard/bloc/bloc_state.dart';
// import 'package:dskdashboard/bloc/job_bloc.dart';
// import 'package:dskdashboard/bloc/kompleks_bloc.dart';
// import 'package:dskdashboard/models/Job.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
//
// import '../bloc/bloc_event.dart';
// import '../models/Joblist.dart';
// import '../models/Kompleks.dart';
// import '../ui.dart';
//
// class JobPage extends StatefulWidget {
//   const JobPage({Key? key}) : super(key: key);
//
//   @override
//   State<JobPage> createState() => _JobPageState();
// }
//
// class _JobPageState extends State<JobPage> {
//   List<Job> _listjob = [];
//   late JobBloc jobBloc;
//   Job? _job;
//   final _keyformjobs = GlobalKey<FormState>();
//   TextEditingController _vacancyControl = TextEditingController();
//   TextEditingController _departmentContoller = TextEditingController();
//   List<Joblist> _listJoblist = [];
//   List<TextEditingController> _listConrtoller = [];
//
//   List<bool> _listtitle = [];
//   List<bool> _listenable = [];
//
//   var formatter = new DateFormat('yyyy-MM-dd');
//
//   void fillListController() {
//     _listConrtoller = [];
//     _listtitle = [];
//     _listenable = [];
//
//     _listJoblist.map((e) {
//       TextEditingController _texcontoller = TextEditingController();
//       _texcontoller.text = e.description == null ? "" : e.description!;
//       _listConrtoller.add(_texcontoller);
//       _listtitle.add(e.title == null ? false : e.title!);
//       _listenable.add(e.title == null ? true : false);
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     jobBloc = BlocProvider.of<JobBloc>(context);
//
//     return BlocConsumer<JobBloc, BlocState>(
//       builder: (context, state) {
//         if (state is BlocEmtyState) {
//           return Center(child: Text("No data!"));
//         }
//
//         if (state is BlocLoadingState) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (state is JobLoadedState) {
//           //
//           _listjob = state.loadedJob;
//           _listjob.sort((a, b) => a.id!.compareTo(b.id!));
//           return mainWidget(context);
//         }
//
//         if (state is BlocErrorState) {
//           return Center(
//             child: Text("Сервер не работает!"),
//           );
//         }
//         return SizedBox.shrink();
//       },
//       listener: (context, state) {},
//     );
//   }
//
//   Widget mainWidget(BuildContext context) {
//     return ListView(
//       children: [
//         Container(
//           height: 50,
//           alignment: Alignment.center,
//           child: Text(
//             "Вакансии",
//             style: TextStyle(fontSize: 20),
//           ),
//         ),
//         Divider(),
//         Container(
//           alignment: Alignment.centerLeft,
//           padding: EdgeInsets.only(left: 20),
//           child: ElevatedButton(
//               style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.black54)),
//               onPressed: () {
//                 _job = null;
//                 _listJoblist = [];
//
//                 showdialogwidget(context);
//               },
//               child: Text("Добавить")),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//             // color: Colors.black87,
//             padding: EdgeInsets.all(10),
//             child: SingleChildScrollView(
//                 child: DataTable(
//                     key: UniqueKey(),
//                     sortAscending: true,
//                     sortColumnIndex: 0,
//                     headingRowColor: MaterialStateProperty.all(Colors.blue),
//                     headingTextStyle: TextStyle(color: Colors.white),
//                     columns: [
//                       DataColumn(label: Text("№")),
//                       DataColumn(label: Text("Вакансия")),
//                       DataColumn(label: Text("Департамент")),
//                       DataColumn(label: Text("Изменить")),
//                       DataColumn(label: Text("Удалить")),
//                     ],
//                     rows: _listjob.map((e) {
//                       return DataRow(cells: [
//                         DataCell(Text((_listjob.indexOf(e) + 1).toString())),
//                         DataCell(Text(e.vacancy!)),
//                         DataCell(Text(e.department!)),
//                         DataCell(IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () {
//                             _job = e;
//                             _listJoblist = _job!.joblist!;
//                             fillListController();
//                             showdialogwidget(context);
//                           },
//                         )),
//                         DataCell(IconButton(
//                           icon: Icon(Icons.delete_forever),
//                           onPressed: () {
//                             Map<String, dynamic> param = {
//                               'id': e.id.toString()
//                             };
//
//                             jobBloc.remove("job/remove", param).then((value) {
//                               jobBloc.add(BlocLoadEvent());
//                             }).catchError((onError) {
//                               print(onError);
//                             });
//                           },
//                         )),
//                       ]);
//                     }).toList())))
//       ],
//     );
//   }
//
//   Future<void> showdialogwidget(BuildContext context) {
//     if (_job != null) {
//       _vacancyControl.text = _job!.vacancy!;
//       _departmentContoller.text = _job!.department!;
//     } else {
//       _vacancyControl.text = "";
//       _departmentContoller.text = "";
//     }
//
//     return showDialog<void>(
//         context: context,
//         barrierDismissible: true,
//         // false = user must tap button, true = tap outside dialog
//         builder: (BuildContext dialogContext) {
//           return StatefulBuilder(builder: (context, setState) {
//             // fillListController();
//             void removeItem(int idx) {
//               setState(() {
//                 _listJoblist.removeAt(idx);
//               });
//             }
//
//             return AlertDialog(
//               // key: UniqueKey(),
//               title: Text('Вакансия'),
//               content: Container(
//                   height: MediaQuery.of(context).size.height / 1.1,
//                   width: MediaQuery.of(context).size.width / 1.1,
//                   child: Form(
//                       key: _keyformjobs,
//                       child: Row(children: [
//                         Expanded(
//                           child: Column(
//                             // crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               (_job != null)
//                                   ? Text('№ ${_job?.id.toString()}')
//                                   : Text('№'),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width / 3,
//                                 child: TextFormField(
//                                     controller: _vacancyControl,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return "Просим заполнить вакансию";
//                                       }
//                                     },
//                                     style: GoogleFonts.openSans(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w200,
//                                         color: Colors.black),
//                                     decoration: InputDecoration(
//                                         fillColor: Colors.white,
//                                         //Theme.of(context).backgroundColor,
//                                         labelText: "Вакансия",
//                                         enabledBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             borderSide: BorderSide(
//                                                 width: 0.5,
//                                                 color: Colors.black)),
//                                         focusedBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             borderSide: BorderSide(
//                                                 width: 0.5,
//                                                 color: Colors.black)))),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width / 3,
//                                 child: TextFormField(
//                                     controller: _departmentContoller,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return "Просим заполнить Департамент";
//                                       }
//                                     },
//                                     style: GoogleFonts.openSans(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w200,
//                                         color: Colors.black),
//                                     decoration: InputDecoration(
//                                         fillColor: Colors.white,
//                                         //Theme.of(context).backgroundColor,
//                                         labelText: "Департамент",
//                                         enabledBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             borderSide: BorderSide(
//                                                 width: 0.5,
//                                                 color: Colors.black)),
//                                         focusedBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             borderSide: BorderSide(
//                                                 width: 0.5,
//                                                 color: Colors.black)))),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                             flex: 2,
//                             child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ElevatedButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           Joblist joblist = Joblist();
//                                           _listJoblist.add(joblist);
//                                           fillListController();
//                                         });
//                                       },
//                                       child: Text("Добавить")),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                  Expanded(child:  SingleChildScrollView(
//                                     scrollDirection: Axis.vertical,
//                                       child: DataTable(
//                                           headingRowColor:
//                                               MaterialStateProperty.all(
//                                                   Colors.blue),
//                                           columnSpacing: 150,
//                                           headingTextStyle:
//                                               TextStyle(color: Colors.white),
//                                           columns: [
//                                             DataColumn(
//                                                 label: Text("Заголовок")),
//                                             DataColumn(label: Text("Описание")),
//                                             DataColumn(label: Text("Изменить")),
//                                             DataColumn(label: Text("Удалить")),
//                                           ],
//                                           rows: _listJoblist.map((e) {
//                                             return DataRow(cells: [
//                                               DataCell(
//                                                 Checkbox(
//                                                   value: _listtitle[
//                                                       _listJoblist.indexOf(e)],
//                                                   onChanged: (bool? value) {
//                                                     setState(() {
//                                                       _listtitle[_listJoblist
//                                                           .indexOf(e)] = value!;
//                                                     });
//                                                     e.title = value;
//                                                   },
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 TextFormField(
//                                                   controller: _listConrtoller[
//                                                       _listJoblist.indexOf(e)],
//                                                   enabled: _listenable[
//                                                       _listJoblist.indexOf(e)],
//                                                   showCursor: _listenable[
//                                                       _listJoblist.indexOf(e)],
//                                                   validator: (value) {
//                                                     if (value == null ||
//                                                         value.isEmpty) {
//                                                       return "Просим заполнить описание";
//                                                     }
//                                                   },
//                                                   onChanged: (newvalue) {
//                                                     e.description = newvalue;
//                                                   },
//                                                 ),
//                                               ),
//                                               DataCell(IconButton(
//                                                 icon: Icon(Icons.edit),
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     _listenable[_listJoblist
//                                                             .indexOf(e)] =
//                                                         !_listenable[
//                                                             _listJoblist
//                                                                 .indexOf(e)];
//                                                   });
//                                                 },
//                                               )),
//                                               DataCell(IconButton(
//                                                 icon:
//                                                     Icon(Icons.delete_forever),
//                                                 onPressed: () {
//                                                   removeItem(
//                                                       _listJoblist.indexOf(e));
//
//                                                   jobBloc.remove(
//                                                       "job/removeitem", {
//                                                     "id": e.id.toString()
//                                                   }).then((value) {
//                                                     setState(() {
//                                                       _listJoblist.remove(e);
//                                                     });
//                                                     jobBloc
//                                                         .add(BlocLoadEvent());
//                                                   });
//                                                 },
//                                               )),
//                                             ]);
//                                           }).toList()))),
//                                 ])),
//                       ]))),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('Сохранить'),
//                   onPressed: () {
//                     if (_job == null) {
//                       _job = Job();
//                     } else {}
//
//                     if (!_keyformjobs.currentState!.validate()) {
//                       return;
//                     }
//
//                     _job!.vacancy = _vacancyControl.text;
//                     _job!.department = _departmentContoller.text;
//
//                     _job!.joblist = _listJoblist;
//
//                     // _listConrtoller.forEach((element) {
//                     //
//                     //   element.text
//                     // });
//
//                     jobBloc.save("job/save", _job).then((value) {
//                       jobBloc.add(BlocLoadEvent());
//                       Navigator.of(dialogContext).pop();
//
//                       // _webImage = null;
//                     });
//                   },
//                 ),
//                 TextButton(
//                   child: Text('Отмена'),
//                   onPressed: () {
//                     Navigator.of(dialogContext).pop(); // Dismiss alert dialog
//                   },
//                 ),
//               ],
//             );
//           });
//         });
//   }
// }
