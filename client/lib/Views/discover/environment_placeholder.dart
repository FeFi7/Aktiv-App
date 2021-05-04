import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Views/Home.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnvironmentPlaceholder extends StatefulWidget {
  @override
  _EnvironmentPlaceholderState createState() => _EnvironmentPlaceholderState();
}

class _EnvironmentPlaceholderState extends State<EnvironmentPlaceholder> {
  final TextStyle headingStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: ColorPalette.endeavour.rgb);

  Future<List<List<Veranstaltung>>> loadEventsFromProvider() async {
    List<List<Veranstaltung>> lists = [];
    lists.add(await Provider.of<EventProvider>(context, listen: false)
        .loadEventListOfType(EventListType.UP_COMING));
    lists.add(await Provider.of<EventProvider>(context, listen: false)
        .loadEventListOfType(EventListType.NEAR_BY));
    return lists;
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<Veranstaltung>>>(
      future: loadEventsFromProvider(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data;

        List<Widget> environment = [];

        environment.add(Container(
            padding: const EdgeInsets.all(10.0),
            child: Text("Bald", style: headingStyle)));

        for (Veranstaltung event in getListPreview(events[0]))
          environment
              .add(EventPreviewBox.load(event, AdditiveFormat.TIME_TILL_START));

        environment.add(PreviewDots(
            EventPreviewList(
                EventListType.UP_COMING, AdditiveFormat.TIME_TILL_START),
            "Bald"));

        environment.add(Container(
            padding: const EdgeInsets.all(10.0),
            child: Text("In der Nähe", style: headingStyle)));

        for (Veranstaltung event in getListPreview(events[1]))
          environment.add(EventPreviewBox.load(event, AdditiveFormat.DISTANCE));

        environment.add(PreviewDots(
            EventPreviewList(EventListType.NEAR_BY, AdditiveFormat.DISTANCE),
            "In der Nähe"));

        return Container(
            child: RawScrollbar(
          isAlwaysShown: true,
          thumbColor: ColorPalette.torea_bay.rgb,
          radius: Radius.circular(10),
          thickness: 4,
          controller: _scrollController,
          child: ListView.builder(
              controller: _scrollController,
              itemCount: environment.length,
              itemBuilder: (BuildContext context, int index) {
                return environment[index];
              }),
        ));
      },
    );
  }

  List<Veranstaltung> getListPreview(List<Veranstaltung> events) {
    List<Veranstaltung> listPreview = [];
    for (int i = 0; (i < 2 && i < events.length); i++)
      listPreview.add(events[i]);
    return listPreview;
  }
}

class PreviewDots extends StatefulWidget {
  final EventPreviewList list;
  final String appBarTitle;

  PreviewDots(this.list, this.appBarTitle);

  @override
  _PreviewDotsState createState() => _PreviewDotsState();
}

class _PreviewDotsState extends State<PreviewDots> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 45),
      child: IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: ColorPalette.congress_blue.rgb,
            size: 64,
          ),
          onPressed: () {
            Provider.of<BodyProvider>(context, listen: false)
                .setBody(widget.list);
            Provider.of<AppBarTitleProvider>(context, listen: false)
                .setTitle(widget.appBarTitle);
          }),
    );
  }
}
