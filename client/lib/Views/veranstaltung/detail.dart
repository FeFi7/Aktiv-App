import 'dart:io';

import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/rounded_button_dynamic.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class VeranstaltungDetailView extends StatefulWidget {
  int id;

  VeranstaltungDetailView(this.id);

  @override
  _VeranstaltungDetailViewState createState() =>
      _VeranstaltungDetailViewState();
}

class _VeranstaltungDetailViewState extends State<VeranstaltungDetailView> {
  Veranstaltung veranstaltung;
  File profileImage;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    DateTime start = DateTime.now();
    DateTime ende = DateTime.now();
    DateTime erstellt = DateTime.now();
    //veranstaltung = Provider.of<EventProvider>(context, listen: false).getLoadedEventById(widget.id);
    veranstaltung = Veranstaltung.load(0, 'Titel', 'Beschreibung', 'kontakt',
        'Ortbeschreibung', start, ende, erstellt, 0, 0);
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Container(
                      height: size.height * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: ClipOval(
                              child: Container(
                                width: size.width * 0.35,
                                height: size.width * 0.35,
                                child: Image(
                                  image: AssetImage('assets/images/logo.png'),
                                  height: 100,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              width: size.width * 0.40,
                              child: RichText(
                                text: TextSpan(
                                  text: 'Name Veranstalter, + kurze Beschreibung',
                                  style: DefaultTextStyle.of(context).style,
                                ),
                                softWrap: true,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    // A flexible child that will grow to fit the viewport but
                    // still be at least as big as necessary to fit its contents.
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: size.width,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: size.height * 0.3,
                              ),
                              items: [1, 2, 3, 4, 5].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(
                                            color: ColorPalette.malibu.rgb),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Bild $i',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ));
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          Container(
                            child: Container(margin: EdgeInsets.fromLTRB(5, 15, 0, 0),
                              alignment: Alignment.bottomLeft,
                              child: RoundedButtonDynamic(
                                  width: size.width * 0.2,
                                  text: '+',
                                  textSize: 24,
                                  color: ColorPalette.orange.rgb,
                                  textColor: Colors.white,
                                  press: () async {
                                    await getImage();
                                    await attemptFileUpload('Bild1', profileImage);
                                  }),
                            ),
                          )
                        ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: size.width * 0.4,
                                  alignment: Alignment.centerLeft,
                                  child: Text('Beginn:')),
                              Container(
                                  width: size.width * 0.4,
                                  alignment: Alignment.centerRight,
                                  child: Text(veranstaltung.beginnTs.toString())),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: size.width * 0.4,
                                  alignment: Alignment.centerLeft,
                                  child: Text('Ende')),
                              Container(
                                  width: size.width * 0.4,
                                  alignment: Alignment.centerRight,
                                  child: Text(veranstaltung.endeTs.toString())),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: size.width * 0.4,
                                  alignment: Alignment.centerLeft,
                                  child: Text('Ersteller')),
                              Container(
                                  width: size.width * 0.4,
                                  alignment: Alignment.centerRight,
                                  child: Text('Max Mustermann')),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: size.width * 0.4,
                                  alignment: Alignment.centerLeft,
                                  child: Text('Genehmigt von:')),
                              Container(
                                  width: size.width * 0.4,
                                  alignment: Alignment.centerRight,
                                  child: Text('Erika Musterfrau')),
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
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(
      () {
        if (pickedFile != null) profileImage = File(pickedFile.path);
      },
    );
  }
}
