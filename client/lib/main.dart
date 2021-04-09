import 'package:aktiv_app_flutter/Views/Home.dart';
import 'package:aktiv_app_flutter/Views/favorites/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/ClickerProvider.dart';
import 'Views/welcome_screen.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(AktivApp());
}

class AktivApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClickerProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => AppBarTitleProvider()),
        ChangeNotifierProvider(create: (_) => BodyProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}
