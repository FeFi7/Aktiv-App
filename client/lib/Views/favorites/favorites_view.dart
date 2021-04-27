import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/error_preview_box.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:aktiv_app_flutter/Models/role_permissions.dart';

class FavoritesView extends StatefulWidget {



  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: UserProvider.getUserRole().allowedToFavEvents ? EventPreviewList(
            Provider.of<EventProvider>(context, listen: false)
                .getLoadedFavoriteEvents()
                .map((event) => EventPreviewBox.load(event))
                .toList(), () {
    }) : ErrorPreviewBox("Bitte loggen Sie sich ein, um Ihre favorisierten Veranstaltungen einsehen zu können. "));
  }
}
