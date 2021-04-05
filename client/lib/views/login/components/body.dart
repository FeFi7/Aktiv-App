import 'package:aktiv_app_flutter/Views/Login/components/background.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_password_field.dart';
import 'package:aktiv_app_flutter/Views/Registrieren/registrieren_screen.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/account_vorhanden_check.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:flutter/material.dart';

import '../../Home.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

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
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                hintText: "Passwort",
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "LOGIN",
                color: ColorPalette.endeavour.rgb,
                press: () {
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
