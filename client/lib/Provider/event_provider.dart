import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class EventProvider extends ChangeNotifier {

  //   notifyListeners();


  Map<int, Veranstaltung> loaded;

  Future<Veranstaltung> getEventById(int id) {

  }

  Future<List<Veranstaltung>> getAllEvents() async {
    var jwt = await attemptGetAllVeranstaltungen();
    if (jwt.statusCode == 200) {
      var parsedJson = json.decode(jwt.body);

      final List<Veranstaltung> events =
          await parsedJson.map((item) => getEventFromJson(item)).toList();

      return events;
    }
  }

  Veranstaltung getEventFromJson(Map<String, dynamic> json)  {
    int id = json['id'];
    String titel = json['titel'];
    String description = json['beschreibung'];
    String contact = json['kontakt'];
    DateTime start = DateTime.parse(json['beginn_ts']);
    DateTime end = DateTime.parse(json['ende_ts']);
    String place = json['ortBeschreibung'];
    DateTime created = DateTime.parse(json['erstellt_ts']);
    bool approved = json['istGenehmigt'] == '1';

    // TODO: latitude, longitude noch anpassen...
    return Veranstaltung.load(id, titel, description, contact, place, start, end, created, 0, 0, approved);
  }
}
