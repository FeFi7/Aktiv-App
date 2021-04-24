import 'dart:async';

import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Provider/search_behavior_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: Evtl in _PlaceHolder Methode instazieiern auslagern, damit wiedr neu erstellt wird
// class EnvironmentPlaceholder extends StatelessWidget {

class EnvironmentPlaceholder extends StatefulWidget {
  @override
  _EnvironmentPlaceholderState createState() => _EnvironmentPlaceholderState();
}

class _EnvironmentPlaceholderState extends State<EnvironmentPlaceholder> {
// List<Veranstaltung> upComing = Consumer<EventProvider>(builder: (context, value, child) {
//            return value.getUpComingEvents().map((event) => EventPreviewBox.load(event));
//         } as List<Veranstaltung>;

  List<EventPreviewBox> upComing = [];
  List<EventPreviewBox> nearBy = [];

  Timer timer;

  @override
  Widget build(BuildContext context) {
    // List<Veranstaltung> upComing =
    // Consumer<EventProvider>(builder: (context, value, child) {
    //   return value.getUpComingEvents().map((e) => EventPreviewBox.load(e)).toList();
    //   nearBy = value.getEventsNearBy().map((e) => EventPreviewBox.load(e));
    // });
    //
    //
    // TODO: Event Provider aktualisieren

    upComing = Provider.of<EventProvider>(context, listen: false)
        .getLoadedUpComingEvents()
        .map((event) => EventPreviewBox(
            event.id,
            event.titel,
            event.beschreibung,
            "Noch " +
                (event.beginnTs.difference(DateTime.now()).inDays > 0
                    ? event.beginnTs
                            .difference(DateTime.now())
                            .inDays
                            .toString() +
                        " Tage"
                    : event.beginnTs
                            .difference(DateTime.now())
                            .inHours
                            .toString() +
                        " Stunden") +
                ""))
        .toList();

    ///TODO: Anpassen, dass auch tatsächlich die entfernung angezeigt wird
    nearBy = Provider.of<EventProvider>(context, listen: false)
        .getEventsNearBy()
        .map((event) => EventPreviewBox(event.id, event.titel,
            event.beschreibung, "i.d.k. km weit entfernt"))
        .toList();

    // Falls leer, wird einfach in 0,5s neu geladen
    if (upComing.length <= 0 || nearBy.length <= 0)
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          // Here you can write your code for open new view
        });
      });

    print(Provider.of<EventProvider>(context, listen: false)
        .getLoadedUpComingEvents()
        .length);

    List<Widget> widgetList = <Widget>[PreviewListHeading('Bald')];
    widgetList
        .addAll(upComing.sublist(0, upComing.length < 2 ? upComing.length : 2));
    widgetList.add(PreviewListDots(
        EventPreviewList(
            upComing,
            () => {
                  // Provider.of<EventProvider>(context, listen: false)
                  //     .loadUpComingEvents()
                }),
        'Bald'));

    widgetList.add(PreviewListHeading('In der Nähe'));
    widgetList.addAll(nearBy.sublist(0, nearBy.length < 2 ? nearBy.length : 2));
    widgetList.add(PreviewListDots(
        EventPreviewList(
            nearBy,
            () => {
                  // Provider.of<EventProvider>(context, listen: false)
                  //     .loadEventsNearBy()
                }),
        'In der Nähe'));

    return EventPreviewList(widgetList, () {});
  }
}
