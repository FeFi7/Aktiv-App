import 'dart:io';

import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
   
  
  @override
  Widget build(BuildContext context) {
    
  veranstaltung = Provider.of<EventProvider>(context, listen: false).getLoadedEventById(widget.id);
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
                                  text: veranstaltung.titel,
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
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(width:size.width*0.9,
                      child: Column(mainAxisAlignment: MainAxisAlignment.start,
                      
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
                                'Bsp Veranstaltung\n',
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
                                'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolo',
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
                    child: Container(margin: EdgeInsets.only(bottom:10),
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
                                  child: Text('Prittwitzstraße 10, 89075 Ulm')),
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
                                  child: Text('16.04.2021, 16:00 Uhr')),
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
                                  child: Text('19.04.2021, 20:00 Uhr')),
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
                                  child: Text('max@mustermann.de')),
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
}
