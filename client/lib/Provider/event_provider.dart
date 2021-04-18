import 'dart:collection';

import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class EventProvider extends ChangeNotifier {
  // List<Veranstaltung> events;

  // TODO: Event liste auch wieder entlernen.

  static final Map<int, Veranstaltung> loaded = Map<int, Veranstaltung>();

  // initstate

  EventProvider() {
    // loaded = HashMap<int, Veranstaltung>();
    List<Veranstaltung> events;
    _loadAllEvents().then((value) {
      for (Veranstaltung event in value) loaded[event.id] = event;
    });
  }
  //   notifyListeners();

  List<Veranstaltung> getLoadedEvents() {
    List<Veranstaltung> events = loaded.values.toList();
    return events;
  }

  Future<Veranstaltung> getEventById(int id) async {
    if (isEventLoaded(id)) return loaded[id];
    var response = await attemptGetVeranstaltungByID(id);
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);

      Veranstaltung event = getEventFromJson(parsedJson);

      loaded[event.id] = event;

      return event;
    }
    return null;
  }

  bool isEventLoaded(int id) {
    return loaded.containsKey(id);
  }

  // TODO: Soll nicht alle events laden und tuts aktuell auc nicht
  Future<List<Veranstaltung>> _loadAllEvents() async {
    var response = await attemptGetAllVeranstaltungen();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);

      final List<dynamic> list =
          await parsedJson.map((item) => getEventFromJson(item)).toList();

      return List<Veranstaltung>.from(list);
    }
    return null;
  }

  Veranstaltung getEventFromJson(Map<String, dynamic> json) {
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
    Veranstaltung event = Veranstaltung.load(id, titel, description, contact,
        place, start, end, created, 0, 0, approved);

    return event;
  }
}
