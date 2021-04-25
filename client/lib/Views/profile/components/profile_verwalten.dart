import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/card_dropdown.dart';
import 'package:aktiv_app_flutter/components/card_dropdown_with_image.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_numeric_komma.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ProfileVerwalten extends StatefulWidget {
  var userGruppe;

  ProfileVerwalten({Key key, @required this.userGruppe}) : super(key: key);

  @override
  _ProfileVerwaltenState createState() => _ProfileVerwaltenState(userGruppe);
}

class _ProfileVerwaltenState extends State<ProfileVerwalten> {
  int userGruppe;
  String institutionValue =
      "Institution wählen"; //erstes Item aus Insitutionen Liste

  List<String> institutionen = [
    "Institution wählen",
    "Institution A",
    "Institution B",
    "Institution C"
  ];

  _ProfileVerwaltenState(this.userGruppe);
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
    switch (userGruppe) {
      case 0:
        return Column(
          children: <Widget>[
            institutionenVerwalten(),
          ],
        );
        break;
      case 1:
        return Column(
          children: <Widget>[
            zuGenehmigen(),
            //institutionenVerwalten(),
          ],
        );
      case 2:
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
    switch (userGruppe) {
      case 0:
        return Column(
          children: <Widget>[
            verwalterVerwaltenCard(),
          ],
        );
        break;
      case 1:
        return Column(
          children: <Widget>[
            genehmigerCard(),
          ],
        );
      case 2:
        return Column(
          children: <Widget>[
            verwalterVerwaltenCard(),
            genehmigerVerwaltenCard(),
            benutzerLoschenCard(),
          ],
        );
      default:
        return Column(
          children: <Widget>[
            verwalterVerwaltenCard(),
          ],
        );
    }
  }

  verwalterVerwaltenCard() {
    Size size = MediaQuery.of(context).size;
    return CardDropDown(
      headerChildren: [
        Icon(
          Icons.person_add_alt_1,
          size: 40.0,
        ),
        SizedBox(width: 20.0),
        Text("Verwalter hinzufügen"),
      ],
      bodyChildren: [
        Text("Email-Adresse des neuen Verwalters eingeben"),
        RoundedInputEmailField(
          hintText: "Email",
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
          press: () {},
        ),
      ],
    );
  }

  genehmigerVerwaltenCard() {
    return CardDropDown(
      headerChildren: [
        Icon(
          Icons.person_add_alt_1,
          size: 40.0,
        ),
        SizedBox(
          width: 20.0,
        ),
        Text("Genehmiger hinzufügen/bearbeiten"),
      ],
      bodyChildren: [
        Text("Email-Adresse des Genehmigers eingeben"),
        RoundedInputEmailField(
          hintText: "Email",
        ),
        SizedBox(height: 10.0),
        Text("Postleizahl(en) des Genehmigers eingeben"),
        RoundedInputFieldNumericKomma(
          hintText: "88483, 80331, 20095, ...",
        ),
        SizedBox(height: 10.0),
        RoundedButton(
          text: "Postleizahl hinzufügen",
          color: ColorPalette.endeavour.rgb,
          press: () {},
        ),
        RoundedButton(
          text: "Postleizahl entfernen",
          color: ColorPalette.grey.rgb,
          press: () {},
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
        ));
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
        ),
        SizedBox(height: 10.0),
        RoundedButton(
          text: "Benutzer löschen",
          color: ColorPalette.grey.rgb,
          press: () {},
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
          press: () {},
        ),
        RoundedButton(
          text: "Veranstaltung ablehnen",
          color: ColorPalette.grey.rgb,
          press: () {},
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
          press: () {},
        ),
        SizedBox(height: 20.0),
        RoundedButton(
          text: "Institution löschen",
          color: ColorPalette.grey.rgb,
          press: () {},
        ),
      ],
    );
  }
}
