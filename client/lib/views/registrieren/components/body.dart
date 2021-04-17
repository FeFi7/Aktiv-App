import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_password_field.dart';
import 'package:aktiv_app_flutter/Views/Login/login_screen.dart';
import 'package:aktiv_app_flutter/Views/Registrieren/components/background.dart';
import 'package:aktiv_app_flutter/components/account_vorhanden_check.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = GlobalKey<FormState>();
  var mail;
  var password;
  var confirmPassword;
  bool agbsGelesen = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Account erstellen",
                style: TextStyle(color: ColorPalette.white.rgb, fontSize: 26.0),
              ),
              SizedBox(height: size.height * 0.03), //Abstand unter den Buttons
              RoundedInputEmailField(
                hintText: "Email",
                icon: Icons.mail,
                onChanged: (value) {
                  setState(() {
                    mail = value;
                  });
                },
              ),
              RoundedPasswordField(
                hintText: "Passwort",
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              RoundedPasswordField(
                hintText: "Passwort wiederholen",
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                  });
                },
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: size.width * 0.1), //Abstand links von der Kante
                    Theme(
                      data: ThemeData(
                          unselectedWidgetColor: ColorPalette.white.rgb),
                      child: Checkbox(
                        value: agbsGelesen,
                        checkColor: ColorPalette.orange.rgb,
                        activeColor: ColorPalette.white.rgb,
                        onChanged: (value) {
                          setState(
                            () {
                              agbsGelesen = value;
                            },
                          );
                        },
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Ich habe die ",
                          style: TextStyle(color: ColorPalette.malibu.rgb),
                        ),
                        TextSpan(
                          text: "AGBs ",
                          style: TextStyle(color: ColorPalette.white.rgb),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url =
                                  "http://lebensqualitaet-burgrieden.de/lq/kontaktimpressum/";

                              await launch(
                                url,
                                forceSafariVC: false,
                                forceWebView: false,
                              );
                            },
                        ),
                        TextSpan(
                          text: "und",
                          style: TextStyle(color: ColorPalette.malibu.rgb),
                        ),
                        TextSpan(
                          text: " Datenschutzerklärung ",
                          style: TextStyle(color: ColorPalette.white.rgb),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url =
                                  "http://lebensqualitaet-burgrieden.de/lq/kontaktimpressum/";

                              await launch(
                                url,
                                forceSafariVC: false,
                                forceWebView: false,
                              );
                            },
                        ),
                        TextSpan(
                          text: " \ngelesen und akzeptiere.",
                          style: TextStyle(color: ColorPalette.malibu.rgb),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              RoundedButton(
                text: "Registrieren",
                color: ColorPalette.endeavour.rgb,
                press: () async {
                  if (mail.toString().isNotEmpty &&
                      mail != null &&
                      password.toString().isNotEmpty &&
                      password != null &&
                      confirmPassword.toString().isNotEmpty &&
                      confirmPassword != null) {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();

                      if (password != confirmPassword) {
                        Fluttertoast.showToast(
                            msg: "Passwörter stimmen nicht überein",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: ColorPalette.orange.rgb,
                            textColor: ColorPalette.white.rgb);
                      } else if (!agbsGelesen) {
                        Fluttertoast.showToast(
                            msg: "Bitte AGBs akzeptieren",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: ColorPalette.orange.rgb,
                            textColor: ColorPalette.white.rgb);
                      } else {
                        var jwt = await attemptSignUp(mail, password);

                        if (jwt.statusCode == 502) {
                          Fluttertoast.showToast(
                              msg: "Server nicht erreichbar",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: ColorPalette.orange.rgb,
                              textColor: ColorPalette.white.rgb);
                        } else if (jwt.statusCode == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ),
                          );
                        }
                      }
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "Ungültige Angaben",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: ColorPalette.orange.rgb,
                        textColor: ColorPalette.white.rgb);
                  }
                },
              ),
              SizedBox(height: size.height * 0.03), //Abstand unter den Buttons
              //Zurück zum LoginScreen
              AccountBereitsVorhandenCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
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
    );
  }
}
