import 'dart:developer';
import 'dart:io';

import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/defaults/error_preview_box.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/components/rounded_button_dynamic.dart';
import 'package:aktiv_app_flutter/Models/role_permissions.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VeranstaltungDetailView extends StatefulWidget {
  int id;

  VeranstaltungDetailView(this.id);

  @override
  _VeranstaltungDetailViewState createState() =>
      _VeranstaltungDetailViewState();
}

class _VeranstaltungDetailViewState extends State<VeranstaltungDetailView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<Veranstaltung>(
        future: Provider.of<EventProvider>(context, listen: false)
            .loadEventById(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null)
            return Center(
                child: ErrorPreviewBox(
                    "Fehler 404 - Es konnte keine passende Veranstaltung aus der Datenbank geladen werden.",
                    "Fehler beim Laden"));

          final veranstaltung = snapshot.data;

          bool offerToDelete =
              veranstaltung.erstellerId == UserProvider.userId ||
                  Provider.of<UserProvider>(context, listen: false)
                          .rolle
                          .toLowerCase() ==
                      "betreiber";

          return LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: <Widget>[
                        Visibility(
                          visible: veranstaltung.institutBeschreibung != null &&
                              veranstaltung.institutionName != null,
                          child: Container(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              // height: size.height * 0.3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: ClipOval(
                                      child: Container(
                                        width: size.width * 0.35,
                                        height: size.width * 0.35,
                                        child: Provider.of<EventProvider>(
                                                context,
                                                listen: false)
                                            .getPreviewImage(veranstaltung.id),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      // width: size.width * 0.60,
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Text(
                                            veranstaltung.institutionName ??
                                                "404",
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: ColorPalette.black.rgb,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            veranstaltung
                                                    .institutBeschreibung ??
                                                "404",
                                            textAlign: TextAlign.left,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: ColorPalette.black.rgb,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: veranstaltung.getImages().length > 0,
                          child: Expanded(
                            // A flexible child that will grow to fit the viewport but
                            // still be at least as big as necessary to fit its contents.
                            child: Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                children: [
                                  Container(
                                    width: size.width,
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                        height: size.height * 0.3,
                                      ),
                                      items: veranstaltung
                                          .getImages()
                                          .map((image) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                                // decoration: BoxDecoration(
                                                //     color:
                                                //         ColorPalette.malibu.rgb),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: image,
                                                ));
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: size.width * 0.9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          5), //Abstand um den Button herum (oben/unten)
                                  width: size.width * 0.9,
                                  child: Divider(
                                    color: ColorPalette.malibu.rgb,
                                    thickness: 2,
                                  ),
                                ),
                                Container(
                                    width: size.width * 0.9,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      veranstaltung.titel + '\n',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )),
                                Container(
                                    alignment: Alignment.topLeft,
                                    width: size.width * 0.9,
                                    child: Text(
                                      veranstaltung.beschreibung,
                                      maxLines: 5,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          5), //Abstand um den Button herum (oben/unten)
                                  width: size.width * 0.9,
                                  child: Divider(
                                    color: ColorPalette.malibu.rgb,
                                    thickness: 2,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        width: size.width * 0.4,
                                        alignment: Alignment.centerLeft,
                                        child: Text('Adresse')),
                                    Container(
                                        width: size.width * 0.4,
                                        alignment: Alignment.centerRight,
                                        child: Text(veranstaltung.ortBeschr)),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          5), //Abstand um den Button herum (oben/unten)
                                  width: size.width * 0.9,
                                  child: Divider(
                                    color: ColorPalette.malibu.rgb,
                                    thickness: 2,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        width: size.width * 0.4,
                                        alignment: Alignment.centerLeft,
                                        child: Text('Beginn:')),
                                    Container(
                                        width: size.width * 0.4,
                                        alignment: Alignment.centerRight,
                                        child: Text(DateFormat(
                                                    'dd.MM.yyyy – kk:mm')
                                                .format(
                                                    veranstaltung.beginnTs) +
                                            " Uhr")),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          5), //Abstand um den Button herum (oben/unten)
                                  width: size.width * 0.9,
                                  child: Divider(
                                    color: ColorPalette.malibu.rgb,
                                    thickness: 2,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        width: size.width * 0.4,
                                        alignment: Alignment.centerLeft,
                                        child: Text('Ende')),
                                    Container(
                                        width: size.width * 0.4,
                                        alignment: Alignment.centerRight,
                                        child: Text(DateFormat(
                                                    'dd.MM.yyyy – kk:mm')
                                                .format(veranstaltung.endeTs) +
                                            " Uhr")),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          5), //Abstand um den Button herum (oben/unten)
                                  width: size.width * 0.9,
                                  child: Divider(
                                    color: ColorPalette.malibu.rgb,
                                    thickness: 2,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        width: size.width * 0.4,
                                        alignment: Alignment.centerLeft,
                                        child: Text('Kontakt')),
                                    Container(
                                        width: size.width * 0.4,
                                        alignment: Alignment.centerRight,
                                        child: Text(veranstaltung.kontakt)),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          5), //Abstand um den Button herum (oben/unten)
                                  width: size.width * 0.9,
                                  child: Divider(
                                    color: ColorPalette.malibu.rgb,
                                    thickness: 2,
                                  ),
                                ),
                                Visibility(
                                    visible: offerToDelete,
                                    child: RoundedButton(
                                      text: "Veranstaltung löschen",
                                      color: ColorPalette.orange.rgb,
                                      press: () async {
                                        //TODO: Veranstaltung löschen
                                        //
                                        //
                                        if (await confirm(
                                          context,
                                          title: Text("Bestätigung"),
                                          content: Text(
                                              "Möchten Sie dieser Veranstaltung wirklich löschen?"),
                                          textOK: Text(
                                            "Bestätigen",
                                            style: TextStyle(
                                                color:
                                                    ColorPalette.dark_grey.rgb),
                                          ),
                                          textCancel: Text(
                                            "Abbrechen",
                                            style: TextStyle(
                                                color:
                                                    ColorPalette.endeavour.rgb),
                                          ),
                                        )) {
                                          var accessToken =
                                              await Provider.of<UserProvider>(
                                                      context,
                                                      listen: false)
                                                  .getAccessToken();

                                          Provider.of<EventProvider>(context,
                                                  listen: false)
                                              .removeEventIfLoaded(
                                                  veranstaltung.id);
                                          attemptDeleteVeranstaltung(
                                              veranstaltung.id.toString(),
                                              accessToken);

                                          Provider.of<BodyProvider>(context,
                                                  listen: false)
                                              .previousBody(context);
                                        }
                                      },
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
