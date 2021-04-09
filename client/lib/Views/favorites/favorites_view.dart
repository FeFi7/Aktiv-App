import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_list.dart';
import 'package:aktiv_app_flutter/Views/favorites/favorites_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {

  const FavoritesView();

  @override
  Widget build(BuildContext context) {
    return Container(child:Consumer<FavoritesProvider>(builder: (context, value, child) {
            return EventPreviewList(value.boxes);
          }
        ));
  }
}