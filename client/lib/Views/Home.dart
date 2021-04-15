import 'dart:collection';
import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Views/calendar/calendar_view.dart';
import 'package:aktiv_app_flutter/Views/environment/environment_view.dart';
import 'package:aktiv_app_flutter/Views/favorites/favorites_view.dart';
import 'package:aktiv_app_flutter/Views/veranstaltung/anlegen.dart';
import 'package:aktiv_app_flutter/Views/profile/profile_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'defaults/color_palette.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex =
      0; // Index des ausgewählten Item's der BottomNavigationBar

  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    EnvironmentView(),
    CalendarView(),
    VeranstaltungAnlegenView(),
    FavoritesView(),
    ProfileScreen(),
  ];

  static const List<String> _widgetTitles = <String>[
    'Entdecken',
    'Kalender',
    'Erstellen',
    'Favoriten',
    'Profil',
  ];

  static Widget body = Consumer<BodyProvider>(builder: (context, value, child) {
    return value.getBody();
  }); // Kann/Sollte noch geändert werden

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      Provider.of<AppBarTitleProvider>(context, listen: false)
          .resetTitle(_widgetTitles[index]);

      Provider.of<BodyProvider>(context, listen: false)
          .resetBody(_widgetOptions.elementAt(index));
    });
  }

  @override
  void initState() {
    super.initState();

    /// So kann man den Titel in der App Bar anpassen
    Provider.of<AppBarTitleProvider>(context, listen: false)
        .initializeTitle(_widgetTitles[0]);

    Provider.of<BodyProvider>(context, listen: false)
        .initializeBody(_widgetOptions.elementAt(0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.endeavour.rgb,
        title: Consumer<AppBarTitleProvider>(builder: (context, value, child) {
          return Text(value.title, style: TextStyle(fontSize: 25));
        }),
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 48),
          onPressed: () {
            Provider.of<BodyProvider>(context, listen: false)
                .previousBody(context);
            Provider.of<AppBarTitleProvider>(context, listen: false)
                .previousTitle(context);
          },
        ),
      ),
      body: Center(
        child: body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Suchen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Erstellen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_rounded),
            label: 'Favoriten',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorPalette.endeavour.rgb,
        unselectedItemColor: ColorPalette.french_pass.rgb,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AppBarTitleProvider extends ChangeNotifier {
  String _title = 'AktivApp';

  ListQueue previous = ListQueue<String>();

  String get title => this._title;

  void setTitle(String title) {
    previous.add(this._title);
    this._title = title;

    notifyListeners();
  }

  void resetTitle(String title) {
    previous.clear();
    this._title = title;

    notifyListeners();
  }

  void previousTitle(BuildContext context) {
    if (previous.length > 0) {
      this._title = previous.removeLast();
    }

    notifyListeners();
  }

  void initializeTitle(String title) {
    this._title = title;
  }
}

