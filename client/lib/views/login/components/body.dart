import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/Login/components/background.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_password_field.dart';
import 'package:aktiv_app_flutter/Views/Registrieren/registrieren_screen.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/account_vorhanden_check.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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
  bool rememberMe = true;
  var mail;
  var password;

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
                //Logo
                CircleAvatar(
                  radius: 120,
                  backgroundImage:
                      AssetImage("assets/images/wir_hier_logo_transparent.png"),
                  backgroundColor: Color.fromARGB(0, 0, 0, 0),
                ),
                SizedBox(height: size.height * 0.03), //Abstand unter dem Bild
                //InputField für Email
                RoundedInputEmailField(
                  hintText: "Email Adresse",
                  onChanged: (value) {
                    mail = value;
                  },
                ),
                //InputField für Passwort
                RoundedPasswordField(
                  hintText: "Passwort",
                  onChanged: (value) {
                    password = value;
                  },
                ),
                //Login-Button
                RoundedButton(
                  text: "LOGIN",
                  color: ColorPalette.endeavour.rgb,
                  press: () async {
                    if (mail.toString().isNotEmpty &&
                        mail != null &&
                        password.toString().isNotEmpty &&
                        password != null) {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                      }

                      if (EmailValidator.validate(mail)) {
                        Provider.of<EventProvider>(context, listen: false)
                            .resetEventListType(EventListType.FAVORITES);
                        var jwt = await Provider.of<UserProvider>(context,
                                listen: false)
                            .login(mail, password);

                        if (jwt.statusCode == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomePage();
                              },
                            ),
                          );
                        } else if (jwt.statusCode == 401) {
                          errorToast("Unauthorisierter Benutzer");
                        } else {
                          errorToast("Ungültige Anmeldedaten");
                        }
                      } else {
                        errorToast("Bitte gültige Email eingeben");
                      }
                    } else {
                      errorToast("Bitte Email und Passwort eingeben");
                    }
                  },
                ),
                SizedBox(
                    height: size.height * 0.02), //Abstand nach der Checkbox
                //Wechsel zur Registrieren-View
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

  //Toast mit "errorMessage" anzeigen
  errorToast(String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorPalette.orange.rgb,
      textColor: ColorPalette.white.rgb,
    );
    FocusManager.instance.primaryFocus.unfocus();
  }
}
