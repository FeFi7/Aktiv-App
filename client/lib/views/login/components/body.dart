import 'package:aktiv_app_flutter/Views/Login/components/background.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_password_field.dart';
import 'package:aktiv_app_flutter/Views/Registrieren/registrieren_screen.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/account_vorhanden_check.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import '../../Home.dart';
import '../../../util/secure_storage_service.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  var mail;
  var passwort;

  final SecureStorage storage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.03), //Abstand über dem Bild
                CircleAvatar(
                  radius: 120,
                  backgroundImage: AssetImage("assets/images/logo.png"),
                ),
                SizedBox(height: size.height * 0.03), //Abstand unter dem Bild
                RoundedInputEmailField(
                  hintText: "Email Adresse",
                  onChanged: (value) {
                    mail = value;
                  },
                ),
                RoundedPasswordField(
                  hintText: "Passwort",
                  onChanged: (value) {
                    passwort = value;
                  },
                ),
                RoundedButton(
                  text: "LOGIN",
                  color: ColorPalette.endeavour.rgb,
                  press: () async {
                    if (mail.toString().isNotEmpty &&
                        mail != null &&
                        passwort.toString().isNotEmpty &&
                        passwort != null) {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                      }

                      if (EmailValidator.validate(mail)) {
                        var jwt = await attemptLogIn(mail, passwort);

                        if (jwt.statusCode == 200) {
                          var parsedJson = json.decode(jwt.body);
                          var accessToken = parsedJson['accessToken'];
                          var refreshToken = parsedJson['refreshToken'];

                          print(accessToken);
                          print(refreshToken);

                          if (jwt != null) {
                            storage.write("accessToken", accessToken);
                            storage.write("refreshToken", refreshToken);
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomePage();
                              },
                            ),
                          );
                        } else {
                          setState(() {
                            Fluttertoast.showToast(
                                msg: "Ungültige Anmeldedaten",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: ColorPalette.orange.rgb,
                                textColor: ColorPalette.white.rgb);
                          });
                        }
                      } else {
                        setState(() {
                          Fluttertoast.showToast(
                              msg: "Bitte gültige Email eingeben",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: ColorPalette.orange.rgb,
                              textColor: ColorPalette.white.rgb);
                        });
                      }
                    } else {
                      setState(() {
                        Fluttertoast.showToast(
                            msg: "Bitte Email und Passwort eingeben",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: ColorPalette.white.rgb,
                            textColor: ColorPalette.orange.rgb);
                      });
                    }
                  },
                ),

                // Container(
                //   child: Row(
                //     children: <Widget>[
                //       SizedBox(
                //           width:
                //               size.width * 0.48), //Abstand links von der Kante
                //       FlatButton(
                //         onPressed: () => print("Passwort vergessen gedrückt"),
                //         child: Text(
                //           "Passwort vergessen?",
                //           style: TextStyle(color: ColorPalette.white.rgb),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                          width:
                              size.width * 0.1), //Abstand links von der Kante
                      Theme(
                        data: ThemeData(
                            unselectedWidgetColor: ColorPalette.white.rgb),
                        child: Checkbox(
                          value: rememberMe,
                          checkColor: ColorPalette.orange.rgb,
                          activeColor: ColorPalette.white.rgb,
                          onChanged: (value) {
                            setState(
                              () {
                                rememberMe = value;
                              },
                            );
                          },
                        ),
                      ),
                      Text(
                        "Eingeloggt bleiben?",
                        style: TextStyle(color: ColorPalette.malibu.rgb),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: size.height * 0.02), //Abstand nach der Checkbox
                AccountBereitsVorhandenCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RegistrierenScreen();
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                    height:
                        size.height * 0.03), //Abstand über der Pop-Up Tastatur
              ],
            ),
          ),
        ),
      ),
    );
  }
}
