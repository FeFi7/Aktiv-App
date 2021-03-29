let Veranstaltung = require("../models/Veranstaltung").Veranstaltung


function getVeranstaltungById(veranstaltungId){

    // Testdatensatz da DB noch nicht vorhanden
    return new Veranstaltung(1, "Testveranstaltung", "Testbeschreibung", "Tel: 0125125123",
    "2021-28-03 14:20", "2021-28-03 15:25", "Am Musterweg 4 gleichen hinter der Hütte", 
    "2021-05-03 14:00", 2.2111114, 2.244442);
}

module.exports = {
    getVeranstaltungById: getVeranstaltungById
}
