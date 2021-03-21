import 'package:aktiv_app_flutter/Provider/ClickerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Clicker.dart';

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
    Clicker(),
    Text(
      'Mein Kalender',
      style: optionStyle,
    ),
    Text(
      'Ticket Marketplace',
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
          title: Text(widget.title),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Kalender',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_num),
              label: 'Tickets',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
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
