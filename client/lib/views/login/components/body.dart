import 'package:aktiv_app_flutter/Views/Login/components/background.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_password_field.dart';
import 'package:aktiv_app_flutter/Views/Registrieren/registrieren_screen.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/account_vorhanden_check.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:flutter/material.dart';
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
  var mail;
  var passwort;

  final SecureStorage storage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.03), //Abstand über dem Bild
              CircleAvatar(
                radius: 150,
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
                  var jwt = await attemptLogIn(mail, passwort);

                  var parsedJson = json.decode(jwt);
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
                },
              ),
              SizedBox(height: size.height * 0.03), //Abstand unter den Buttons
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
    );
  }
}
