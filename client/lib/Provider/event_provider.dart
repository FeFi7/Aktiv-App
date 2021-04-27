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
  static final Map<int, Veranstaltung> loaded = Map<int, Veranstaltung>();
  static Map<DateTime, List<int>> dated = Map<DateTime, List<int>>();
  static List<int> nearby = [];
  static List<int> upComing = [];
  static List<int> favorites = [];
  static List<int> approved = [];
  static final int pageSize = 25;
  static Map<String, int> nextPageToLoad = Map<String, int>();

  List<Veranstaltung> getLoadedEvents() {
    return loaded.values.toList();
  }

  Future<List<Widget>> loadEventsAsPreviewBoxContaining(String text) async {
    List<Widget> eventPreviews = [];

    // So kann bei der suche differenziert werden, nach was gesucht wird
    switch (SearchBehaviorProvider.style) {
      case SearchStyle.FULLTEXT:
        List<EventPreviewBox> boxes = (await loadEventsContainingText(text))
            .map((event) => EventPreviewBox.load(event))
            .toList();

        return boxes;
      case SearchStyle.DATE:
        // TODO: Suche nach allen Events an dem Datum aus der Datenbank laden un zurück geben

        DateTime dateTime = isValidDate(text);
        if (dateTime != null) {
          return getLoadedEventsOfDay(dateTime)
              .map((event) => EventPreviewBox.load(event))
              .toList();
        } else {
          eventPreviews.add(ErrorPreviewBox(
              "Bei der von Ihnen getätigten Suchanfrage \"" +
                  text +
                  "\" handelt es sich um kein gültiges Datum Format. Bitte Datum im Format Tag.Monat.Jahr angeben."));
        }

        if (eventPreviews.length == 0)
          eventPreviews.add(ErrorPreviewBox(
              "Es konnten keine Veranstaltungen für den " +
                  text +
                  " gefunden werden."));

        return eventPreviews;
      case SearchStyle.PERIOD:
        // TODO: Volltext Scuhe aus der Datenbank laden un zurück geben

        DateTime dateTime = isValidDate(text);
        if (dateTime != null) {
          List<EventPreviewBox> boxes = (await loadEventsUntil(dateTime))
              .map((event) => EventPreviewBox.load(event))
              .toList();

          return boxes;
        } else {
          eventPreviews.add(ErrorPreviewBox(
              "Bei der von Ihnen getätigten Suchanfrage \"" +
                  text +
                  "\" handelt es sich um kein gültiges Datum Format. Bitte Datum im Format Tag.Monat.Jahr angeben."));
        }

        return eventPreviews;
      default:
        return eventPreviews;
    }
  }

  Future<List<Veranstaltung>> loadEventsContainingText(String text) async {
    String pageTitle = "attemptGetAllTextSearch:" + text;

    List<Veranstaltung> foundEvents = [];

    bool loadNextPage = true;
    for (int page = nextPageToLoad[pageTitle] ?? 1; loadNextPage; page++) {
      var response = await attemptGetAllVeranstaltungen(
          "-1",
          "1", // TODO: nur zugelssene Events zurück?
          pageSize.toString(),
          page.toString(),
          "-1",
          text);
      if (response.statusCode == 200) {
        var parsedJson = json.decode(response.body);

        final List<dynamic> dynamicList =
            await parsedJson.map((item) => getEventFromJson(item)).toList();

        final List<Veranstaltung> responseList =
            List<Veranstaltung>.from(dynamicList).toList();

        foundEvents.addAll(responseList);

        if (responseList.length <= 0 && (foundEvents.length > 0 || page > 6))
          loadNextPage = false;

        nextPageToLoad[pageTitle] = page + 1;
      } else {
        log("Fehler bei der Suche nach dem Schlüsselwort:" +
            text +
            " auf Seite: " +
            page.toString());
        // nextPage = false;
      }
    }

    return foundEvents;
  }

  Future<List<Veranstaltung>> loadEventsUntil(DateTime date) async {
    // String pageTitle = "attemptGetAllTextSearch:" + text;

    List<Veranstaltung> foundEvents = [];

    bool loadNextPage = true;
    for (int page = 1; loadNextPage; page++) {
      var response = await attemptGetAllVeranstaltungen(
          date.toString(),
          "1", // TODO: nur zugelassene Events?
          pageSize.toString(),
          page.toString(),
          "-1");
      if (response.statusCode == 200) {
        var parsedJson = json.decode(response.body);

        final List<dynamic> dynamicList =
            await parsedJson.map((item) => getEventFromJson(item)).toList();

        final List<Veranstaltung> responseList =
            List<Veranstaltung>.from(dynamicList).toList();

        foundEvents.addAll(responseList);

        if (responseList.length <= 0 && (foundEvents.length > 0 || page > 6))
          loadNextPage = false;
      } else {
        log("Fehler bei der Suche nach Veranstaltungen  bis zum " +
            date.toString() +
            " auf Seite: " +
            page.toString());
        // nextPage = false;
      }
    }

    return foundEvents;
  }

  DateTime isValidDate(String possiblyDate) {
    List<String> args = possiblyDate.split(".");
    if (args.length > 2 &&
        args[0].length == 2 &&
        args[1].length == 2 &&
        args[2].length == 4)
      return DateTime.parse(args[2] + '-' + args[1] + '-' + args[0]);
    return null;
  }

  Future<List<Veranstaltung>> loadFavoriteEvents(BuildContext context) {
    // return upComing.map((id) => loaded[id]).toList();
    String pageTitle = "favorites";
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
        events.remove(event);
    }
    return events;
  }

  List<Veranstaltung> getLoadedEventsOfDay(DateTime day) {
    DateTime start = DateTime.utc(day.year, day.month, day.day);
    DateTime end = DateTime.utc(day.year, day.month, day.day + 1);

    List<Veranstaltung> eventsOfMonth = [];

    for (DateTime date in dated.keys)
      if (start.isBefore(date) && date.isBefore(end))
        for (int eventId in dated[date]) eventsOfMonth.add(loaded[eventId]);

    return eventsOfMonth;
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
    // int userId = 11;

    int year = month.year;

    DateTime start = DateTime.utc(year, month.month, 1);
    DateTime end = DateTime.utc(year, month.month + 1, 0);

    List<Veranstaltung> eventsOfMonth = [];

    for (DateTime date in dated.keys)
      if (start.isBefore(date) && date.isBefore(end))
        for (int eventId in dated[date]) eventsOfMonth.add(loaded[eventId]);

    return eventsOfMonth;
  }

  List<Veranstaltung> getLoadedFavoriteEvents() {
    return favorites.map((entry) => loaded[entry]).toList();
  }

  // void resetFavoriteEvents() {
  //   nearby.clear();
  //   nextPageToLoad["upcoming"] = 1;
  //   loadFavoriteEvents();
  // }

  // void loadFavoriteEvents() {
  //   favorites.clear();
  //   int page = nextPageToLoad["favorites"] ?? 1;
  //   //TODO: attemptsGetFavEvents(page);
  //   nextPageToLoad["favorites"] = ++page;
  // }

  List<Veranstaltung> getEventsNearBy() {
    // return nearby.map((entry) => loaded[entry]).toList();
    // TODO: Noch ändern, muss aber erstmal attemt methode geben
    return getLoadedUpComingEvents();
  }

  void resetEventsNearBy() {
    nearby.clear();
    nextPageToLoad["nearby"] = 1;
    loadEventsNearBy();
  }

  void loadEventsNearBy() async {
    // EventsNearBy aus Datenbank in nearby laden
    print("man sollte die events nearby weiter laden");
    // notifyListeners();
    int page = nextPageToLoad["nearby"] ?? 1;
    // TODO: attemptGetEventsNearB y(page)
    nextPageToLoad["nearby"] = ++page;
  }

  List<Veranstaltung> getLoadedUpComingEvents() {
    return upComing.map((id) => loaded[id]).toList();
  }

  void resetUpComingEvents() {
    nearby.clear();
    nextPageToLoad["upcoming"] = 1;
    loadUpComingEvents();
  }

  void loadUpComingEvents() {
    int page = nextPageToLoad["upcoming"] ?? 1;
    // TODO: attemptGetUpComingEvents(page)
    //
    nextPageToLoad["upcoming"] = ++page;
  }

  List<Veranstaltung> getLoadedEventsAt(DateTime day, int page) {
    if (dated[day] != null) return dated[day].map((id) => loaded[id]).toList();
    return null; // Alle Events an dem Tag aus laden und zurückgeben => loadEventsAt...
  }

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
    // int id = 0;
    Response resp = await attemptCreateVeranstaltung(titel, beschreibung, email,
        start, ende, adresse, '89231', '1', '1', '1');
    // print(resp.body);

    if (resp.statusCode == 200) {
      var parsedJson = json.decode(resp.body);
      int eventId = parsedJson['insertId'];

      DateTime startTs = DateTime.parse(start);
      DateTime endeTs = DateTime.parse(ende);
      DateTime erstelltTs = DateTime.now();

      Veranstaltung veranstaltung = Veranstaltung.load(eventId, titel,
          beschreibung, email, adresse, startTs, endeTs, erstelltTs, 0, 0);

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

  void loadFirstPages() {
    DateTime nextMonth =
        DateTime.utc(DateTime.now().year, DateTime.now().month + 2, 0);
    loadEventsUntil(nextMonth);
    // loadFavoriteEvents(context); TODO: was mache ich jetzt? initstate hat keinen Context
    loadUpComingEvents();
    loadEventsNearBy();
  }

  void loadEvent(Veranstaltung event) {
    if (event == null || isEventLoaded(event.id)) return;
    loaded[event.id] = event;
    if (dated[event.beginnTs] != null)
      dated[event.beginnTs].add(event.id);
    else
      dated[event.beginnTs] = [event.id];

    if (!upComing.contains(event.id)) upComing.add(event.id);

    notifyListeners();
  }

  void deleteEvent(BuildContext context, event) {
    String accessToken = Provider.of<UserProvider>(context).getAccessToken();
    attemptDeleteVeranstaltung(event.id, accessToken);
  }

  bool isEventLoaded(int id) {
    return loaded.containsKey(id);
  }

  bool isEventFavorite(int id) {
    return favorites.contains(id);
  }

  //TODO: Mit BackEnd verbinden, warte auf User Provider
  bool toggleEventFavoriteState(BuildContext context, int eventId) {
    if (isEventFavorite(eventId)) {
      favorites.remove(eventId);
    } else {
      favorites.add(eventId);
    }

    if (UserProvider.userId != null && UserProvider.userId >= 0) {
      String accessToken =
          Provider.of<UserProvider>(context, listen: false).getAccessToken();
      attemptFavor(
          UserProvider.userId.toString(), eventId.toString(), accessToken);
    }

    return isEventFavorite(eventId);
  }

  Veranstaltung getEventFromJson(Map<String, dynamic> json) {
    int id = json['id'];

    if (json['favorit'] == '1') favorites.add(id);
    if (isEventLoaded(id)) return loaded[id];

    String titel = json['titel'];
    String description = json['beschreibung'];
    String contact = json['kontakt'];
    DateTime start = DateTime.parse(json['beginn_ts']);
    DateTime end = DateTime.parse(json['ende_ts']);
    String place = json['ortBeschreibung'];

    bool isApproved = json['istGenehmigt'] == '1';
    if (isApproved) approved.add(id); //  || UserProvider.getUserRole().

    // TODO: if(ortBeschreibung < selbstDefinierter Radius entfernt) dann:
    // if (!upComing.contains(
    //     id)) // idk. ob das überhaupt sein kann, aber sicher ist sicher
    // TODO: So kann es noch passieren dass durch zwischen laden
    // mit anderen attemptBefehlen die reihenfolge nicht mehr stimmt...

    DateTime created = DateTime.parse(json['erstellt_ts']);

    // TODO: latitude, longitude noch anpassen...
    Veranstaltung event = Veranstaltung.load(
        id, titel, description, contact, place, start, end, created, 0, 0);

    loadEvent(event);

    return event;
  }
}
