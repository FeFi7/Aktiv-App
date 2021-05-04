let Veranstaltung = require("../models/Veranstaltung").Veranstaltung;
let conn = require("../db").getConnection();

async function getVeranstaltungById(veranstaltungId) {
  const query = `SELECT v.id, v.titel, v.beschreibung, v.kontakt, v.beginn_ts, v.ende_ts, v.ortBeschreibung, v.erstellt_ts, i.name AS institutionName, i.beschreibung AS institutBeschreibung, v.userId AS ersteller  FROM Veranstaltung v
    LEFT JOIN Institution i ON v.institutionId = i.id
    WHERE v.id = ?
    LIMIT 10`;

  let result = await conn
    .query(query, [Number(veranstaltungId)])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
  if (result) {
    return result[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function getFavoritVeranstaltungenByUser(userId, limit, page) {
  const queryWithUserFavorites = `SELECT v.id, v.titel, v.beschreibung, v.kontakt, v.beginn_ts, v.ende_ts, v.ortBeschreibung, v.erstellt_ts, v.istGenehmigt, i.name AS institutionName, i.beschreibung AS institutBeschreibung, IF(f.valide=1, 1, 0) as favorit FROM Veranstaltung v
    LEFT JOIN Institution i ON v.institutionId = i.id
    INNER JOIN Favorit f ON v.id = f.veranstaltungId AND f.valide = 1 AND f.userId = ?
    WHERE v.istGenehmigt = 1 AND v.beginn_ts >= NOW()
    ORDER BY v.beginn_ts asc
    LIMIT ?,?`;

  let result = await conn
    .query(queryWithUserFavorites, [
      Number(userId),
      Number(limit) * Number(page) - Number(limit),
      Number(limit),
    ])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
  if (result) {
    return result[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function getVeranstaltungFilesById(veranstaltungId) {
  const query = `SELECT id, pfad, typ FROM VeranstaltungFile vf 
  INNER JOIN File f ON vf.fileId = f.id
  WHERE vf.veranstaltungId = ?`;

  let result = await conn
    .query(query, [Number(veranstaltungId)])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
  if (result) {
    return result[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function genehmigeVeranstaltung(veranstaltungId) {
  const query = `UPDATE Veranstaltung v SET v.istGenehmigt = 1 WHERE v.id = ?`;

  let result = await conn
    .query(query, [Number(veranstaltungId)])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
  if (result) {
    return result[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function deleteVeranstaltung(veranstaltungId) {
  const query = `DELETE FROM Veranstaltung v WHERE v.id = ?`;

  let result = await conn
    .query(query, [Number(veranstaltungId)])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
  if (result) {
    return result[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function getVeranstaltungen(
  limit = 25,
  istGenehmigt = 1,
  bis,
  userId = 0,
  page = 1,
  vollText,
  datum,
  latitude,
  longitude,
  entfernung,
  sorting,
  plz
) {
  console.log("in der richtigen Funktion");
  // Falls nichts angegeben bis 1 Monat in der Zukunft
  if (!bis) {
    const dt = new Date();
    bis = `${dt.getFullYear().toString().padStart(4, "0")}-${(dt.getMonth() + 2)
      .toString()
      .padStart(2, "0")}-${dt
      .getDate()
      .toString()
      .padStart(2, "0")} ${dt
      .getHours()
      .toString()
      .padStart(2, "0")}:${dt
      .getMinutes()
      .toString()
      .padStart(2, "0")}:${dt.getSeconds().toString().padStart(2, "0")}`;
  }

  // für sql wildcard anpassen
  if (vollText) {
    vollText = "%" + vollText + "%";
  }
  // if(plz){
  //   plz = "%" + plz + "%";
  // }
  console.log("sortiert nach: " + sorting);
  const queryPartVollText = ` AND v.titel LIKE ? OR v.beschreibung LIKE ? OR i.name LIKE ? `;
  const query =
    `SELECT v.id, v.titel, v.beschreibung, v.kontakt, v.beginn_ts, v.ende_ts, v.ortBeschreibung, v.erstellt_ts, ROUND(st_distance_sphere( ST_SRID(POINT(?,?), 4326), v.koordinaten)/1000, 1) AS entfernung, 
    v.istGenehmigt, i.name AS institutionName, i.beschreibung AS institutBeschreibung, fi.pfad as institutionImage FROM Veranstaltung v
    LEFT JOIN Institution i ON v.institutionId = i.id
    LEFT JOIN File fi ON i.imageId = fi.id
    WHERE v.istGenehmigt = ? ` +
    (plz ? ` AND (SELECT plz from PLZ where id = v.plzId) = ? ` : ``) +
    (datum
      ? `AND v.beginn_ts >= ? AND v.beginn_ts < DATE_ADD(?, INTERVAL 1 DAY)`
      : `AND v.beginn_ts >= NOW() AND v.beginn_ts <= ?`) +
    (vollText ? queryPartVollText : "") +
    ` AND st_distance_sphere( ST_SRID(POINT(?,?), 4326), v.koordinaten)/1000 < ?
    ORDER BY ` +
    sorting +
    ` asc
    LIMIT ?,?`;
  const queryWithUserFavorites =
    `SELECT v.id, v.titel, v.beschreibung, v.kontakt, v.beginn_ts, v.ende_ts, v.ortBeschreibung, v.erstellt_ts, ROUND(st_distance_sphere( ST_SRID(POINT(?,?), 4326), v.koordinaten)/1000, 1) AS entfernung, 
    v.istGenehmigt, i.name AS institutionName, i.beschreibung AS institutBeschreibung, IF(f.valide=1, 1, 0) as favorit, fi.pfad as institutionImage FROM Veranstaltung v
    LEFT JOIN Institution i ON v.institutionId = i.id
    LEFT JOIN File fi ON i.imageId = fi.id
    LEFT JOIN Favorit f ON v.id = f.veranstaltungId AND f.valide = 1 AND f.userId = ?
    WHERE v.istGenehmigt = ? ` +
    (plz ? ` AND (SELECT plz from PLZ where id = v.plzId) = ? ` : ``) +
    (datum
      ? `AND v.beginn_ts >= ? AND v.beginn_ts < DATE_ADD(?, INTERVAL 1 DAY)`
      : `AND v.beginn_ts >= NOW() AND v.beginn_ts <= ?`) +
    (vollText ? queryPartVollText : "") +
    ` AND st_distance_sphere( ST_SRID(POINT(?,?), 4326), v.koordinaten)/1000 < ?
    ORDER BY ` +
    sorting +
    ` asc
    LIMIT ?,?`;

  let results = {};
  const datumParams = datum ? [datum, datum] : [bis];
  const plzParams = plz ? [plz] : [];

  if (userId !== 0) {
    results = await conn
      .query(
        queryWithUserFavorites,
        vollText
          ? [
              longitude,
              latitude,
              Number(userId),
              Number(istGenehmigt),
              ...plzParams,
              ...datumParams, //bis),
              vollText,
              vollText,
              vollText,
              longitude,
              latitude,
              entfernung,
              Number(limit) * Number(page) - Number(limit),
              Number(limit),
            ]
          : [
              longitude,
              latitude,
              Number(userId),
              Number(istGenehmigt),
              ...plzParams,
              ...datumParams, //bis),
              longitude,
              latitude,
              entfernung,
              Number(limit) * Number(page) - Number(limit),
              Number(limit),
            ]
      )
      .catch((error) => {
        console.log(error);
        return { error: "Fehler bei Db" };
      });
  } else {
    console.log(query);
    results = await conn
      .query(
        query,
        vollText
          ? [
              longitude,
              latitude,
              Number(istGenehmigt),
              ...plzParams,
              ...datumParams, //bis),
              vollText,
              vollText,
              vollText,
              longitude,
              latitude,
              entfernung,
              Number(limit) * Number(page) - Number(limit),
              Number(limit),
            ]
          : [
              longitude,
              latitude,
              Number(istGenehmigt),
              ...plzParams,
              ...datumParams, //bis),
              longitude,
              latitude,
              entfernung,
              Number(limit) * Number(page) - Number(limit),
              Number(limit),
            ]
      )
      .catch((error) => {
        console.log(error);
        return { error: "Fehler bei Db" };
      });
  }

  if (results) {
    let result = results[0];
    return result;
  } else {
    return { error: "Fehler in db" };
  }
}

async function createVeranstaltung(
  titel,
  beschreibung,
  kontakt,
  plz,
  beginn,
  ende,
  ortBeschreibung,
  latitude,
  longitude,
  institutionId,
  userId,
  istGenehmigt
) {
  const queryPlz = `INSERT INTO PLZ(PLZ.plz) VALUES(?) ON DUPLICATE KEY UPDATE PLZ.plz = PLZ.plz;`;
  await conn.query(queryPlz, [plz]).catch((error) => {
    console.log(error);
    return { error: "Fehler in DB" };
  });

  const query = `INSERT INTO Veranstaltung(titel, beschreibung, kontakt, beginn_ts, ende_ts, ortBeschreibung, koordinaten, institutionId, userId, istGenehmigt, plzId)
    VALUES( ?, ?, ?, ?, ?, ?, ST_SRID( POINT(?, ?) ,4326), IF(?=0, Null, ?) , ?, ?, (SELECT id from PLZ where plz = ?))`;

  const params = [
    titel,
    beschreibung,
    kontakt,
    beginn,
    ende,
    ortBeschreibung,
    longitude,
    latitude,
    Number(institutionId),
    Number(institutionId),
    Number(userId),
    Number(istGenehmigt),
    plz,
  ];

  let result = await conn.query(query, params).catch((error) => {
    console.log(error);
    return { error: "Fehler bei Db" };
  });

  if (result) {
    return result[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function addFileIdsToVeranstaltung(veranstaltungId, fileIds) {
  const query = `INSERT INTO VeranstaltungFile(veranstaltungId, fileId) VALUES(?, ?)`;

  await fileIds.forEach(async function (fileId) {
    const params = [veranstaltungId, fileId];
    await conn.query(query, params).catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
  });

  return true;
}

async function addTagsToVeranstaltung(veranstaltungId, tags) {
  const queryVerknuepfung = `INSERT INTO TagZuweisung(veranstaltungId, tagId) VALUES(?, (SELECT id from Tag where name = ?))`;
  const queryErstellungTag = `INSERT INTO Tag(name) VALUES(?) ON DUPLICATE KEY UPDATE id=id`;

  await tags.forEach(async function (tag) {
    await conn.query(queryErstellungTag, tag).catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
    const params = [veranstaltungId, tag];
    await conn.query(queryVerknuepfung, params).catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
  });

  return true;
}

async function getTagsFiltered(tag) {
  // für sql wildcard anpassen
  if (tag) {
    tag = "%" + tag + "%";
  } else {
    tag = "%%";
  }

  const queryVerknuepfung = `SELECT t.name, COUNT(t.name) beliebtheit FROM Tag t
  INNER JOIN TagZuweisung tz ON t.id = tz.tagId
  WHERE t.name LIKE ?
  GROUP BY t.name
  ORDER BY beliebtheit desc LIMIT 10`;

  const result = await conn.query(queryVerknuepfung, [tag]).catch((error) => {
    console.log(error);
    return { error: "Fehler bei Db" };
  });

  console.log("Anzahl tags für " + tag + ": " + result[0].length);

  if (result) {
    return result[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function isUserVeranstaltungErsteller(veranstaltungId, userId) {
  const query = `SELECT * FROM Veranstaltung v WHERE v.id = ? AND v.userId = ?`;

  let results = await conn
    .query(query, [Number(veranstaltungId), Number(userId)])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler in Db" };
    });

  if (results) {
    results = results[0];
    if (results.length > 0) {
      return true;
    } else {
      return false;
    }
  } else {
    return { error: "Fehler bei Db" };
  }
}

module.exports = {
  getVeranstaltungById: getVeranstaltungById,
  getVeranstaltungen: getVeranstaltungen,
  createVeranstaltung: createVeranstaltung,
  addFileIdsToVeranstaltung: addFileIdsToVeranstaltung,
  genehmigeVeranstaltung: genehmigeVeranstaltung,
  isUserVeranstaltungErsteller: isUserVeranstaltungErsteller,
  deleteVeranstaltung: deleteVeranstaltung,
  addTagsToVeranstaltung: addTagsToVeranstaltung,
  getTagsFiltered: getTagsFiltered,
  getVeranstaltungFilesById: getVeranstaltungFilesById,
  getFavoritVeranstaltungenByUser: getFavoritVeranstaltungenByUser,
};
