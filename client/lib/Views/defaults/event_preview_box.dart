import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/favorites/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Home.dart';

// ignore: must_be_immutable
class EventPreviewBox extends StatefulWidget {
  final int id;
  final String titel;
  final String description;
  final String additive;
  bool liked;


  // TODO: Überprüfe ob Box höhe wirklich einheitlich ist 

  // TODO: Ob die veranstaltung geliked ist, sollte nicht übergeben werden,
  // sondern aus einer singleton Klasse durch die id entnommen werdem 
  EventPreviewBox(
      this.id, this.titel, this.description, this.additive, this.liked);

  @override
  _EventPreviewBoxState createState() => _EventPreviewBoxState();
}

class _EventPreviewBoxState extends State<EventPreviewBox> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(10.0)), 
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
                    // TODO: Bild der Preview Box muss noch dynamisch werden
                    backgroundImage: AssetImage(
                        "assets/images/lq_logo_klein.png"),
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
                            .ellipsis, //Macht ... bei zu langem Texts
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
                          /// TODO: Verweise auf detail anischt der Veransanstaltung
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
