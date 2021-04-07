let Veranstaltung = require("../models/Veranstaltung").Veranstaltung 
let conn = require('../db').getConnection();

async function getVeranstaltungById(veranstaltungId){
    const query = `SELECT v.id, v.titel, v.beschreibung, v.kontakt, v.beginn_ts, v.ende_ts, v.ortBeschreibung, v.erstellt_ts, i.name AS institutionName, i.beschreibung AS institutBeschreibung  FROM Veranstaltung v
    INNER JOIN Institution i ON v.institutionId = i.id
    WHERE v.id = ?
    LIMIT 10`

    const result =  (await conn.query(query, [veranstaltungId]).catch(error => {console.log(error); return null;}))[0]
    return result;
}

async function getVeranstaltungen(limit = 25){
    const query = `SELECT v.id, v.titel, v.beschreibung, v.kontakt, v.beginn_ts, v.ende_ts, v.ortBeschreibung, v.erstellt_ts, i.name AS institutionName, i.beschreibung AS institutBeschreibung FROM Veranstaltung v
    INNER JOIN Institution i ON v.institutionId = i.id
    LIMIT ?`

    const result = (await conn.query(query, [limit]).catch(error => {console.log(error); return null;}))[0]
    return result;
}

async function createVeranstaltung(titel, beschreibung, kontakt, beginn, ende, ortBeschreibung, latitude, longitude, institutionId, userId, istGenehmigt ){
    const query = `INSERT INTO Veranstaltung(titel, beschreibung, kontakt, beginn_ts, ende_ts, ortBeschreibung, koordinaten, institutionId, userId, istGenehmigt)
    VALUES( ?, ?, ?, ?, ?, ?, ST_SRID( POINT(?, ?) ,4326), ?, ?, ?)`

    const params = [titel, beschreibung, kontakt, beginn, ende, ortBeschreibung, latitude, longitude, institutionId, userId, istGenehmigt];

    const result = (await conn.query(query, params).catch(error => {console.log(error); return null;}))[0]
    return result;

}



module.exports = {
    getVeranstaltungById: getVeranstaltungById,
    getVeranstaltungen: getVeranstaltungen,
    createVeranstaltung: createVeranstaltung
}
