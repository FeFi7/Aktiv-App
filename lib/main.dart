import 'package:flutter/material.dart';
import 'Views/Home.dart';

void main() {
  runApp(AktivApp());
}

class AktivApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Aktiv App Test'),
    );
  }
}
