import 'package:aktiv_app_flutter/Views/color_palette.dart';
import 'package:flutter/material.dart';

class AccountBereitsVorhandenCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AccountBereitsVorhandenCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Noch keinen Account? " : "Account bereits vorhanden? ",
          style: TextStyle(color: ColorPalette.malibu.rgb),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Registrieren" : "Anmelden",
            style: TextStyle(
                color: ColorPalette.malibu.rgb, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
