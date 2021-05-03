import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_list.dart';
import 'package:aktiv_app_flutter/Views/veranstaltung/detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:aktiv_app_flutter/Models/role_permissions.dart';

import '../Home.dart';

enum AdditiveFormat { HOLE_DATETIME, TIME_TILL_START, DISTANCE }

// ignore: must_be_immutable
class EventPreviewBox extends StatefulWidget {
  int id;
  String titel;
  String description;
  String additive;
  AdditiveFormat additiveFormat;
  bool liked;

  // TODO: Überprüfe ob Box höhe wirklich einheitlich ist

  // TODO: Ob die veranstaltung geliked ist, sollte nicht übergeben werden,
  // sondern aus einer singleton Klasse durch die id entnommen werdem
  EventPreviewBox(this.id, this.titel, this.description, this.additive);

  EventPreviewBox.load(Veranstaltung event, this.additiveFormat) {
    this.id = event.id;
    this.titel = event.titel;
    this.description = event.beschreibung;
    this.additive = _FormatAdditive(event.beginnTs);
  }

  String _FormatAdditive(DateTime dateTime) {
    switch (additiveFormat) {
      case AdditiveFormat.HOLE_DATETIME:
        return DateFormat('dd.MM.yyyy – kk:mm').format(dateTime) + " Uhr";
      case AdditiveFormat.TIME_TILL_START:
        return "Beginnt in " +
            (dateTime.difference(DateTime.now()).inDays > 1
                ? dateTime.difference(DateTime.now()).inDays.toString() +
                    " Tagen"
                : (dateTime.difference(DateTime.now()).inDays == 1
                    ? "einem Tag"
                    : ((dateTime.difference(DateTime.now()).inHours > 1)
                        ? (dateTime
                                .difference(DateTime.now())
                                .inHours
                                .toString() +
                            " Stunden")
                        : (dateTime
                                .difference(DateTime.now())
                                .inMinutes
                                .toString() +
                            " Minuten"))));
      case AdditiveFormat.DISTANCE:
        double distance = EventProvider.getDistanceToEvent(id);
        return distance.toString() + " km weit entfernt";
      default:
        return "null";
    }
  }

  @override
  _EventPreviewBoxState createState() => _EventPreviewBoxState();
}

class _EventPreviewBoxState extends State<EventPreviewBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (widget.liked == null)
      widget.liked = Provider.of<EventProvider>(context, listen: false)
          .isEventFavorite(widget.id);

    //  image = NetworkImage("https://app.lebensqualitaet-burgrieden.de/" +"");
    //  AssetImage("assets/images/lq_logo_klein.png");

    // CircleAvatar image = CircleAvatar(
    //                 // TODO: Bild der Preview Box muss noch dynamisch werden
    //                 backgroundImage: AssetImage("assets/images/lq_logo_klein.png"),
    //               );
    CircleAvatar image = Provider.of<EventProvider>(context, listen: false)
          .getPreviewImage(widget.id);

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                  child: image,
                ),
              ),
              Container(
                width: size.width * 0.44,
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
                    (UserProvider.getUserRole().allowedToFavEvents
                        ? IconButton(
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
                              });
                              Provider.of<EventProvider>(context, listen: false)
                                  .toggleEventsFavoriteState(context, widget.id);
                            })
                        : Container()),
                    IconButton(
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          size: 48,
                        ),
                        onPressed: () {
                          /// TODO: Verweise auf detail anischt der Veransanstaltung
                          Provider.of<BodyProvider>(context, listen: false)
                              .setBody(VeranstaltungDetailView(widget.id));
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
