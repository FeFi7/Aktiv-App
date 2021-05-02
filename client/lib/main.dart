import 'package:aktiv_app_flutter/Provider/search_behavior_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/body_provider.dart';
import 'Provider/event_provider.dart';
import 'Views/welcome_screen.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };
  runApp(AktivApp());
}

class AktivApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppBarTitleProvider()),
        ChangeNotifierProvider(create: (_) => SearchBehaviorProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => BodyProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('de', ''), // Deutsch, no country code
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'wir:hier',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}
