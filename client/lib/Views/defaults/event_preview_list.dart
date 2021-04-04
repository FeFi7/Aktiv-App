import 'package:aktiv_app_flutter/Views/Home.dart';

import 'color_palette.dart';
import 'event_preview_box.dart';
import 'package:flutter/material.dart';

class EventPreviewList extends StatefulWidget {
  final List<Widget> widgetList;

  EventPreviewList(this.widgetList);

  @override
  _EventPreviewListState createState() => _EventPreviewListState();

  void addEventPreview(EventPreviewBox previewBox) {
    widgetList.insert(0, previewBox);
  }

  void addListExtensionDots() {
    widgetList.insert(0, PreviewListDots());
  }
}

class _EventPreviewListState extends State<EventPreviewList> {
  _EventPreviewListState();

  void addEventPreview(EventPreviewBox previewBox) {
    setState(() {});
  }

  void addListExtensionDots() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: widget.widgetList.length,
          itemBuilder: (BuildContext context, int index) {
            return widget.widgetList[index];
          }),
    );
  }
}

class PreviewListDots extends StatefulWidget {
  @override
  _PreviewListDotsState createState() => _PreviewListDotsState();
}

class _PreviewListDotsState extends State<PreviewListDots> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: ColorPalette.congress_blue.rgb,
            size: 64,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomePage(); /* Hier muss sich noch was ausgedacht werdem
                  wie man auf eine weitere Liste verweist, die aber immer noch
                  im Untermenü Umgebung auftaucht & nicht ein ganz neues Widget ist */
                },
              ),
            );
          }),
    );
  }
}

class PreviewListHeading extends StatefulWidget {
  final String heading;
  final TextStyle style = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  PreviewListHeading(this.heading);

  @override
  _PreviewListHeadingState createState() => _PreviewListHeadingState();
}

class _PreviewListHeadingState extends State<PreviewListHeading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Text(widget.heading, style: widget.style)),
    );
  }
}
