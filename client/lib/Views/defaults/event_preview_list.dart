import 'dart:developer';

import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Views/Home.dart';
import 'package:provider/provider.dart';

import 'color_palette.dart';
import 'event_preview_box.dart';
import 'package:flutter/material.dart';

class EventPreviewList extends StatefulWidget {
  final List<Widget> widgetList;
  final VoidCallback bottomReached;
  EventPreviewList(this.widgetList, this.bottomReached);

  @override
  _EventPreviewListState createState() => _EventPreviewListState();

  void addEventPreview(EventPreviewBox previewBox) {
    widgetList.insert(0, previewBox);
  }

  void addListExtensionDots() {
    // hier muss noch dynamisch fest gelegt werden wohin die leiten sollen
    widgetList.insert(
        0,
        PreviewListDots(
            EventPreviewList(<Widget>[
              EventPreviewBox(0, 'titel', 'description', 'additive')
            ]),
            ''));
  }

  void clear() {
    widgetList.clear();
  }
}

class _EventPreviewListState extends State<EventPreviewList> {
  _EventPreviewListState();

  // void addEventPreview(EventPreviewBox previewBox) {
  //   setState(() {
  //   });
  // }

  // void addListExtensionDots(EventPreviewList list) {
  //   setState(() {});
  // }

  ScrollController _controller;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        // TODO: Möglichkeit coden, damit Event dynamisch hinzugefügt werden...
        log("reach the bottom");

        widget.bottomReached.call();
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          // shrinkWrap: true,
          controller: _controller,
          padding: const EdgeInsets.all(8),
          itemCount: widget.widgetList.length,
          itemBuilder: (BuildContext context, int index) {
            return widget.widgetList[index];
          }),
    );
  }
}

class PreviewListDots extends StatefulWidget {
  final Widget extendedList;
  final String extendedListTitle;

  PreviewListDots(this.extendedList, this.extendedListTitle);

  @override
  _PreviewListDotsState createState() => _PreviewListDotsState();
}

class _PreviewListDotsState extends State<PreviewListDots> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: ColorPalette.congress_blue.rgb,
            size: 64,
          ),
          onPressed: () {
            Provider.of<BodyProvider>(context, listen: false)
                .setBody(widget.extendedList);
            Provider.of<AppBarTitleProvider>(context, listen: false)
                .setTitle(widget.extendedListTitle);
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
