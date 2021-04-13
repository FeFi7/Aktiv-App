class Veranstaltung {
  int id;
  String titel, beschreibung, kontakt, ortBeschr;
  DateTime beginnTs, endeTs, erstelltTs;
  double latitude, longitude;
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

    //code für id von database
    int maxid = 0;
    maxid++;
    this.id=maxid;
    this.erstelltTs = DateTime.now();
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

  );
}
