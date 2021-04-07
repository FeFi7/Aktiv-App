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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: ColorPalette.congress_blue.rgb),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 200.0,
                        backgroundImage: AssetImage("assets/images/logo.png"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0),
                      ),
                    ],
                  ),
                ),
              ),
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
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //CircularProgressIndicator(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "powered by  ",
                          style: TextStyle(
                              color: ColorPalette.endeavour.rgb,
                              fontSize: 12.0),
                        ),
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage:
                              AssetImage("assets/images/lq_logo_klein.png"),
                        ),
                        Text("      "),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("LEBENSQUALITÄT \nBURGRIEDEN e.V.",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: ColorPalette.endeavour.rgb,
                            fontSize: 12.0,
                          )),
                      Text("      "),
                    ]),
                  ],
                ),
              )
            ],
          )
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
