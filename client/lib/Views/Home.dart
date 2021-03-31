import 'package:aktiv_app_flutter/Provider/ClickerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Clicker.dart';
import 'color_palette.dart';
import 'event_preview_box.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex =
      0; // Index des ausgewählten Items der BottomNavigationBar

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    EventPreviewBox(),
    Clicker(),
    Text(
      'Erstellen',
      style: optionStyle,
    ),
    Text(
      'Favoriten',
      style: optionStyle,
    ),
    Text(
      'Profil',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: Text(widget.title, style: TextStyle(fontSize: 25)),
          title: Text("AktivApp", style: TextStyle(fontSize: 25)),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 40,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_rounded),
              label: 'Umgebung',
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
              label: 'Vermerkt',
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
        floatingActionButton: FloatingActionButton(
          onPressed: Provider.of<ClickerProvider>(context, listen: false)
              .incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}
