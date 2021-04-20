import 'dart:collection';
import 'dart:developer';

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
  static final int pageSize = 25;
  static Map<String, int> loadedPages = Map<String, int>();

  // TODO: Add loadled Months

  // initstate
  // TODO: Struktur umbauen, getter und load Provider tapisch von einander trennen
  // TODO: Page management einbauen
  EventProvider() {
    // loaded = HashMap<int, Veranstaltung>();

    // _loadEvents().then((events) {
    //   for (Veranstaltung event in events) loaded[event.id] = event;
    // });
  }
  //   notifyListeners();

  List<Veranstaltung> getLoadedEvents() {
    return loaded.values.toList();
  }

  List<Veranstaltung> getLikedEventsOfDay(DateTime day) {
    List<Veranstaltung> events = getLoadedEventsOfDay(day);
    for (int index = 0; index < events.length; index++) {
      Veranstaltung event = events[index];
      if(!favorites.contains(event.id))
        events.removeAt(index--);
    }
    return events;
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

  List<Veranstaltung> removeEventsOutsideMonth(
      DateTime month, List<Veranstaltung> events) {
    int year = month.year;

    DateTime start = DateTime.utc(year, month.month, 1);
    DateTime end =
        DateTime.utc(year, month.month + 1, 1); //0); wegen 00:00 Uhr evtl.

    for (int index = 0; index < events.length; index++) {
      Veranstaltung event = events[index];
      if (event.beginnTs.isBefore(start) || end.isBefore(event.beginnTs))
        events.remove(event);}
    return events;
  }

  // List<Veranstaltung> get selectedDayEvents => _getLoadedEventsOfDay(_focusedDay);

  List<Veranstaltung> getLoadedEventsOfDay(DateTime day) {
    DateTime start = DateTime.utc(day.year, day.month, day.day);
    DateTime end = DateTime.utc(day.year, day.month, day.day + 1);

    List<Veranstaltung> eventsOfMonth = [];

    for (DateTime date in dated.keys)
      if (start.isBefore(date) && date.isBefore(end))
        for (int eventId in dated[date]) eventsOfMonth.add(loaded[eventId]);

    return eventsOfMonth;
  }

  Future<List<Veranstaltung>> loadEventsOfMonth(DateTime month) async {
    int userId = 11; // TODO: Vom UserProvider holen

    //erst mal alle events laden bis eins aus dem entsprechenden Monat drinne ist
    //dann weiter schauen bis eins nimmer im Monat ist ODER es keine mehr gibt.
    //DateTime until, bool approved, int limit, int page, int userId}) async {

    List<Veranstaltung> returnList = [];

    bool nextPage = true;
    String pageTitle = "attemptGetAllVeranstaltungen";
    // TODO: evtl muss die erste Page auch 1 sein
    for (int page = loadedPages[pageTitle] ?? 1; nextPage; page++) {
      DateTime end = DateTime.utc(
          month.year, month.month + 1, 0); // TODO: Evtl 1. Tag wegen 00:00 Uhr
      var response = await attemptGetAllVeranstaltungen(
          end.toString(),
          "1", // TODO: ungefähr so ausehen lassen (approved ? "1" : "0"), gübt aktuell so nur zugelssene Events zurpck
          pageSize.toString(),
          page.toString(),
          userId.toString());
      if (response.statusCode == 200) {
        var parsedJson = json.decode(response.body);

        final List<dynamic> list =
            await parsedJson.map((item) => getEventFromJson(item)).toList();

        final List<Veranstaltung> responseList =
            List<Veranstaltung>.from(list).toList();
        removeEventsOutsideMonth(
            month, responseList); // TODO: Ich hoff mal auf C-b-R

        if ((responseList.length <= 0 && returnList.length > 0) ||
            page >
                20) // TODO: || page > ..., ändxern, ist aktuell da falls es gar keine events in dem monat gibt, würde es unendlich weiter gegen
          nextPage = false;
        else
          returnList.addAll(responseList);

        loadedPages[pageTitle] = page; // Page als geladen vermerken.
      } else {
        log("Fehler beim laden von " +
            pageTitle +
            "auf Seite: " +
            page.toString());
        nextPage = false;
      }
    }
    // notifyListeners(); // TODO: Sicherstellen dass das eine gute Idee ist...
  }

  List<Veranstaltung> getFavoriteEvents(int page) {
    return favorites.map((entry) => loaded[entry]).toList();
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
    // if (upComing.isNotEmpty) {
    return upComing.map((entry) => loaded[entry]).toList();
    // } else {
    //   return loadUpComingEvents();
    // }
  }

  List<Veranstaltung> loadUpComingEvents() {
    // UpComingEvents aus Datenbank in upComing laden und zurückgeben
  }

  List<Veranstaltung> getEventsContaining(String content, int page) {
    // Events die in text form den conetnt enthalten laden und zurückgeben
  }

  List<Veranstaltung> getLoadedEventsAt(DateTime day, int page) {
    if (dated[day] != null)
      return dated[day].map((entry) => loaded[entry]).toList();
    return null; // Alle Events an dem Tag aus laden und zurückgeben => loadEventsAt...
  }

  List<Veranstaltung> getEventsUntil(DateTime day, int page) {
    // Alle Events bis zu zum day stattfinden aus laden und zurückgeben
  }

  Future<Veranstaltung> getEventById(int id) async {
    if (isEventLoaded(id)) return loaded[id];
    var response = await attemptGetVeranstaltungByID(id);
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);

      Veranstaltung event = getEventFromJson(parsedJson);

      return event;
    }
    return null;
  }

  void loadEvent(Veranstaltung event) {
    loaded[event.id] = event;
    if (dated[event.beginnTs] != null)
      dated[event.beginnTs].add(event.id);
    else
      dated[event.beginnTs] = [event.id];
  }

  bool isEventLoaded(int id) {
    return loaded.containsKey(id);
  }

  Veranstaltung getEventFromJson(Map<String, dynamic> json) {
    int id = json['id'];

    if (isEventLoaded(id)) return loaded[id];

    String titel = json['titel'];
    String description = json['beschreibung'];
    String contact = json['kontakt'];
    DateTime start = DateTime.parse(json['beginn_ts']);
    DateTime end = DateTime.parse(json['ende_ts']);
    String place = json['ortBeschreibung'];

    bool approved = json['istGenehmigt'] == '1';

    // TODO: if(!approved && user hat keine Rechte dazu) return;

    // TODO: if(ortBeschreibung < selbstDefinierter Radius entfernt) dann:
    if (!upComing.contains(
        id)) // idk. ob das überhaupt sein kann, aber sicher ist sicher
      upComing
          .add(id); // TODO: So kann es noch passieren dass durch zwischen laden
    // mit anderen attemptBefehlen die reihenfolge nicht mehr stimmt...

    DateTime created = DateTime.parse(json['erstellt_ts']);

    if (json['favorit'] == '1') favorites.add(id);

    // TODO: latitude, longitude noch anpassen...
    Veranstaltung event = Veranstaltung.load(id, titel, description, contact,
        place, start, end, created, 0, 0, approved);

    loadEvent(event);

    return event;
  }
}
