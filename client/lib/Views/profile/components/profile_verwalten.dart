import 'package:aktiv_app_flutter/Models/role_permissions.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/card_dropdown.dart';
import 'package:aktiv_app_flutter/components/card_dropdown_with_image.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_numeric_komma.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ProfileVerwalten extends StatefulWidget {
  var userGruppe;

  ProfileVerwalten({Key key, @required this.userGruppe}) : super(key: key);

  @override
  _ProfileVerwaltenState createState() => _ProfileVerwaltenState(userGruppe);
}

class _ProfileVerwaltenState extends State<ProfileVerwalten> {
  var _userGruppe;
  final verwalterController = TextEditingController();
  final genehmigerController = TextEditingController();
  final betreiberController = TextEditingController();
  final benutzerController = TextEditingController();
  final plzController = TextEditingController();
  String institutionValue =
      "Institution wählen"; //erstes Item aus Insitutionen Liste

  List<String> institutionen = [
    "Institution wählen",
    "Institution A",
    "Institution B",
    "Institution C"
  ];

  _ProfileVerwaltenState(this._userGruppe);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.list,
                  color: ColorPalette.black.rgb,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.admin_panel_settings_outlined,
                  color: ColorPalette.black.rgb,
                ),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              firstTab(),
              secondTab(),
            ],
          ),
        ),
      ),
    );
  }

//Veranstaltungs-/Institutionsbezogener Tab
  SingleChildScrollView firstTab() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ExpandableNotifier(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:
                  buildFirstTab(), //in abhängigkeit der Usergruppe, Tab bauen
            ),
          ),
        ],
      ),
    );
  }

//Benutzerbezogener Tab
  SingleChildScrollView secondTab() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ExpandableNotifier(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:
                  buildSecondTab(), //in abhängigkeit der Usergruppe, Tab bauen
            ),
          ),
        ],
      ),
    );
  }

  //Veranstaltungs-/Institutionsbezogener Tab
  Column buildFirstTab() {
    switch (_userGruppe.toLowerCase()) {
      case "verwalter":
        return Column(
          children: <Widget>[
            institutionenVerwalten(),
          ],
        );
        break;
      case "genehmiger":
        return Column(
          children: <Widget>[
            zuGenehmigen(),
            //institutionenVerwalten(),
          ],
        );
      case "betreiber":
        return Column(
          children: <Widget>[
            zuGenehmigen(),
            institutionenVerwalten(),
          ],
        );
      default:
        return Column(
          children: <Widget>[],
        );
    }
  }

