import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/error_preview_box.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:aktiv_app_flutter/Models/role_permissions.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';

class ApproveView extends StatefulWidget {
  @override
  _ApproveViewState createState() => _ApproveViewState();
}

class _ApproveViewState extends State<ApproveView> {
  @override
  Widget build(BuildContext context) {
    // TODO: Richtige allowed permission
    if (UserProvider.getUserRole().allowedToFavEvents) {
      return EventPreviewList(
          EventListType.APPROVE, AdditiveFormat.HOLE_DATETIME);
    } else {
      return ErrorPreviewBox(
          ".", "Keine berechtigung");
    }
  }
}
