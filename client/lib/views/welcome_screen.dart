import 'dart:async';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'defaults/color_palette.dart';
import 'Login/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    //startTime();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: ColorPalette.torea_bay.rgb),
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 5,
            right: 5,
            child: Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "powered by\nLEBENSQUALITÄT\nBURGRIEDEN",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: ColorPalette.endeavour.rgb,
                          fontSize: 12.0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: size.width *
                        0.03), //Abstand zwischen Text und Logo (Rechts unten)
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset("assets/images/lq_logo_klein.png"),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.03), //Abstand über dem Bild
                CircleAvatar(
                  radius: 200.0,
                  backgroundImage: AssetImage("assets/images/logo.png"),
                ),
                SizedBox(height: size.height * 0.03), //Abstand unter dem Bild
                RoundedButton(
                  text: "Anmelden",
                  color: ColorPalette.endeavour.rgb,
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
                RoundedButton(
                  text: "Ohne Anmeldung fortfahren",
                  textColor: Colors.black87,
                  color: ColorPalette.malibu.rgb,
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
                SizedBox(
                    height: size.height * 0.03), //Abstand unter den Buttons
              ],
            ),
          ),
        ],
      ),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
