import 'dart:math';

import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_list.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_numeric.dart';
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
                icon: firstTabIcon(),
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

  Icon firstTabIcon() {
    switch (userGruppe) {
      case 0:
        return Icon(
          Icons.apartment_rounded,
          color: ColorPalette.black.rgb,
        );
        break;
      case 1:
        return Icon(
          Icons.check_circle_outline,
          color: ColorPalette.black.rgb,
        );
      case 2:
        return Icon(
          Icons.list,
          color: ColorPalette.black.rgb,
        );
      default:
        return Icon(
          Icons.apartment_rounded,
          color: ColorPalette.black.rgb,
        );
    }
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

  Card verwalterVerwaltenCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToCollapse: true,
              ),
              header: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person_add_alt_1,
                      size: 40.0,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text("Verwalter hinzufügen"),
                  ],
                ),
              ),
              collapsed: SizedBox(height: 2.0),
              expanded: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text("Email-Adresse des neuen Verwalters eingeben"),
                    RoundedInputEmailField(
                      hintText: "Email",
                    ),
                    SizedBox(height: 10.0),
                    RoundedButton(
                      text: "Verwalter hinzufügen",
                      color: ColorPalette.endeavour.rgb,
                      press: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card genehmigerVerwaltenCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToCollapse: true,
              ),
              header: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person_add_alt_1,
                      size: 40.0,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text("Genehmiger hinzufügen/bearbeiten"),
                  ],
                ),
              ),
              collapsed: SizedBox(height: 2.0),
              expanded: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text("Email-Adresse des Genehmigers eingeben"),
                    RoundedInputEmailField(
                      hintText: "Email",
                    ),
                    SizedBox(height: 10.0),
                    Text("Postleizahl(en) des Genehmigers eingeben"),
                    RoundedInputFieldNumeric(
                      hintText: "88483, 80331, 20095, ...",
                    ),
                    SizedBox(height: 10.0),
                    RoundedButton(
                      text: "Daten aktualisieren",
                      color: ColorPalette.endeavour.rgb,
                      press: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card genehmigerCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(
              "Keine Berechtigung zur Benutzererwaltung vorhanden.\nBitte wenden Sie sich an den Betreiber.",
              style: TextStyle(fontSize: 20.0, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Card benutzerLoschenCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToCollapse: true,
              ),
              header: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person_remove,
                      size: 40.0,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text("Benutzer löschen"),
                  ],
                ),
              ),
              collapsed: SizedBox(height: 2.0),
              expanded: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text("Email-Adresse des Benutzers eingeben"),
                    RoundedInputEmailField(
                      hintText: "Email",
                    ),
                    SizedBox(height: 10.0),
                    RoundedButton(
                      text: "Benutzer löschen",
                      color: ColorPalette.endeavour.rgb,
                      press: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card zuGenehmigen() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100.0,
            child: Container(
              decoration: BoxDecoration(
                  color: ColorPalette.malibu.rgb, shape: BoxShape.rectangle),
            ),
          ),
          ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToCollapse: true,
              ),
              header: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.event_note_rounded,
                      size: 40.0,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text("Beispielveranstaltung"),
                  ],
                ),
              ),
              collapsed: SizedBox(height: 2.0),
              expanded: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                      style: TextStyle(color: ColorPalette.black.rgb),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical:
                              5), //Abstand um den Button herum (oben/unten)
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  institutionenVerwalten() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100.0,
            child: Container(
              decoration: BoxDecoration(
                  color: ColorPalette.endeavour.rgb, shape: BoxShape.rectangle),
            ),
          ),
          ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToCollapse: true,
              ),
              header: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.image_aspect_ratio_sharp,
                      size: 40.0,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text("Institution A"),
                  ],
                ),
              ),
              collapsed: SizedBox(height: 2.0),
              expanded: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Beschreibung der Institution",
                      style: TextStyle(color: ColorPalette.black.rgb),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical:
                              5), //Abstand um den Button herum (oben/unten)
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
                          vertical:
                              5), //Abstand um den Button herum (oben/unten)
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
