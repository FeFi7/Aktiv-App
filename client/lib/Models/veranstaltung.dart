import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';

class Veranstaltung {

  int id, institutionsId;
  String titel, beschreibung, kontakt, plz, ortBeschr;

  DateTime beginnTs, endeTs, erstelltTs;
  double latitude, longitude;
  List<String> selectedTags = [];
  List<String> imageIds = [];
  //Bilder mit abspeichern

  Veranstaltung.create(
    this.titel,
    this.beschreibung,
    this.kontakt,
    this.ortBeschr,
    this.beginnTs,
    this.endeTs,

    this.institutionsId,
    this.imageIds,
    this.selectedTags,
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
  
    this.institutionsId,
    this.imageIds,
    this.selectedTags,
  );

  EventPreviewBox getPreviewBox() {
    return EventPreviewBox.load(this, AdditiveFormat.HOLE_DATETIME);
  }
}
