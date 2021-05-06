import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/error_preview_box.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_list.dart';
import 'package:flutter/material.dart';
import 'package:aktiv_app_flutter/Models/role_permissions.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
class FavoritesView extends StatefulWidget {
  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

// Liste aller vom Nutzer favorisierten Veranstaltungen. Falls er nicht
// eingeloggt ist, wird ihm eine ErrorBox angezeigt
class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    if(UserProvider.getUserRole().allowedToFavEvents) {
      return EventPreviewList(EventListType.FAVORITES, AdditiveFormat.HOLE_DATETIME);
    } else {
      return ErrorPreviewBox(
                "Bitte loggen Sie sich ein, um Ihre favorisierten Veranstaltungen einsehen zu können.");
    }
  }
}
