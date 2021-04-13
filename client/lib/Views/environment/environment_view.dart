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

// widgetList.add();

      EventPreviewList list = EventPreviewList(<Widget>[]);

      return EventPreviewList(widgetList);
// widgetList.add();

// list.addEventPreview(EventPreviewBox(1, 'Zusatz Veranstaaltung', 'Beschriebung', 'Zusatz Infos'));
// list.addExtenionListDots(EventPreviewList());
//
//
    }

    /// TODO: Soll noch zu List<EventPreviewBox> geändert werden
    Future<List<Post>> _getALlPosts(String text) async {
      await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
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

    // margin: const EdgeInsets.all(10.0),
    // padding: const EdgeInsets.all(10.0),

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
      // header: Row(
      //   children: <Widget>[
      //     RaisedButton(
      //       child: Text("sort"),
      //       onPressed: () {
      //         _searchBarController.sortList((Post a, Post b) {
      //           return a.body.compareTo(b.body);
      //         });
      //       },
      //     ),
      //     RaisedButton(
      //       child: Text("Desort"),
      //       onPressed: () {
      //         _searchBarController.removeSort();
      //       },
      //     ),
      //     RaisedButton(
      //       child: Text("Replay"),
      //       onPressed: () {
      //         isReplay = !isReplay;
      //         _searchBarController.replayLastSearch();
      //       },
      //     ),
      //   ],
      // ),
      onCancelled: () {
        print("Cancelled triggered");
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      // mainAxisSpacing: 10,

      // crossAxisSpacing: 10,
      // crossAxisCount: 1,
      onItemFound: (Post post, int index) {
        // return Container(
        //   color: Colors.lightBlue,
        //   child: ListTile(
        //     title: Text(post.title),
        //     isThreeLine: true,
        //     subtitle: Text(post.body),
        //     onTap: () {
        //       Navigator.of(context).push(
        //           MaterialPageRoute(builder: (context) => Detail()));
        //     },
        //   ),
        // );

        /// TODO: Muss noch ge
        return SizedBox(
            // height: 10,
            child: EventPreviewBox(
                index, post.title, post.body, 'noch kein ', false));
      },
    ));
  }
}

// class Detail extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             Text("Detail"),
//           ],
//         ),
//       ),
//     );
//   }
// }
