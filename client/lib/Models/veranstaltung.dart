import 'dart:developer';

import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Veranstaltung {
  int id, institutionsId, erstellerId;
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
      this.institutBeschreibung,
      this.erstellerId);

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
      this.institutBeschreibung,
      this.erstellerId);

  EventPreviewBox getPreviewBox() {
    return EventPreviewBox.load(this, AdditiveFormat.HOLE_DATETIME);
  }

  List<Widget> getImages() {
    List<Widget> loadedImages = [];

    for (String file in images) {
      try {
        if (file.endsWith(".pdf")) {
          loadedImages.add(SfPdfViewer.network(
              "https://app.lebensqualitaet-burgrieden.de/" + file, enableDoubleTapZooming: true));
        } else {
          loadedImages.add(Image(
              image: NetworkImage(
                  "https://app.lebensqualitaet-burgrieden.de/" + file)));
        }
      } catch (e) {
        log("Fehler beim eines Bilder einer Veranstaltung");
      }
    }

    return loadedImages;
  }
}
