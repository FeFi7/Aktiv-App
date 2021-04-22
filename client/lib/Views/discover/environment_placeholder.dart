import 'package:aktiv_app_flutter/Provider/event_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    List<EventPreviewBox> upComing =
        Provider.of<EventProvider>(context, listen: false)
            .getUpComingEvents()
            .map((event) => EventPreviewBox.load(event))
            .toList();
    List<EventPreviewBox> nearBy =
        Provider.of<EventProvider>(context, listen: false)
            .getUpComingEvents()
            .map((event) => EventPreviewBox.load(event))
            .toList(); // TODO: Noch auf In der Nähe änder!!!!!!

    List<Widget> widgetList = <Widget>[PreviewListHeading('Bald')];
    widgetList.addAll(upComing.sublist(0, upComing.length > 1 ? 2 : 0));
    widgetList.add(PreviewListDots(EventPreviewList(upComing), 'Bald'));

    widgetList.add(PreviewListHeading('In der Nähe'));
    widgetList.addAll(nearBy.sublist(0, nearBy.length > 1 ? 2 : 0));
    widgetList.add(PreviewListDots(EventPreviewList(nearBy), 'In der Nähe'));

    return EventPreviewList(widgetList);
  }
}
