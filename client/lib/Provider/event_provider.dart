import 'dart:collection';
import 'dart:developer';

import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/search_behavior_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/error_preview_box.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart';
import 'package:provider/provider.dart';

class EventProvider extends ChangeNotifier {
  // List<Veranstaltung> events;

  // TODO: Event liste auch wieder entlernen.

  static final Map<int, Veranstaltung> loaded = Map<int, Veranstaltung>();
  static Map<DateTime, List<int>> dated = Map<DateTime, List<int>>();
  static List<int> nearby = [];
  static List<int> upComing = [];
  static List<int> favorites = [];
  static List<int> approved = [];
  static final int pageSize = 25;
  static Map<String, int> loadedPages = Map<String, int>();

  // TODO: Add loadled Months
  // TODO: Clear Methode hinzufügen

  // EventProvider() {
  // loaded = HashMap<int, Veranstaltung>();

  // _loadEvents().then((events) {
  //   for (Veranstaltung event in events) loaded[event.id] = event;
  // });
  // }
  //   notifyListeners();

  List<Veranstaltung> getLoadedEvents() {
    return loaded.values.toList();
  }

  List<Veranstaltung> getLoadedAndLikedEventsOfDay(DateTime day) {
    List<Veranstaltung> events = getLoadedEventsOfDay(day);
    for (int index = 0; index < events.length; index++) {
      Veranstaltung event = events[index];
      if (!favorites.contains(event.id)) events.removeAt(index--);
    }
    return events;
  }

  List<Veranstaltung> getLoadedEventsOfMonth(DateTime month) {
    int userId = 11;

    int year = month.year;

    DateTime start = DateTime.utc(year, month.month, 1);
    DateTime end = DateTime.utc(year, month.month + 1, 0);

    List<Veranstaltung> eventsOfMonth = [];

    for (DateTime date in dated.keys)
      if (start.isBefore(date) && date.isBefore(end))
        for (int eventId in dated[date]) eventsOfMonth.add(loaded[eventId]);

    return eventsOfMonth;
  }

  Future<List<Widget>> loadEventsAsBoxContaining(String text) async {
    //
    // await Future.delayed(Duration(seconds: text.length > 0 ? 10 : 1));
    await Future.delayed(Duration(seconds: 1));
    // if (isReplay) return [Post("Replaying !", "Replaying body")];
    // if (text.length == 5) throw Error();
    // if (text.length == 6) return [];
    // List<EventPreviewBox> events = [];
    //
    //
    List<Widget> eventPreviews = [];

    // So kann bei der suche differenziert werden, wie man
    switch (SearchBehaviorProvider.style) {
      case SearchStyle.FULLTEXT:
        // TODO: Volltext Suche aus der Datenbank laden un zurück geben

        for (Veranstaltung event in getLoadedEvents()) {
          if (event.titel.contains(text) ||
              event.beschreibung.contains(text) ||
              event.ortBeschr.contains(text))
            eventPreviews.add(EventPreviewBox.load(event));
        }

        // if (eventPreviews.length == 0)
        // eventPreviews.add(ErrorPreviewBox(
        //     "Es konnten keine Veranstaltungen mit dem Inhalt \"" +
        //         text +
        //         "\" im Titel, im Names des Veranstalters, der Beschriebung, oder in den Tags gefunden werden. Versuche sie bitte mit einem anderen Schlüsselwort erneut."));

        return eventPreviews;
      case SearchStyle.DATE:
        // TODO: Suche nach allen Events an dem Datum aus der Datenbank laden un zurück geben

        if (DateTime.tryParse(text) != null) {
          DateTime date = DateTime.parse(text);
        } else {
          eventPreviews.add(ErrorPreviewBox("Bei \"" +
              text +
              " handelt es sich um kein gültiges Datum. Bitte Datum im format Tag.Monat.Jahr angeben."));
          return eventPreviews;
        }

        if (eventPreviews.length == 0)
          eventPreviews.add(ErrorPreviewBox(
              "Es konnten keine Veranstaltungen für den " +
                  text +
                  " gefunden werden."));

        return eventPreviews;
      case SearchStyle.PERIOD:
        // TODO: Volltext Scuhe aus der Datenbank laden un zurück geben

        //TODO:  WIDER ENTFERNEN
        eventPreviews.addAll(getLoadedEvents()
            .map((event) => EventPreviewBox.load(event))
            .toList());

        return eventPreviews;
      default:
        return eventPreviews;
    }

    // return events;
  }

  bool isValidDate(String possiblyDate) {}

