import 'dart:math';

import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_list.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';

//Aktuell noch ne dummy Klasse

class Post {
  final String title;
  final String body;

  Post(this.title, this.body);
}

// class EnvironmentView extends StatelessWidget {
class EnvironmentView extends StatefulWidget {
  const EnvironmentView();

  @override
  _EnvironmentViewState createState() => _EnvironmentViewState();
}

final List<bool> isSelected = [true, false, false];

class _EnvironmentViewState extends State<EnvironmentView> {
  @override
  Widget build(BuildContext context) {
    final SearchBarController<Post> _searchBarController =
        SearchBarController();
    bool isReplay = false;

    Widget _getPlaceHolder() {
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

      return EventPreviewList(widgetList);
    }

    /// TODO: Soll noch zu List<EventPreviewBox> geändert werden
    Future<List<Post>> _getALlPosts(String text) async {
      // await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
      if (isReplay) return [Post("Replaying !", "Replaying body")];
      // if (text.length == 5) throw Error();
      // if (text.length == 6) return [];
      List<Post> posts = [];

      var random = new Random();
      for (int i = 0; i < 10; i++) {
        posts.add(
            Post("$text $i", "body random number : ${random.nextInt(100)}"));
      }
      return posts;
    }

    return Container(
        child: SearchBar<Post>(
      // searchBarPadding: EdgeInsets.symmetric(horizontal: 50),
      // headerPadding: EdgeInsets.all(50),
      searchBarPadding: EdgeInsets.only(left: 15, right: 15, top: 15),

      ///symmetric(horizontal: 10), ///EdgeInsets.all(15),
      listPadding: EdgeInsets.symmetric(horizontal: 10),
      textStyle: TextStyle(
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      icon: Icon(Icons.search_rounded, size: 35),
      onSearch: _getALlPosts,
      searchBarStyle: SearchBarStyle(
          backgroundColor: ColorPalette.malibu.rgb,
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
          padding: EdgeInsets.all(10.0)),
      searchBarController: _searchBarController,
      placeHolder: _getPlaceHolder(),
      cancellationWidget: Container(
          // color: ColorPalette.malibu.rgb,
          padding: const EdgeInsets.all(17.0),
          height: 70,
          decoration: BoxDecoration(
              color: ColorPalette.french_pass.rgb,
              borderRadius: BorderRadius.all(Radius.circular(36.0))),
          child: Center(child: Text("Zurück"))),
      emptyWidget: Text("empty"),
      indexedScaledTileBuilder: (int index) => ScaledTile.count(1, 0.475),
      header: Center(
        child: Container(
          margin: const EdgeInsets.all(2.0),
          child: ToggleButtons(
            children: [
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Allgemein')),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Datum')),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Zeitraum')),
            ],
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    isSelected[buttonIndex] = true;
                  } else {
                    isSelected[buttonIndex] = false;
                  }
                }
              });
            },
            borderRadius: BorderRadius.circular(30),
            borderWidth: 1,
            selectedColor: ColorPalette.white.rgb,
            fillColor: ColorPalette.endeavour.rgb,
            disabledBorderColor: ColorPalette.french_pass.rgb,
          ),
        ),
      ),
      onCancelled: () {
        print("Cancelled triggered");
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      // mainAxisSpacing: 10,

      // crossAxisSpacing: 10,
      // crossAxisCount: 1,
      onItemFound: (Post post, int index) {
        return EventPreviewBox(
            index, post.title, post.body, 'noch kein ', false);
      },
    ));
  }
}
