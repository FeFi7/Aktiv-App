import 'dart:async';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/util/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Home.dart';
import 'defaults/color_palette.dart';
import 'Login/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  final SecureStorage storage = SecureStorage();
  @override
  void initState() {
    super.initState();
    autoSignIn();
  }

  bool loadOverlay = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorPalette.endeavour.rgb,
            ColorPalette.torea_bay.rgb,
            ColorPalette.torea_bay.rgb
          ],
        ),
      ),
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
                        "powered by\nLebensqualität\nBurgrieden e.V.\n& Bürgerstiftung\nBurgrieden",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: ColorPalette.endeavour.rgb,
                          fontSize: 10.0,
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
                  radius: 180.0,
                  foregroundImage:
                      AssetImage("assets/images/wir_hier_logo_transparent.png"),
                  backgroundColor: Color.fromARGB(0, 0, 0, 0),
                ),
                SizedBox(height: size.height * 0.03), //Abstand unter dem Bild
                //Button für Anmelden
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
                //Button für Ohne Anmeldung fortfahren
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
          Visibility(
              visible: loadOverlay,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorPalette.endeavour.rgb,
                      ColorPalette.torea_bay.rgb,
                      ColorPalette.torea_bay.rgb
                    ],
                  ),
                ),
                width: double.infinity,
                height: size.height,
                child: Center(child: CircularProgressIndicator()),
              ))
        ],
      ),
    );
  }

  //Start Timer für AutoLogin
  startTime() async {
    var duration = new Duration(seconds: 1);
    return new Timer(duration, route);
  }

  //Route für AutoLogin
  route() async {
    await Provider.of<UserProvider>(context, listen: false).signInWithToken();
    if (Provider.of<UserProvider>(context, listen: false).isSignInWithToken) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  //AutoLogin Prozess auslösen
  autoSignIn() async {
    if (await Provider.of<UserProvider>(context, listen: false)
            .getUserIdFromStorage() !=
        null) {
      startTime();
    }
    loadOverlay = false;
  }
}
