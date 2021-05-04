import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:flutter/material.dart';

class Veranstaltung {
  int id, institutionsId;
  String titel,
      beschreibung,
      kontakt,
      plz,
      ortBeschr,
      institutionName,
      institutBeschreibung;

  DateTime beginnTs, endeTs, erstelltTs;
  double latitude, longitude;
  List<String> selectedTags = [];
  List<String> images = [];
  //Bilder mit abspeichern

  Veranstaltung.create(
      this.titel,
      this.beschreibung,
      this.kontakt,
      this.ortBeschr,
      this.beginnTs,
      this.endeTs,
      this.institutionsId,
      this.images,
      this.selectedTags,
      this.institutionName,
      this.institutBeschreibung) {
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
      this.images,
      this.selectedTags,
      this.institutionName,
      this.institutBeschreibung);

  EventPreviewBox getPreviewBox() {
    return EventPreviewBox.load(this, AdditiveFormat.HOLE_DATETIME);
  }

  List<Widget> getImages() {
    List<Widget> loadedImages = [];

    for (String file in images) {
      loadedImages.add(Image(
          image: NetworkImage(
              "https://app.lebensqualitaet-burgrieden.de/" + file)));
    }

    return loadedImages;
  }
}
