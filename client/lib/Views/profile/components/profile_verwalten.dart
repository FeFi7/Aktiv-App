import 'dart:io';
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
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileVerwalten extends StatefulWidget {
  var userGruppe;

  ProfileVerwalten({Key key, @required this.userGruppe}) : super(key: key);

  @override
  _ProfileVerwaltenState createState() => _ProfileVerwaltenState(userGruppe);
}

class _ProfileVerwaltenState extends State<ProfileVerwalten> {
  File institutionsImage;
  final picker = ImagePicker();

  var _userGruppe;
  final verwalterController = TextEditingController();
  final genehmigerController = TextEditingController();
  final betreiberController = TextEditingController();
  final benutzerController = TextEditingController();
  final plzController = TextEditingController();
  final _scrollController = ScrollController();
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
      case "user":
        return Column(
          children: <Widget>[
            Text(
              "Meine Institutionen",
              style: TextStyle(
                fontSize: 20.0,
                color: ColorPalette.endeavour.rgb,
              ),
            ),
            SizedBox(height: 10.0),
            institutionenVerwalten(),
          ],
        );
        break;
      case "genehmiger":
        return Column(
          children: <Widget>[
            Text(
              "Meine Institutionen",
              style: TextStyle(
                fontSize: 20.0,
                color: ColorPalette.endeavour.rgb,
              ),
            ),
            SizedBox(height: 10.0),
            institutionenVerwalten(),
            SizedBox(height: 30.0),
            Text(
              "Zu genehmigen",
              style: TextStyle(
                fontSize: 20.0,
                color: ColorPalette.endeavour.rgb,
              ),
            ),
            SizedBox(height: 10.0),
            zuGenehmigenVeranstaltungen(),
          ],
        );
      case "betreiber":
        return Column(
          children: <Widget>[
            // zuGenehmigenVeranstaltungen(), - vido
            Text(
              "Meine Institutionen",
              style: TextStyle(
                fontSize: 20.0,
                color: ColorPalette.endeavour.rgb,
              ),
            ),
            SizedBox(height: 10.0),
            institutionenVerwalten(),
            SizedBox(height: 30.0),
            Text(
              "Zu genehmigende Institutionen",
              style: TextStyle(
                fontSize: 20.0,
                color: ColorPalette.endeavour.rgb,
              ),
            ),
            SizedBox(height: 10.0),
            institutionenGenehmigen(),
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
      case "user":
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
                      .verwalterHinzufuegen(
                          verwalterController.text, institutionsId);
              if (verwalter == null) {
                errorToast("User nicht vorhanden");
              } else if (verwalter.statusCode != 200) {
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
              var verwalter = await Provider.of<UserProvider>(context,
                      listen: false)
                  .verwalterLoeschen(verwalterController.text, institutionsId);
              if (verwalter == null) {
                errorToast("User nicht vorhanden");
              } else if (verwalter.statusCode != 200) {
                errorToast("Fehler bei der Aktualisierung");
              } else {
                errorToast("Verwalter entfernt");
              }
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
          hintText: "Bsp.: 12345, 67891",
          controller: plzController,
        ),
        SizedBox(height: 10.0),
        RoundedButton(
          text: "Postleizahl hinzufügen",
          color: ColorPalette.endeavour.rgb,
          press: () async {
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text("Möchten Sie die PLZ zum Genehmiger hinzufügen?"),
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
                  .setGenehmiger(
                      genehmigerController.text, plzController.text.split(","));
              if (user == null) {
                errorToast("User nicht vorhanden");
              } else if (user.statusCode != 200) {
                errorToast("Fehler bei der Aktualisierung");
              } else {
                errorToast("PLZ dem Genehmiger hinzugefügt");
              }
            }
          },
        ),
        RoundedButton(
          text: "Postleizahl entfernen",
          color: ColorPalette.grey.rgb,
          press: () async {
            if (await confirm(
              context,
              title: Text("Bestätigung"),
              content: Text("Möchten Sie die PLZ dem Genehmiger entziehen?"),
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
                  .removeGenehmiger(
                      genehmigerController.text, plzController.text.split(","));
              if (user == null) {
                errorToast("User nicht vorhanden");
              } else if (user.statusCode != 200) {
                errorToast("Fehler bei der Aktualisierung");
              } else {
                errorToast("PLZ dem Genehmiger entzogen");
              }
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

  zuGenehmigenVeranstaltungen() {
    return CardDropDownImage(
      decoration: [
        Container(
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
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (user.profilBild != null)
                                ? NetworkImage(
                                    "https://app.lebensqualitaet-burgrieden.de/" +
                                        user.profilBild)
                                : Image.asset(
                                        "assets/images/profilePic_default.png")
                                    .image,
                          ),
                        ),
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
                  right: 0,
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
                      onPressed: () => getImage("1"),
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
        ),
        // BoxDecoration(
        //     color: ColorPalette.malibu.rgb, shape: BoxShape.rectangle),
      ],
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
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false)
            .getVerwalteteInstitutionen(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.none &&
              snapShot.hasData == null) {
            return Container();
          }
          return ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (snapShot.data != null) ? snapShot.data.length : 0,
              itemBuilder: (context, index) {
                return Container(
                  child: CardDropDownImage(
                    decoration: [
                      Container(
                        child: SizedBox(
                          height: 200,
                          width: size.width * 0.8,
                          child: Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (snapShot.data[index]
                                                ['institutionImage'] !=
                                            null)
                                        ? NetworkImage(
                                            "https://app.lebensqualitaet-burgrieden.de/" +
                                                snapShot.data[index]
                                                    ['institutionImage'])
                                        : Image.asset(
                                                "assets/images/institutionPic_default.png")
                                            .image,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                bottom: 5,
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
                                    onPressed: () => getImage(
                                        snapShot.data[index]['id'].toString()),
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
                      ),
                    ],
                    headerChildren: [
                      Icon(Icons.image_aspect_ratio_sharp, size: 40.0),
                      SizedBox(width: 20.0),
                      Text(snapShot.data[index]['name']),
                    ],
                    bodyChildren: [
                      Text(
                        snapShot.data[index]['beschreibung'],
                        style: TextStyle(color: ColorPalette.black.rgb),
                      ),
                      SizedBox(height: 40.0),
                      Text("Email-Adresse des neuen Verwalters eingeben"),
                      RoundedInputEmailField(
                        hintText: "Email",
                        controller: verwalterController,
                      ),
                      SizedBox(height: 20.0),
                      RoundedButton(
                        text: "Verwalter hinzufügen",
                        color: ColorPalette.endeavour.rgb,
                        press: () async {
                          if (await confirm(
                            context,
                            title: Text("Bestätigung"),
                            content: Text(
                                "Möchten Sie diesen Verwalter hinzufügen?"),
                            textOK: Text(
                              "Bestätigen",
                              style: TextStyle(color: ColorPalette.grey.rgb),
                            ),
                            textCancel: Text(
                              "Abbrechen",
                              style:
                                  TextStyle(color: ColorPalette.endeavour.rgb),
                            ),
                          )) {
                            var institutionGenehmigen =
                                await Provider.of<UserProvider>(context,
                                        listen: false)
                                    .verwalterHinzufuegen(
                                        verwalterController.text,
                                        snapShot.data[index]['id'].toString());
                            if (institutionGenehmigen == null) {
                              errorToast("User nicht vorhanden");
                            } else if (institutionGenehmigen.statusCode !=
                                200) {
                              errorToast("Fehler bei der Aktualisierung");
                            } else {
                              errorToast("Verwalter hinzugefügt");
                              verwalterController.clear();
                            }
                            setState(() {});
                          }
                        },
                      ),
                      Visibility(
                        visible: (snapShot.data[index]['ersteller'] !=
                                UserProvider.userId
                            ? false
                            : true),
                        child: RoundedButton(
                          text: "Verwalter entfernen",
                          color: ColorPalette.grey.rgb,
                          press: () async {
                            if (await confirm(
                              context,
                              title: Text("Bestätigung"),
                              content: Text(
                                  "Möchten Sie diesen Verwalter entfernen?"),
                              textOK: Text(
                                "Bestätigen",
                                style: TextStyle(color: ColorPalette.grey.rgb),
                              ),
                              textCancel: Text(
                                "Abbrechen",
                                style: TextStyle(
                                    color: ColorPalette.endeavour.rgb),
                              ),
                            )) {
                              var institutionGenehmigen = await Provider.of<
                                      UserProvider>(context, listen: false)
                                  .verwalterLoeschen(verwalterController.text,
                                      snapShot.data[index]['id'].toString());
                              if (institutionGenehmigen == null) {
                                errorToast("User nicht vorhanden");
                              } else if (institutionGenehmigen.statusCode !=
                                  200) {
                                errorToast("Fehler bei der Aktualisierung");
                              } else {
                                errorToast("Verwalter entfernt");
                              }
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Visibility(
                        visible: (snapShot.data[index]['ersteller'] !=
                                UserProvider.userId
                            ? false
                            : true),
                        child: RoundedButton(
                          text: "Institution löschen",
                          color: ColorPalette.grey.rgb,
                          press: () async {
                            if (await confirm(
                              context,
                              title: Text("Bestätigung"),
                              content: Text(
                                  "Möchten Sie diese Institution löschen?"),
                              textOK: Text(
                                "Bestätigen",
                                style: TextStyle(color: ColorPalette.grey.rgb),
                              ),
                              textCancel: Text(
                                "Abbrechen",
                                style: TextStyle(
                                    color: ColorPalette.endeavour.rgb),
                              ),
                            )) {
                              var institutionLoeschen = await Provider.of<
                                      UserProvider>(context, listen: false)
                                  .institutionLoeschen(
                                      snapShot.data[index]['id'].toString());
                              if (institutionLoeschen == null) {
                                errorToast("Institution nicht vorhanden");
                              } else if (institutionLoeschen.statusCode !=
                                  200) {
                                errorToast("Fehler bei der Aktualisierung");
                              } else {
                                errorToast("Institution gelöscht");
                              }
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  institutionenGenehmigen() {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false)
            .getUngenehmigteInstitutionen(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.none &&
              snapShot.hasData == null) {
            return Center(
                child: Container(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(),
            ));
          }
          return ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (snapShot.data != null) ? snapShot.data.length : 0,
              itemBuilder: (context, index) {
                return Container(
                  child: CardDropDownImage(
                    decoration: [
                      Container(
                        child: SizedBox(
                          height: 200,
                          width: size.width * 0.85,
                          child: Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (snapShot.data[index]
                                                ['institutionImage'] !=
                                            null)
                                        ? NetworkImage(
                                            "https://app.lebensqualitaet-burgrieden.de/" +
                                                snapShot.data[index]
                                                    ['institutionImage'])
                                        : Image.asset(
                                                "assets/images/institutionPic_default.png")
                                            .image,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    headerChildren: [
                      Icon(Icons.image_aspect_ratio_sharp, size: 40.0),
                      SizedBox(width: 20.0),
                      Text(snapShot.data[index]['name']),
                    ],
                    bodyChildren: [
                      Text(
                        snapShot.data[index]['beschreibung'],
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
                              width: 50,
                              alignment: Alignment.centerLeft,
                              child: Text('Kontakt')),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(snapShot.data[index]['mail']),
                          ),
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
                      RoundedButton(
                        text: "Institution genehmigen",
                        color: ColorPalette.endeavour.rgb,
                        press: () async {
                          if (await confirm(
                            context,
                            title: Text("Bestätigung"),
                            content: Text(
                                "Möchten Sie diese Institution genehmigen?"),
                            textOK: Text(
                              "Bestätigen",
                              style: TextStyle(color: ColorPalette.grey.rgb),
                            ),
                            textCancel: Text(
                              "Abbrechen",
                              style:
                                  TextStyle(color: ColorPalette.endeavour.rgb),
                            ),
                          )) {
                            var institutionGenehmigen =
                                await Provider.of<UserProvider>(context,
                                        listen: false)
                                    .institutionGenehmigen(
                                        snapShot.data[index]['id'].toString());
                            if (institutionGenehmigen == null) {
                              errorToast("Institution nicht vorhanden");
                            } else if (institutionGenehmigen.statusCode !=
                                200) {
                              errorToast("Fehler bei der Aktualisierung");
                            } else {
                              errorToast("Institution genehmigt");
                            }
                            setState(() {});
                          }
                        },
                      ),
                      RoundedButton(
                        text: "Institution löschen",
                        color: ColorPalette.grey.rgb,
                        press: () async {
                          if (await confirm(
                            context,
                            title: Text("Bestätigung"),
                            content:
                                Text("Möchten Sie diese Institution löschen?"),
                            textOK: Text(
                              "Bestätigen",
                              style: TextStyle(color: ColorPalette.grey.rgb),
                            ),
                            textCancel: Text(
                              "Abbrechen",
                              style:
                                  TextStyle(color: ColorPalette.endeavour.rgb),
                            ),
                          )) {
                            var institutionLoeschen =
                                await Provider.of<UserProvider>(context,
                                        listen: false)
                                    .institutionLoeschen(
                                        snapShot.data[index]['id'].toString());
                            if (institutionLoeschen == null) {
                              errorToast("Institution nicht vorhanden");
                            } else if (institutionLoeschen.statusCode != 200) {
                              errorToast("Fehler bei der Aktualisierung");
                            } else {
                              errorToast("Institution gelöscht");
                            }
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                );
              });
        });
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

  Future getImage(String institutionId) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(
      () {
        if (pickedFile != null) {
          institutionsImage = File(pickedFile.path);
          Provider.of<UserProvider>(context, listen: false)
              .attemptImageForInstitution(institutionsImage, institutionId);
        }
      },
    );
  }
}