//Benutzerbezogener Tab
  Column buildSecondTab() {
    switch (_userGruppe.toLowerCase()) {
      case "verwalter":
        return Column(
          children: <Widget>[
            //verwalterVerwaltenCard(),
          ],
        );
        break;
      case "genehmiger":
        return Column(
          children: <Widget>[
            genehmigerCard(),
          ],
        );
      case "betreiber":
        return Column(
          children: <Widget>[
            //verwalterVerwaltenCard(),
            genehmigerVerwaltenCard(),
            betreiberVerwaltenCard(),
            benutzerLoschenCard(),
          ],
        );
      default:
        return Column(
          children: <Widget>[],
        );
    }
  }

  verwalterVerwaltenCard() {
    Size size = MediaQuery.of(context).size;
    return CardDropDown(
      headerChildren: [
        Icon(
          Icons.person_search,
          size: 40.0,
        ),
        SizedBox(width: 20.0),
        Text("Verwalter verwalten"),
      ],
      bodyChildren: [
        Text("Email-Adresse des neuen Verwalters eingeben"),
        RoundedInputEmailField(
          hintText: "Email",
          controller: verwalterController,
        ),
        SizedBox(height: 10.0),
        Container(
          width: size.width * 0.75,
          height: 60.0,
          child: DropdownButton<String>(
            value: institutionValue,
            // icon: const Icon(Icons.apartment_rounded),
            // iconSize: 24,
            elevation: 12,
            style: const TextStyle(color: Colors.black),
            onChanged: (String newValue) {
              setState(() {
                if (newValue != null) institutionValue = newValue;
              });
            },
            items: institutionen.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value,
                child: Row(
                  children: [
                    Icon(Icons.apartment_rounded),
                    SizedBox(width: 20.0),
                    Text(
                      value,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10.0),
        RoundedButton(
          text: "Verwalter hinzufügen",
          color: ColorPalette.endeavour.rgb,
          press: () async {
            var institutionsId = "1";
            // var verwalter =
            //     await Provider.of<UserProvider>(context, listen: false)
            //         .setRole(verwalterController.text, "verwalter");
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text("Möchten Sie den Verwalter hinzufügen?"),
              textOK: Text(
                "Bestätigen",
                style: TextStyle(color: ColorPalette.grey.rgb),
              ),
              textCancel: Text(
                "Abbrechen",
                style: TextStyle(color: ColorPalette.endeavour.rgb),
              ),
            )) {
              var verwalter =
                  await Provider.of<UserProvider>(context, listen: false)
                      .setVerwalter(verwalterController.text, institutionsId);
              if (verwalter.statusCode != 200) {
                errorToast("Fehler bei der Aktualisierung");
              } else {
                errorToast("Verwalter hinzugefügt");
              }
            }
          },
        ),
        RoundedButton(
          text: "Verwalter entfernen",
          color: ColorPalette.grey.rgb,
          press: () async {
            var institutionsId = "1";
            // var verwalter =
            //     await Provider.of<UserProvider>(context, listen: false)
            //         .setRole(verwalterController.text, "verwalter");
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text("Möchten Sie den Verwalter entfernen?"),
              textOK: Text(
                "Bestätigen",
                style: TextStyle(color: ColorPalette.grey.rgb),
              ),
              textCancel: Text(
                "Abbrechen",
                style: TextStyle(color: ColorPalette.endeavour.rgb),
              ),
            )) {
              //TODO verwalter entfernen
              // var verwalter =
              //     await Provider.of<UserProvider>(context, listen: false)
              //         .setVerwalter(verwalterController.text, institutionsId);
              // if (verwalter.statusCode != 200) {
              //   errorToast("Fehler bei der Aktualisierung");
              // } else {
              //   errorToast("Verwalter entfernt");
              // }
            }
          },
        ),
      ],
    );
  }

  betreiberVerwaltenCard() {
    return CardDropDown(
      headerChildren: [
        Icon(
          Icons.person_search,
          size: 40.0,
        ),
        SizedBox(width: 20.0),
        Text("Betreiber verwalten"),
      ],
      bodyChildren: [
        Text("Email-Adresse des Betreibers eingeben"),
        RoundedInputEmailField(
          hintText: "Email",
          controller: betreiberController,
        ),
        SizedBox(height: 10.0),
        RoundedButton(
          text: "Betreiber hinzufügen",
          color: ColorPalette.endeavour.rgb,
          press: () async {
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text("Möchten Sie den Betreiber hinzufügen?"),
              textOK: Text(
                "Bestätigen",
                style: TextStyle(color: ColorPalette.grey.rgb),
              ),
              textCancel: Text(
                "Abbrechen",
                style: TextStyle(color: ColorPalette.endeavour.rgb),
              ),
            )) {
              var user = await Provider.of<UserProvider>(context, listen: false)
                  .setRole(betreiberController.text, "betreiber");
              if (user == null) {
                errorToast("User nicht vorhanden");
              } else if (user.statusCode != 200) {
                errorToast("Fehler bei der Aktualisierung");
              } else {
                errorToast("Betreiber hinzugefügt");
              }
            }
          },
        ),
        SizedBox(height: 10.0),
        RoundedButton(
          text: "Betreiber entfernen",
          color: ColorPalette.grey.rgb,
          press: () async {
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text("Möchten Sie den Betreiber wirklich entfernen?"),
              textOK: Text(
                "Bestätigen",
                style: TextStyle(color: ColorPalette.grey.rgb),
              ),
              textCancel: Text(
                "Abbrechen",
                style: TextStyle(color: ColorPalette.endeavour.rgb),
              ),
            )) {
              var user = await Provider.of<UserProvider>(context, listen: false)
                  .setRole(betreiberController.text, "user");
              if (user == null) {
                errorToast("User nicht vorhanden");
              } else if (user.statusCode != 200) {
                errorToast("Fehler bei der Aktualisierung");
              } else {
                errorToast("Betreiber entfernt");
              }
            }
          },
        ),
      ],
    );
  }

  genehmigerVerwaltenCard() {
    return CardDropDown(
      headerChildren: [
        Icon(
          Icons.person_search,
          size: 40.0,
        ),
        SizedBox(
          width: 20.0,
        ),
        Text("Genehmiger verwalten"),
      ],
      bodyChildren: [
        Text("Email-Adresse des Genehmigers eingeben"),
        RoundedInputEmailField(
          hintText: "Email",
          controller: genehmigerController,
        ),
        SizedBox(height: 10.0),
        Text("Postleizahl(en) des Genehmigers eingeben"),
        RoundedInputFieldNumericKomma(
          hintText: "88483, 80331, 20095, ...",
          controller: plzController,
        ),
        SizedBox(height: 10.0),
        RoundedButton(
          text: "Postleizahlen aktualisieren",
          color: ColorPalette.endeavour.rgb,
          press: () async {
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content:
                  Text("Möchten Sie die genannten PLZ-Angaben aktualisieren?"),
              textOK: Text(
                "Bestätigen",
                style: TextStyle(color: ColorPalette.grey.rgb),
              ),
              textCancel: Text(
                "Abbrechen",
                style: TextStyle(color: ColorPalette.endeavour.rgb),
              ),
            )) {
              //TODO Genehmiger hinzufügen von PLZs
            }
          },
        ),
      ],
    );
  }

  Card genehmigerCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        child: Text(
          "Keine Berechtigung zur Benutzererwaltung vorhanden.\nBitte wenden Sie sich an den Betreiber.",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  benutzerLoschenCard() {
    return CardDropDown(
      headerChildren: [
        Icon(
          Icons.person_remove,
          size: 40.0,
        ),
        SizedBox(
          width: 20.0,
        ),
        Text("Benutzer löschen"),
      ],
      bodyChildren: [
        Text("Email-Adresse des Benutzers eingeben"),
        RoundedInputEmailField(
          hintText: "Email",
          controller: benutzerController,
        ),
        SizedBox(height: 10.0),
        RoundedButton(
          text: "Benutzer löschen",
          color: ColorPalette.grey.rgb,
          press: () async {
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text("Möchten Sie diesen Benutzer wirklich löschen?"),
              textOK: Text(
                "Bestätigen",
                style: TextStyle(color: ColorPalette.grey.rgb),
              ),
              textCancel: Text(
                "Abbrechen",
                style: TextStyle(color: ColorPalette.endeavour.rgb),
              ),
            )) {
              var user = await Provider.of<UserProvider>(context, listen: false)
                  .deleteUser(benutzerController.text);
              if (user == null) {
                errorToast("User nicht vorhanden");
              } else if (user.statusCode != 200) {
                errorToast("Fehler beim Löschen");
              } else {
                errorToast("User gelöscht");
              }
            }
          },
        ),
      ],
    );
  }

  zuGenehmigen() {
    return CardDropDownImage(
      decoration: BoxDecoration(
          color: ColorPalette.malibu.rgb, shape: BoxShape.rectangle),
      headerChildren: [
        Icon(
          Icons.event_note_rounded,
          size: 40.0,
        ),
        SizedBox(
          width: 20.0,
        ),
        Text("Beispielveranstaltung"),
      ],
      bodyChildren: [
        Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
          style: TextStyle(color: ColorPalette.black.rgb),
        ),
        SizedBox(height: 20.0),
        Container(
          margin: EdgeInsets.symmetric(
              vertical: 5), //Abstand um den Button herum (oben/unten)
          width: 250,
          child: Divider(
            color: ColorPalette.malibu.rgb,
            thickness: 2,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: 150,
                alignment: Alignment.centerLeft,
                child: Text('Kontakt')),
            Container(
                width: 150,
                alignment: Alignment.centerRight,
                child: Text('max@mustermann.de')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: 150,
                alignment: Alignment.centerLeft,
                child: Text('Ersteller')),
            Container(
                width: 150,
                alignment: Alignment.centerRight,
                child: Text('Max Mustermann')),
          ],
        ),
        SizedBox(height: 20.0),
        RoundedButton(
          text: "Veranstaltung genehmigen",
          color: ColorPalette.endeavour.rgb,
          press: () async {
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text("Möchten Sie diese Veranstaltung genehmigen?"),
              textOK: Text(
                "Bestätigen",
                style: TextStyle(color: ColorPalette.grey.rgb),
              ),
              textCancel: Text(
                "Abbrechen",
                style: TextStyle(color: ColorPalette.endeavour.rgb),
              ),
            )) {
              //TODO Veranstaltung genehmigen
            }
          },
        ),
        RoundedButton(
          text: "Veranstaltung ablehnen",
          color: ColorPalette.grey.rgb,
          press: () async {
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text("Möchten Sie diese Veranstaltung ablehnen?"),
              textOK: Text(
                "Bestätigen",
                style: TextStyle(color: ColorPalette.grey.rgb),
              ),
              textCancel: Text(
                "Abbrechen",
                style: TextStyle(color: ColorPalette.endeavour.rgb),
              ),
            )) {
              //TODO Veranstaltung ablehnen
            }
          },
        ),
      ],
    );
  }

  institutionenVerwalten() {
    return CardDropDownImage(
      decoration: BoxDecoration(
        color: ColorPalette.endeavour.rgb,
        shape: BoxShape.rectangle,
      ),
      headerChildren: [
        Icon(
          Icons.image_aspect_ratio_sharp,
          size: 40.0,
        ),
        SizedBox(
          width: 20.0,
        ),
        Text("Institution A"),
      ],
      bodyChildren: [
        Text(
          "Beschreibung der Institution",
          style: TextStyle(color: ColorPalette.black.rgb),
        ),
        SizedBox(height: 20.0),
        Container(
          margin: EdgeInsets.symmetric(
              vertical: 5), //Abstand um den Button herum (oben/unten)
          width: 250,
          child: Divider(
            color: ColorPalette.malibu.rgb,
            thickness: 2,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: 150,
                alignment: Alignment.centerLeft,
                child: Text('Kontakt')),
            Container(
                width: 150,
                alignment: Alignment.centerRight,
                child: Text('max@mustermann.de')),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(
              vertical: 5), //Abstand um den Button herum (oben/unten)
          width: 250,
          child: Divider(
            color: ColorPalette.malibu.rgb,
            thickness: 2,
          ),
        ),
        SizedBox(height: 20.0),
        Text("Email-Adresse des Benutzers eingeben"),
        RoundedInputEmailField(
          hintText: "Email",
        ),
        RoundedButton(
          text: "Verwalter hinzufügen",
          color: ColorPalette.endeavour.rgb,
          press: () async {
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text(
                  "Möchten Sie dieser Institution den angegebenen Verwalter hinzufügen?"),
              textOK: Text(
                "Bestätigen",
                style: TextStyle(color: ColorPalette.grey.rgb),
              ),
              textCancel: Text(
                "Abbrechen",
                style: TextStyle(color: ColorPalette.endeavour.rgb),
              ),
            )) {
              //TODO Verwalter hinzufügen
            }
          },
        ),
        RoundedButton(
          text: "Verwalter entfernen",
          color: ColorPalette.grey.rgb,
          press: () async {
            var institutionsId = "1";
            // var verwalter =
            //     await Provider.of<UserProvider>(context, listen: false)
            //         .setRole(verwalterController.text, "verwalter");
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text("Möchten Sie den Verwalter entfernen?"),
              textOK: Text(
                "Bestätigen",
                style: TextStyle(color: ColorPalette.grey.rgb),
              ),
              textCancel: Text(
                "Abbrechen",
                style: TextStyle(color: ColorPalette.endeavour.rgb),
              ),
            )) {
              //TODO verwalter entfernen
              // var verwalter =
              //     await Provider.of<UserProvider>(context, listen: false)
              //         .setVerwalter(verwalterController.text, institutionsId);
              // if (verwalter.statusCode != 200) {
              //   errorToast("Fehler bei der Aktualisierung");
              // } else {
              //   errorToast("Verwalter entfernt");
              // }
            }
          },
        ),
        SizedBox(height: 20.0),
        RoundedButton(
          text: "Institution löschen",
          color: ColorPalette.grey.rgb,
          press: () async {
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text("Möchten Sie diese Institution löschen?"),
              textOK: Text(
                "Bestätigen",
                style: TextStyle(color: ColorPalette.grey.rgb),
              ),
              textCancel: Text(
                "Abbrechen",
                style: TextStyle(color: ColorPalette.endeavour.rgb),
              ),
            )) {
              //TODO Institution löschen
            }
          },
        ),
      ],
    );
  }

  errorToast(String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorPalette.orange.rgb,
      textColor: ColorPalette.white.rgb,
    );
    FocusManager.instance.primaryFocus.unfocus();
  }
}
