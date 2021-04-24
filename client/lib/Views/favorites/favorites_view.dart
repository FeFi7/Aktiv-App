import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatefulWidget {
  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: EventPreviewList(
            Provider.of<EventProvider>(context, listen: false)
                .getFavoriteEvents()
                .map((event) => EventPreviewBox.load(event))
                .toList(), () {
    }));
  }
}
