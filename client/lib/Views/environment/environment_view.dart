import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_list.dart';
import 'package:flutter/material.dart';

//Aktuell noch ne dummy Klasse

class EnvironmentView extends StatelessWidget {
  const EnvironmentView();

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[
      PreviewListHeading('Bald'),
      EventPreviewBox(1, 'Erste Beispiel Veranstaltung',
          'Sehr kurze Beschreibung', 'Beginnt in 57 Minuten', false),
      EventPreviewBox(
          1,
          'Zweite viel tollere Beispiel Veranstaltung',
          'Mit einer viel längeren Beschreibung die natürlich aussagt, dass es sich um eine seriöse Veranstaltung handelt. Und mit zu viel Text xD',
          'Beginnt in 3 Stunden',
          false),
      PreviewListDots(EventPreviewList(<Widget>[]), 'Bald'),
      PreviewListHeading('In der Nähe'),
      EventPreviewBox(1, 'Erste Beispiel Veranstaltung',
          'Sehr kurze Beschreibung', 'Am 15.04 nur 3km entfernt', false),
      EventPreviewBox(
          1,
          'Zweite viel tollere Beispiel Veranstaltung',
          'Mit einer viel längeren Beschreibung die natürlich aussagt, dass es sich um eine seriöse Veranstaltung handelt. Und mit zu viel Text xD',
          'Am 20.04 nur 7km entfernt',
          false),
      PreviewListDots(EventPreviewList(<Widget>[]), 'In der Nähe')
    ];

    // widgetList.add();

    EventPreviewList list = EventPreviewList(widgetList);
    // widgetList.add();

    //list.addEventPreview(EventPreviewBox(1, 'Zusatz Veranstaaltung', 'Beschriebung', 'Zusatz Infos'));
    // list.addExtenionListDots(EventPreviewList());

    return Container(
      child: list,
    );
  }
}
