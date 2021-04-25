import 'dart:io';
import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/profile/components/background.dart';
import 'package:aktiv_app_flutter/Views/profile/components/profile_einstellungen.dart';
import 'package:aktiv_app_flutter/Views/profile/components/profile_verwalten.dart';
import 'package:aktiv_app_flutter/Views/welcome_screen.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/util/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final List<bool> userGruppe = [true, false, false];
  int userGruppeIndex = 0;

  final SecureStorage storage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            avatarBild(),
            SizedBox(height: 40),
            Text(
              "LQ Burgrieden",
              style: TextStyle(
                  fontSize: 25.0,
                  color: ColorPalette.congress_blue.rgb,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            Text(
              "Burgrieden, Deutschland",
              style: TextStyle(
                  fontSize: 18.0,
                  color: ColorPalette.torea_bay.rgb,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 10),
            Text(
              "Testaccount für die App-Entwicklung",
              style: TextStyle(
                  fontSize: 15.0,
                  color: ColorPalette.torea_bay.rgb,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 25),
            buttons(context),
          ],
        ),
      ),
    );
  }

  Column buttons(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 60.0,
          //Temporäre ToggleButtons zum wählen der Rolle
          child: ToggleButtons(
            children: [
              Container(
                  alignment: Alignment.center,
                  width: size.width * 0.8 / userGruppe.length,
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Verwalter')),
              Container(
                  alignment: Alignment.center,
                  width: size.width * 0.8 / userGruppe.length,
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Genehmiger')),
              Container(
                  alignment: Alignment.center,
                  width: size.width * 0.8 / userGruppe.length,
                  padding: const EdgeInsets.all(10.0),
                  child: Text('LQ')),
            ],
            isSelected: userGruppe,
            onPressed: (int index) {
              setState(
                () {
                  for (int buttonIndex = 0;
                      buttonIndex < userGruppe.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      userGruppe[buttonIndex] = true;
                    } else {
                      userGruppe[buttonIndex] = false;
                    }
                  }
                  userGruppeIndex = index;
                },
              );
            },
            borderRadius: BorderRadius.circular(30),
            borderWidth: 1,
            selectedColor: ColorPalette.white.rgb,
            fillColor: ColorPalette.endeavour.rgb,
            disabledBorderColor: ColorPalette.french_pass.rgb,
          ),
        ),
        SizedBox(height: 10),
        RoundedButton(
          text: "Verwalten",
          color: ColorPalette.endeavour.rgb,
          press: () {
            Provider.of<BodyProvider>(context, listen: false)
                .setBody(ProfileVerwalten(userGruppe: userGruppeIndex));
            Provider.of<AppBarTitleProvider>(context, listen: false)
                .setTitle('Verwalten');
          },
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
          text: "Hilfe",
          color: Colors.grey[400],
          press: () async {
            final url =
                "http://lebensqualitaet-burgrieden.de/lq/kontaktimpressum/"; //Dokumentation/Anleitung der App
            await launch(
              url,
              forceSafariVC: false,
              forceWebView: false,
            );
          },
        ),
        RoundedButton(
          text: "Abmelden",
          color: Colors.grey[400],
          press: () async {
            await Provider.of<UserProvider>(context, listen: false).signOff();

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
      child: SizedBox(
        height: 200,
        width: 200,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Consumer<UserProvider>(
              builder: (context, user, child) {
                return CircleAvatar(
                  backgroundImage: (user.profilBild != null)
                      ? NetworkImage(
                          "https://app.lebensqualitaet-burgrieden.de/" +
                              user.profilBild)
                      : Image.asset("assets/images/profilePic_default.png")
                          .image,
                );
              },
            ),
            Positioned(
              right: -16,
              bottom: 0,
              child: SizedBox(
                height: 60,
                width: 60,
                // ignore: deprecated_member_use
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      width: 3.0,
                      color: ColorPalette.white.rgb,
                    ),
                  ),
                  color: ColorPalette.malibu.rgb,
                  onPressed: getImage,
                  child: CircleAvatar(
                    backgroundColor: ColorPalette.malibu.rgb,
                    child: Icon(
                      Icons.edit,
                      color: ColorPalette.white.rgb,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(
      () {
        if (pickedFile != null) {
          profileImage = File(pickedFile.path);
          Provider.of<UserProvider>(context, listen: false)
              .changeProfileImage(profileImage);
        }
      },
    );
  }
}
