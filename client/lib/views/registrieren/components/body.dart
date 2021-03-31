import 'package:aktiv_app_flutter/components/rounded_input_field.dart';
import 'package:aktiv_app_flutter/components/rounded_password_field.dart';
import 'package:aktiv_app_flutter/Views/Login/login_screen.dart';
import 'package:aktiv_app_flutter/Views/Registrieren/components/background.dart';
import 'package:aktiv_app_flutter/Views/color_palette.dart';
import 'package:aktiv_app_flutter/Views/welcome_screen.dart';
import 'package:aktiv_app_flutter/components/account_vorhanden_check.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final Widget child;

  const Body({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppBar(
              centerTitle: true,
              title: Text(
                "Registrieren",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ColorPalette.white.rgb,
                ),
              ),
              backgroundColor: ColorPalette.malibu.rgb,
            ),
            RoundedInputField(
              hintText: "Vorname",
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Nachname",
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Straße, Hausnummer",
              icon: Icons.home,
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "PLZ, Ort",
              icon: Icons.gps_fixed_outlined,
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Telefonnummer",
              icon: Icons.phone,
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Email",
              icon: Icons.mail,
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              hintText: "Passwort",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              hintText: "Passwort wiederholen",
              onChanged: (value) {},
            ),
            //Zurück zum WelcomeScreen
            RoundedButton(
              text: "Registrieren",
              color: ColorPalette.congress_blue.rgb,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return WelcomeScreen();
                    },
                  ),
                );
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
                height: size.height * 0.03), //Abstand über der Pop-Up Tastatur
          ],
        ),
      ),
    );
  }
}
