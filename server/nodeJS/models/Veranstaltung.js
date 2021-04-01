
function Veranstaltung(id, titel, beschreibung, kontakt, beginn, ende, ortBeschr, erstellt, latitude, longitude){
    this.id = id;
    this.titel = titel;
    this.beschreibung = beschreibung;
    this.kontakt = kontakt;
    this.beginn = beginn;
    this.ende = ende;
    this.ortBeschr = ortBeschr;
    this.erstellt = erstellt;
    this.latitude = latitude;
    this.longitude = longitude;
}

module.exports = {
    Veranstaltung: Veranstaltung
}