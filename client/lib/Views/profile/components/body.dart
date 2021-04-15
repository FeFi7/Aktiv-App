import 'dart:io';
import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/profile/components/background.dart';
import 'package:aktiv_app_flutter/Views/profile/components/profile_einstellungen.dart';
import 'package:aktiv_app_flutter/Views/profile/profile_screen.dart';
import 'package:aktiv_app_flutter/Views/welcome_screen.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Home.dart';
import 'profile_persoenlich.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File profileImage;
  final picker = ImagePicker();
  var sliderValueNaehe = 5.0;
  var sliderValueBald = 2.0;

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            avatarBild(),
            SizedBox(
              height: 60,
            ),
            Text(
              "LQ Burgrieden",
              style: TextStyle(
                  fontSize: 25.0,
                  color: ColorPalette.congress_blue.rgb,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Burgrieden, Deutschland",
              style: TextStyle(
                  fontSize: 18.0,
                  color: ColorPalette.torea_bay.rgb,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Testaccount für die App-Entwicklung",
              style: TextStyle(
                  fontSize: 15.0,
                  color: ColorPalette.torea_bay.rgb,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 25,
            ),
            mitgliederUndVeranstaltungen(),
            SizedBox(
              height: 25,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedButton(
                  text: "Platzhalter",
                  color: ColorPalette.endeavour.rgb,
                  press: () {},
                ),
                RoundedButton(
                  text: "Persönliche Angaben",
                  color: ColorPalette.endeavour.rgb,
                  press: () {
                    Provider.of<BodyProvider>(context, listen: false)
                        .setBody(ProfilePersoenlich());
                    Provider.of<AppBarTitleProvider>(context, listen: false)
                        .setTitle('Persönliche Angaben');
                  },
                ),
                RoundedButton(
                  text: "Einstellungen",
                  color: ColorPalette.endeavour.rgb,
                  press: () {
                    Provider.of<BodyProvider>(context, listen: false)
                        .setBody(ProfileEinstellungen());
                    Provider.of<AppBarTitleProvider>(context, listen: false)
                        .setTitle('Einstellungen');
                  },
                ),
                RoundedButton(
                  text: "Abmelden",
                  color: ColorPalette.orange.rgb,
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card mitgliederUndVeranstaltungen() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Veranstaltungen",
                    style: TextStyle(
                        color: ColorPalette.endeavour.rgb,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    "15",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Mitglieder",
                    style: TextStyle(
                        color: ColorPalette.endeavour.rgb,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    "127",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container avatarBild() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/wir_logo.png"), fit: BoxFit.cover),
      ),
      child: Container(
        width: double.infinity,
        height: 200,
        child: Container(
          alignment: Alignment(0.0, 2.0),
          child: InkWell(
            onTap: getImage,
            child: CircleAvatar(
              radius: 60.0,
              child: ClipOval(
                child: Container(
                  height: 120.0,
                  width: 120.0,
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    child: (profileImage != null)
                        ? Image.file(profileImage)
                        : Image.asset("assets/images/lq_logo_klein.png"),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(
      () {
        pickedFile != null
            ? profileImage = File(pickedFile.path)
            : profileImage = null;
      },
    );
  }
}
