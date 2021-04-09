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

async function getVeranstaltungen(limit = 25, istGenehmigt = 1, bis){
    // Falls nichts angegeben bis 1 Monat in der Zukunft
    if(!bis){
        const dt = new Date();
        bis = `${
            dt.getFullYear().toString().padStart(4, '0')}-${
            (dt.getMonth()+2).toString().padStart(2, '0')}-${
            dt.getDate().toString().padStart(2, '0')} ${
            dt.getHours().toString().padStart(2, '0')}:${
            dt.getMinutes().toString().padStart(2, '0')}:${
            dt.getSeconds().toString().padStart(2, '0')}`
    }
    const query = `SELECT v.id, v.titel, v.beschreibung, v.kontakt, v.beginn_ts, v.ende_ts, v.ortBeschreibung, v.erstellt_ts, v.istGenehmigt, i.name AS institutionName, i.beschreibung AS institutBeschreibung FROM Veranstaltung v
    LEFT JOIN Institution i ON v.institutionId = i.id
    WHERE v.istGenehmigt = ? AND v.beginn_ts >= NOW() AND v.beginn_ts <= ?
    LIMIT ?`

    const result = (await conn.query(query, [istGenehmigt, bis, limit]).catch(error => {console.log(error); return null;}))[0]
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
