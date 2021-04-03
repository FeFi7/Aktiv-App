let Veranstaltung = require("../models/Veranstaltung").Veranstaltung 
let conn = require('../db').getConnection();

function getVeranstaltungById(veranstaltungId){

    // Testdatensatz da DB noch nicht vorhanden
    return new Veranstaltung(1, "Testveranstaltung", "Testbeschreibung", "Tel: 0125125123",
    "2021-28-03 14:20", "2021-28-03 15:25", "Am Musterweg 4 gleichen hinter der Hütte", 
    "2021-05-03 14:00", 2.2111114, 2.244442);
}

function getVeranstaltungen(){
    conn.execute("SELECT * FROM PLZ", function(err, rows, fields) {
        if(err){
            console.log(err);
        }
        else{
            console.log(rows.length + " rows gefunden")
        }
        
     })

    // Testdatensatz da DB noch nicht vorhanden
    return [new Veranstaltung(1, "Testveranstaltung", "Testbeschreibung", "Tel: 0125125123",
    "2021-28-03 14:20", "2021-28-03 15:25", "Am Musterweg 4 gleichen hinter der Hütte", 
    "2021-05-03 14:00", 2.2111114, 2.244442),
    new Veranstaltung(2, "Testveranstaltung2", "Testbeschreibung2", "Tel: 0125125123",
    "2021-28-03 14:20", "2021-28-03 15:25", "Am Musterweg 4 gleichen hinter der Hütte", 
    "2021-05-03 14:00", 2.2111114, 2.244442),
    new Veranstaltung(3, "Testveranstaltung3", "Testbeschreibung3", "Tel: 0125125123",
    "2021-28-03 14:20", "2021-28-03 15:25", "Am Musterweg 4 gleichen hinter der Hütte", 
    "2021-05-03 14:00", 2.2111114, 2.244442)];
}



module.exports = {
    getVeranstaltungById: getVeranstaltungById,
    getVeranstaltungen: getVeranstaltungen
}
