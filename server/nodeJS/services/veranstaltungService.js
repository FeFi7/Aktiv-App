let Veranstaltung = require("../models/Veranstaltung").Veranstaltung 
let conn = require('../db').getConnection();

async function getVeranstaltungById(veranstaltungId){
    const query = `SELECT v.id, v.titel, v.beschreibung, v.kontakt, v.beginn_ts, v.ende_ts, v.ortBeschreibung, v.erstellt_ts, i.name AS institutionName, i.beschreibung AS institutBeschreibung  FROM Veranstaltung v
    INNER JOIN Institution i ON v.institutionId = i.id
    WHERE v.id = ?
    LIMIT 10`

    let result =  (await conn.query(query, [Number(veranstaltungId)]).catch(error => {console.log(error); return { error: "Fehler bei Db" };}))
    if(result){
        return result[0]
    }
    else{
        return { error: "Fehler bei Db" };
    }
}

async function getVeranstaltungen(limit = 25, istGenehmigt = 1, bis, userId = 0, page = 1){
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
    ORDER BY v.beginn_ts asc
    LIMIT ?,?`
    const queryWithUserFavorites = `SELECT v.id, v.titel, v.beschreibung, v.kontakt, v.beginn_ts, v.ende_ts, v.ortBeschreibung, v.erstellt_ts, v.istGenehmigt, i.name AS institutionName, i.beschreibung AS institutBeschreibung, IF(f.valide=1, 1, 0) as favorit FROM Veranstaltung v
    LEFT JOIN Institution i ON v.institutionId = i.id
    LEFT JOIN Favorit f ON v.id = f.veranstaltungId AND f.valide = 1 AND f.userId = ?
    WHERE v.istGenehmigt = ? AND v.beginn_ts >= NOW() AND v.beginn_ts <= ?
    ORDER BY v.beginn_ts asc
    LIMIT ?,?`

    let results = {};

    if(userId !== 0){
        results = (await conn.query(queryWithUserFavorites, [Number(userId), Number(istGenehmigt), bis, (Number(limit)*Number(page))- Number(limit), Number(limit)]).catch(error => {console.log(error); return { error: "Fehler bei Db" };}))
    }
    else{
        results = (await conn.query(query, [Number(istGenehmigt), bis, (Number(limit)*Number(page))- Number(limit), Number(limit)]).catch(error => {console.log(error); return { error: "Fehler bei Db" };}))
    }

    if(results){
        let result = results[0];
        return result;
    }
    else{
        return {error: "Fehler in db"};
    }
}

async function createVeranstaltung(titel, beschreibung, kontakt, beginn, ende, ortBeschreibung, latitude, longitude, institutionId, userId, istGenehmigt ){
    const query = `INSERT INTO Veranstaltung(titel, beschreibung, kontakt, beginn_ts, ende_ts, ortBeschreibung, koordinaten, institutionId, userId, istGenehmigt)
    VALUES( ?, ?, ?, ?, ?, ?, ST_SRID( POINT(?, ?) ,4326), IF(?=0, Null, ?) , ?, ?)`

    const params = [titel, beschreibung, kontakt, beginn, ende, ortBeschreibung, latitude, longitude, Number(institutionId), Number(institutionId), Number(userId), Number(istGenehmigt)];

    let result = (await conn.query(query, params).catch(error => {console.log(error); return { error: "Fehler bei Db" };}))

    if(result){
        return result[0]
    }
    else{
        return { error: "Fehler bei Db" };
    }
}

async function addFileIdsToVeranstaltung(veranstaltungId, fileIds){
    const query = `INSERT INTO VeranstaltungFile(veranstaltungId, fileId) VALUES(?, ?)`

    await fileIds.forEach(async function(fileId){
        const params = [veranstaltungId, fileId];
        (await conn.query(query, params).catch(error => {console.log(error); return { error: "Fehler bei Db" };}))
    })

    return true
}



module.exports = {
    getVeranstaltungById: getVeranstaltungById,
    getVeranstaltungen: getVeranstaltungen,
    createVeranstaltung: createVeranstaltung,
    addFileIdsToVeranstaltung: addFileIdsToVeranstaltung
}