  List<Veranstaltung> removeEventsOutsideMonth(
      DateTime month, List<Veranstaltung> events) {
    int year = month.year;

    DateTime start = DateTime.utc(year, month.month, 1);
    DateTime end =
        DateTime.utc(year, month.month + 1, 1); //0); wegen 00:00 Uhr evtl.

    for (int index = 0; index < events.length; index++) {
      Veranstaltung event = events[index];
      if (event.beginnTs.isBefore(start) || end.isBefore(event.beginnTs))
        events.remove(event);
    }
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

  List<Veranstaltung> getFavoriteEvents() {
    return favorites.map((entry) => loaded[entry]).toList();
  }

  List<Veranstaltung> loadFavorites() {
    //
  }

  List<Veranstaltung> getEventsNearBy() {
    // TODO: Noch ändern, muss aber erstmal attemt methode geben
    // return nearby.map((entry) => loaded[entry]).toList();
    return getUpComingEvents();
  }

  void loadEventsNearBy() async {
    // EventsNearBy aus Datenbank in nearby laden
    //
    notifyListeners();
  }

  List<Veranstaltung> getUpComingEvents() {
    // if (upComing.isNotEmpty) {
    // 
    return upComing.map((id) => loaded[id]).toList();
    // } else {
    //   return loadUpComingEvents();
    // }
  }

  void loadUpComingEvents() {
    // UpComingEvents aus Datenbank in upComing laden und zurückgeben
    //
    notifyListeners();
  }

  // List<Veranstaltung> getEventsContaining(String content, int page) {
  //   // Events die in text form den conetnt enthalten laden und zurückgeben
  // }

  List<Veranstaltung> getLoadedEventsAt(DateTime day, int page) {
    if (dated[day] != null)
      return dated[day].map((id) => loaded[id]).toList();
    return null; // Alle Events an dem Tag aus laden und zurückgeben => loadEventsAt...
  }

  // List<Veranstaltung> getEventsUntil(DateTime day, int page) {
  //   // Alle Events bis zu zum day stattfinden aus laden und zurückgeben
  // }

  Veranstaltung getLoadedEventById(int id) {
    if (isEventLoaded(id)) return loaded[id];

    return null;
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

  Future<Veranstaltung> createEvent(String titel, String beschreibung,
      String email, String start, String ende, String adresse) async {
    int id = 0;
    Response resp = await attemptCreateVeranstaltung(titel, beschreibung, email,
        start, ende, adresse, '89231', '1', '1', '1');
    // print(resp.body);

    if (resp.statusCode == 200) {
      var parsedJson = json.decode(resp.body);
      id = parsedJson['insertId'];
      // Austauschen durch Event Provider sobald fertig
      //
      DateTime start_Ts = DateTime.parse(start);
      DateTime ende_Ts = DateTime.parse(ende);
      DateTime erstellt_Ts = DateTime.now();

      Veranstaltung veranstaltung = Veranstaltung.load(id, titel, beschreibung,
          email, adresse, start_Ts, ende_Ts, erstellt_Ts, 0, 0);

      loadEvent(veranstaltung);

      return veranstaltung;

      // toastmsg = "Neue Veranstaltung angelegt";
    } else {
      var parsedJson = json.decode(resp.body);
      var error = parsedJson['error'];
      log(error);
      // toastmsg = error;
    }
    return null;
  }

  void loadEvent(Veranstaltung event) {
    if (event == null) return;
    loaded[event.id] = event;
    if (dated[event.beginnTs] != null)
      dated[event.beginnTs].add(event.id);
    else
      dated[event.beginnTs] = [event.id];

    if (!upComing.contains(event.id)) 
      upComing.add(event.id);
    // }

    notifyListeners();
  }

  bool isEventLoaded(int id) {
    return loaded.containsKey(id);
  }

  bool isEventFavorite(int id) {
    return favorites.contains(id);
  }

  //TODO: Mit BackEnd verbinden, warte auf User Provider
  bool toggleEventFavorite(int id) {
    if (isEventFavorite(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    return isEventFavorite(id);
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

    bool isApproved = json['istGenehmigt'] == '1';
    // if (isApproved || UserProvider.getUserRole().) approved.add(id);
    // TODO: if(!approved && user hat keine Rechte dazu) return;

    // TODO: if(ortBeschreibung < selbstDefinierter Radius entfernt) dann:
    // if (!upComing.contains(
    //     id)) // idk. ob das überhaupt sein kann, aber sicher ist sicher
    // TODO: So kann es noch passieren dass durch zwischen laden
    // mit anderen attemptBefehlen die reihenfolge nicht mehr stimmt...

    DateTime created = DateTime.parse(json['erstellt_ts']);

    if (json['favorit'] == '1') favorites.add(id);

    // TODO: latitude, longitude noch anpassen...
    Veranstaltung event = Veranstaltung.load(
        id, titel, description, contact, place, start, end, created, 0, 0);

    loadEvent(event);

    return event;
  }
}
