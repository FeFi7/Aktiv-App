import 'dart:collection';

import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class EventProvider extends ChangeNotifier {
  // List<Veranstaltung> events;

  // TODO: Event liste auch wieder entlernen.

  static final Map<int, Veranstaltung> loaded = Map<int, Veranstaltung>();
  static Map<DateTime, List<int>> dated = Map<DateTime, List<int>>();
  static List<int> nearby = [];
  static List<int> upComing = [];
  static List<int> favorites = [];

  // initstate

  EventProvider() {
    // loaded = HashMap<int, Veranstaltung>();

    _loadEvents().then((value) {
      for (Veranstaltung event in value) loaded[event.id] = event;
    });
  }
  //   notifyListeners();

  List<Veranstaltung> getLoadedEvents() {
    return loaded.values.toList();
  }

  List<Veranstaltung> getLikedEventsOfMonth(DateTime month) {
    // return getLoadedEvents();
  }

  List<Veranstaltung> getLoadedEventsOfMonth(DateTime month, int userId) {
    int year = month.year;

    DateTime start = DateTime.utc(year, month.month, 1);
    DateTime end = DateTime.utc(year, month.month + 1, 0);

    List<Veranstaltung> eventsOfMonth = [];

    for (DateTime date in dated.keys)
      if (start.isBefore(date) && date.isBefore(end))
        for (int eventId in dated[date]) eventsOfMonth.add(loaded[eventId]);

    return eventsOfMonth;
  }

  List<Veranstaltung> getFavoriteEvents(int userId, int page) {
    if (favorites.isNotEmpty) {
      return nearby.map((entry) => loaded[entry]).toList();
    } else {
      return loadFavorites();
    }
  }

  List<Veranstaltung> loadFavorites() {
    // EventsNearBy aus Datenbank in nearby laden
  }

  List<Veranstaltung> getEventsNearBy(
      double longitude, double latitude, int page) {
    if (nearby.isNotEmpty) {
      return nearby.map((entry) => loaded[entry]).toList();
    } else {
      return loadEventsNearBy();
    }
  }

  List<Veranstaltung> loadEventsNearBy() {
    // EventsNearBy aus Datenbank in nearby laden
  }

  List<Veranstaltung> getUpComingEvents(
      double longitude, double latitude, int page) {
    if (upComing.isNotEmpty) {
      return upComing.map((entry) => loaded[entry]).toList();
    } else {
      return loadUpComingEvents();
    }
  }

  List<Veranstaltung> loadUpComingEvents() {
    // UpComingEvents aus Datenbank in upComing laden und zurückgeben
  }

  List<Veranstaltung> getEventsContaining(String content, int page) {
    // Events die in text form den conetnt enthalten aus Datenbank laden und zurückgeben
  }

  List<Veranstaltung> getLoadedEventsAt(DateTime day, int page) {
    if (dated[day] != null)
      return dated[day].map((entry) => loaded[entry]).toList();
    return null;// Alle Events an dem Tag aus der Datenbank laden und zurückgeben => loadEventsAt...
    
  }

  List<Veranstaltung> getEventsUntil(DateTime day, int page) {
    // Alle Events bis zu zum day stattfinden aus der Datenbank laden und zurückgeben
  }

  Future<Veranstaltung> getEventById(int id) async {
    if (isEventLoaded(id)) return loaded[id];
    var response = await attemptGetVeranstaltungByID(id);
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);

      Veranstaltung event = getEventFromJson(parsedJson);

      loadEvent(event);

      return event;
    }
    return null;
  }

  void loadEvent(Veranstaltung event) {
    loaded[event.id] = event;
    if (dated[event.beginnTs] != null) {
      dated[event.beginnTs].add(event.id);
    }
  }

  bool isEventLoaded(int id) {
    return loaded.containsKey(id);
  }

  Future<List<Veranstaltung>> _loadEvents(
      {DateTime until, bool approved, int limit, int page, int userId}) async {
    var response = await attemptGetAllVeranstaltungen(
        until.toString(),
        "0", // TODO: ungefähr so ausehen lassen (approved ? "1" : "0")
        limit.toString(),
        page.toString(),
        userId.toString());
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
