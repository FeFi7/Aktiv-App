import 'dart:io';
import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/institution/institution_view.dart';
import 'package:aktiv_app_flutter/Views/profile/components/background.dart';
import 'package:aktiv_app_flutter/Views/profile/components/profile_einstellungen.dart';
import 'package:aktiv_app_flutter/Views/profile/components/profile_verwalten.dart';
import 'package:aktiv_app_flutter/Views/profile/info.dart';
import 'package:aktiv_app_flutter/Views/welcome_screen.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
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
            buildName(),
            SizedBox(height: 10),
            buildMail(),
            SizedBox(height: 10),
            buildPlzOrt(),
            SizedBox(height: 25),
            buttons(context),
          ],
        ),
      ),
    );
  }

  Text buildName() {
    if (Provider.of<UserProvider>(context, listen: false).vorname != null &&
        Provider.of<UserProvider>(context, listen: false).vorname != "null" &&
        Provider.of<UserProvider>(context, listen: false).nachname != null &&
        Provider.of<UserProvider>(context, listen: false).nachname != "null" &&
        UserProvider.istEingeloggt) {
      return Text(
        Provider.of<UserProvider>(context, listen: false).vorname +
            " " +
            Provider.of<UserProvider>(context, listen: false).nachname,
        style: TextStyle(
            fontSize: 18.0,
            color: ColorPalette.torea_bay.rgb,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w900),
      );
    } else if (!UserProvider.istEingeloggt) {
      return Text(
        "nicht registrierter Benutzer\n\n(Funktionen eingeschränkt)",
        style: TextStyle(color: ColorPalette.grey.rgb),
      );
    }
    return Text("");
  }

  Text buildMail() {
    if (Provider.of<UserProvider>(context, listen: false).mail != null &&
        Provider.of<UserProvider>(context, listen: false).mail != "null" &&
        UserProvider.istEingeloggt) {
      return Text(
        Provider.of<UserProvider>(context, listen: false).mail,
        style: TextStyle(
            fontSize: 18.0,
            color: ColorPalette.torea_bay.rgb,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w500),
      );
    }
    return Text("");
  }

  Text buildPlzOrt() {
    if (Provider.of<UserProvider>(context, listen: false).plz != null &&
        Provider.of<UserProvider>(context, listen: false).ort != null &&
        Provider.of<UserProvider>(context, listen: false).ort != "null" &&
        UserProvider.istEingeloggt) {
      return Text(
        Provider.of<UserProvider>(context, listen: false).plz.toString() +
            ", " +
            Provider.of<UserProvider>(context, listen: false).ort,
        style: TextStyle(
            fontSize: 18.0,
            color: ColorPalette.torea_bay.rgb,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w500),
      );
    } else if (Provider.of<UserProvider>(context, listen: false).plz != null &&
        UserProvider.istEingeloggt) {
      return Text(
        Provider.of<UserProvider>(context, listen: false).plz.toString(),
        style: TextStyle(
            fontSize: 18.0,
            color: ColorPalette.torea_bay.rgb,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w500),
      );
    }
    return Text("");
  }

  Column buttons(BuildContext context) {
    if (UserProvider.istEingeloggt) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 10),
          Visibility(
            visible: Provider.of<UserProvider>(context, listen: false)
                    .hatVerwalteteInstitutionen ||
                (Provider.of<UserProvider>(context, listen: false)
                        .rolle
                        .toLowerCase() !=
                    "user"),
            child: Container(
              child: verwaltenButton(context),
            ),
          ),
          persoenlichButton(context),
          institutionenButton(context),
          einstellungenButton(context),
          RoundedButton(
            text: "Hilfe",
            color: Colors.grey[400],
            press: () async {
              final url =
                  "https://app.lebensqualitaet-burgrieden.de/Benutzerhandbuch.pdf"; //Dokumentation/Anleitung der App
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
              if (UserProvider.istEingeloggt) {
                if (await confirm(
                  context,
                  title: Text("Bestätigung"),
                  content: Text("Möchten Sie sich abmelden?"),
                  textOK: Text(
                    "Bestätigen",
                    style: TextStyle(color: ColorPalette.grey.rgb),
                  ),
                  textCancel: Text(
                    "Abbrechen",
                    style: TextStyle(color: ColorPalette.endeavour.rgb),
                  ),
                )) {
                  Provider.of<EventProvider>(context, listen: false)
                      .resetEventListType(EventListType.FAVORITES);

                  await Provider.of<UserProvider>(context, listen: false)
                      .signOff();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return WelcomeScreen();
                      },
                    ),
                  );
                }
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return WelcomeScreen();
                    },
                  ),
                );
              }
            },
          ),
          TextButton(
            onPressed: () {
              Provider.of<BodyProvider>(context, listen: false)
                  .setBody(InfoView());
              Provider.of<AppBarTitleProvider>(context, listen: false)
                  .setTitle('');
            },
            child: Text("Info"),
          ),
          TextButton(
            onPressed: () async {
              final url =
                  "https://app.lebensqualitaet-burgrieden.de/Impressum.html";

              await launch(
                url,
                forceSafariVC: false,
                forceWebView: false,
              );
            },
            child: Text("Impressum"),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 10),
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
          TextButton(
            onPressed: () {
              Provider.of<BodyProvider>(context, listen: false)
                  .setBody(InfoView());
              Provider.of<AppBarTitleProvider>(context, listen: false)
                  .setTitle('');
            },
            child: Text("Info"),
          ),
          TextButton(
            onPressed: () async {
              final url =
                  "https://app.lebensqualitaet-burgrieden.de/Impressum.html";

              await launch(
                url,
                forceSafariVC: false,
                forceWebView: false,
              );
            },
            child: Text("Impressum"),
          ),
        ],
      );
    }
  }

  RoundedButton institutionenButton(BuildContext context) {
    return RoundedButton(
      text: "Institution beantragen",
      color: ColorPalette.endeavour.rgb,
      press: () {
        Provider.of<BodyProvider>(context, listen: false)
            .setBody(InstitutionView());
        Provider.of<AppBarTitleProvider>(context, listen: false)
            .setTitle('Institution beantragen');
      },
    );
  }

  RoundedButton einstellungenButton(BuildContext context) {
    return RoundedButton(
      text: "Einstellungen",
      color: ColorPalette.endeavour.rgb,
      press: () {
        Provider.of<BodyProvider>(context, listen: false)
            .setBody(ProfileEinstellungen());
        Provider.of<AppBarTitleProvider>(context, listen: false)
            .setTitle('Einstellungen');
      },
    );
  }

  RoundedButton persoenlichButton(BuildContext context) {
    return RoundedButton(
      text: "Persönliche Angaben",
      color: ColorPalette.endeavour.rgb,
      press: () {
        Provider.of<BodyProvider>(context, listen: false)
            .setBody(ProfilePersoenlich());
        Provider.of<AppBarTitleProvider>(context, listen: false)
            .setTitle('Persönliche Angaben');
      },
    );
  }

  RoundedButton verwaltenButton(BuildContext context) {
    return RoundedButton(
      text: "Verwalten",
      color: ColorPalette.endeavour.rgb,
      press: () {
        Provider.of<BodyProvider>(context, listen: false).setBody(
            ProfileVerwalten(
                userGruppe: Provider.of<UserProvider>(context, listen: false)
                    .rolle
                    .toString()));
        Provider.of<AppBarTitleProvider>(context, listen: false)
            .setTitle('Verwalten');
      },
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
                if (UserProvider.istEingeloggt) {
                  return CircleAvatar(
                    backgroundImage: (user.profilBild != null)
                        ? NetworkImage(
                            "https://app.lebensqualitaet-burgrieden.de/" +
                                user.profilBild)
                        : Image.asset("assets/images/profilePic_default.png")
                            .image,
                  );
                } else {
                  return CircleAvatar(
                    backgroundImage:
                        Image.asset("assets/images/profilePic_default.png")
                            .image,
                  );
                }
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
    if (UserProvider.istEingeloggt) {
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
}
