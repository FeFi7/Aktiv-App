import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';

class Veranstaltung {
  int id;
  String titel, beschreibung, kontakt, ortBeschr;
  DateTime beginnTs, endeTs, erstelltTs;
  double latitude, longitude;
  bool approved;
  //Bilder mit abspeichern

  Veranstaltung.create(
    this.titel,
    this.beschreibung,
    this.kontakt,
    this.ortBeschr,
    this.beginnTs,
    this.endeTs,
    this.latitude,
    this.longitude,
  ) {
    // Muss noch code für id von database geschrieben werden
    // Aktuell noch nur platzhalter
    //int maxid = 0;
    //maxid++;
    //this.id = maxid;
    //this.erstelltTs = DateTime.now();
  }

  Veranstaltung.load(
    this.id,
    this.titel,
    this.beschreibung,
    this.kontakt,
    this.ortBeschr,
    this.beginnTs,
    this.endeTs,
    this.erstelltTs,
    this.latitude,
    this.longitude,
    this.approved
  );

  EventPreviewBox getPreviewBox() {
    return EventPreviewBox(id, titel, beschreibung, beginnTs.toIso8601String(), false);
  }
}
