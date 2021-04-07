import 'dart:async';

import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/views/login/login_screen.dart';
import 'package:aktiv_app_flutter/views/welcome_screen/components/background.dart';
import 'package:flutter/material.dart';

import '../../Home.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    //startTime();
  }

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
                radius: 150.0,
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
              SizedBox(height: size.height * 0.03), //Abstand unter den Buttons
            ],
          ),
        ),
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
