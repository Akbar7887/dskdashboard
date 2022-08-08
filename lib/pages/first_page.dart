import 'package:dskdashboard/pages/home.dart';
import 'package:dskdashboard/service/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

import '../ui.dart';

TextEditingController _user = TextEditingController();
TextEditingController _password = TextEditingController();
Repository repository = Repository();
final _keyUser = GlobalKey<FormState>();
final _keyPassword = GlobalKey<FormState>();
bool visiblepassvord = true;

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    _user.text = "Admin";
    _password.text = "1";
    return Material(
        color: Colors.black87,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
                // alignment: Alignment.center,
                child: Text(Ui.company,
                    style: GoogleFonts.openSans(
                        fontSize: 50,
                        fontWeight: FontWeight.w200,
                        color: Colors.white))),
            SizedBox(
              height: 100,
            ),
            Container(
              child: Text("Вход",
                  style: GoogleFonts.openSans(
                      fontSize: 50,
                      fontWeight: FontWeight.w200,
                      color: Colors.white)),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                width: 400,
                child: Form(
                  key: _keyUser,
                  child: TextFormField(
                      controller: _user,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Просим заполнить пользователя";
                        }
                      },
                      style: GoogleFonts.openSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                          color: Colors.white),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white,
                          //Theme.of(context).backgroundColor,
                          labelText: "Пользователь",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(width: 0.5, color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 0.5, color: Colors.white)))),
                )),
            SizedBox(
              height: 30,
            ),
            Container(
                width: 400,
                child: Form(
                    key: _keyPassword,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return TextFormField(
                            controller: _password,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Просим заполнить пароль";
                              }
                            },
                            obscureText: visiblepassvord,
                            style: GoogleFonts.openSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w200,
                                color: Colors.white),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    color: Colors.white,
                                    (visiblepassvord)
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      visiblepassvord = !visiblepassvord;
                                    });
                                  },
                                ),
                                prefixIcon: Icon(
                                  Icons.vpn_key_rounded,
                                  color: Colors.white,
                                ),
                                fillColor: Colors.white,
                                //Theme.of(context).backgroundColor,
                                labelText: "Пароль",
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        width: 0.5, color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        width: 0.5, color: Colors.white))));
                      },
                    ))),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 200,
              height: 80,
              // color: Colors.black87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              // color: Colors.black,
              child: ElevatedButton(
                onPressed: () {
                  if (_keyUser.currentState!.validate() == false) {
                    return;
                  }
                  if (_keyPassword.currentState!.validate() == false) {
                    return;
                  }
                  repository
                      .login(_user.text.trim(), _password.text.trim())
                      .then((value) {
                    if (value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    } else {
                      print("Error");

                      Toast.show("Не правильно указан пользователь или пароль",
                          duration: Toast.lengthShort, gravity: Toast.bottom);
                    }
                  }).catchError((onError) {
                    Toast.show("Не правильно указан пользователь или пароль",
                        duration: Toast.lengthShort, gravity: Toast.bottom);
                  });
                },
                child: Text("ВОЙТИ",
                    style: GoogleFonts.openSans(
                        fontSize: 30,
                        fontWeight: FontWeight.w200,
                        color: Colors.white)),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black87),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:
                                BorderSide(color: Colors.white, width: 0.5)))),
              ),
            )
          ],
        ));
  }
}
