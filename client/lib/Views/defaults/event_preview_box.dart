import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/favorites/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Home.dart';

class EventPreviewBox extends StatefulWidget {
  final int id;
  final String titel;
  final String description;
  final String additive;
  bool liked;

  EventPreviewBox(
      this.id, this.titel, this.description, this.additive, this.liked);

  /// wär besser wenn liked nicht übergeben wird, sondern sich die info via id holt. Änderung folgt...

  @override
  _EventPreviewBoxState createState() => _EventPreviewBoxState();
}

class _EventPreviewBoxState extends State<EventPreviewBox> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FractionallySizedBox(
      widthFactor: 1,
      // heightFactor: 0.2,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: Color(0xFF00487d),
          //   width: 3,
          // ), Finde es ohne besser
          borderRadius:
              BorderRadius.all(Radius.circular(10.0)), // rundung der border
          color: ColorPalette.french_pass.rgb,
        ),
        height: size.height * 0.2,
        child: SizedBox(
          height: 128,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 100,
                width: 100,
                child: Container(
                  margin: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                        "assets/images/lq_logo_klein.png"), //Bild muss noch dynamisch werden
                  ),
                ),
              ),
              Container(
                width: size.width * 0.45,
                padding: const EdgeInsets.all(7.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.titel,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ))),
                    SizedBox(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.description,
                        style: TextStyle(fontSize: 12),
                        maxLines: 4,
                        overflow: TextOverflow
                            .ellipsis, //Mach ... bei zu langem Texts
                      ),
                    )),
                    Container(
                        child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        widget.additive,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ColorPalette.torea_bay.rgb),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          widget.liked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border,
                          color: widget.liked
                              ? ColorPalette.orange.rgb
                              : ColorPalette.black.rgb,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.liked = !widget.liked;
                            if (widget.liked) {
                              Provider.of<FavoritesProvider>(context,
                                      listen: false)
                                  .addFavorite(widget);
                            } else {
                              Provider.of<FavoritesProvider>(context,
                                      listen: false)
                                  .removeFavorite(widget);
                            }
                          });
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          size: 48,
                        ),
                        onPressed: () {
                          /// Hier muss ein noch Event Vorschau Objekt erstellt werden
                          /// dass aus einer in dieser Klasse gespeicherten Event
                          /// Instance, so dass
                          Provider.of<BodyProvider>(context, listen: false)
                              .setBody(Container());
                          Provider.of<AppBarTitleProvider>(context,
                                  listen: false)
                              .setTitle('Übersicht');
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
