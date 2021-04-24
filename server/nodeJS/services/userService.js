const bcrypt = require("bcrypt");
let conn = require("../db").getConnection();

async function getuserById(userId) {
  // Testdatensatz da DB noch nicht vorhanden
  return {};
}

async function getUser() {
  // Testdatensatz da DB noch nicht vorhanden
  return [{}, {}];
}

async function registerUser(mail, passwort, rolleId) {
  if ((await mailExists(mail)).length > 0) {
    return { error: "User schon vorhanden" };
  }

  // passwort hashen mit salt
  const passwortHashed = await bcrypt.hash(passwort, 10);

  const queryUser = `INSERT INTO User(mail, passwort, rolleId) VALUES(?,?,?)`;

  let results = await conn
    .query(queryUser, [mail, passwortHashed, rolleId])
    .catch((_error) => {
      console.log(_error);
      return { error: _error };
    });

  if (results.length > 0) {
    return results[0];
  } else {
    return { error: "User nicht vorhanden" };
  }
}

async function logLogintoDB(mail) {
  const query = `UPDATE User u SET u.lastLogin_ts = NOW() WHERE u.mail = ?`;

  let results = await conn.query(query, [mail]).catch((error) => {
    console.log(error);
    return { error: "Fehler bei Db" };
  });

  if (results.length > 0) {
    return results[0];
  } else {
    return { error: "User nicht vorhanden" };
  }
}

async function saveProfilbildIdToUser(userId, pofilbildId) {
  const query = `UPDATE User u SET u.pofilbildId = ? WHERE u.id = ?`;

  let results = await conn
    .query(query, [pofilbildId, userId])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });

  if (results.length > 0) {
    return results[0];
  } else {
    return { error: "User nicht vorhanden" };
  }
}

async function getUserInfo(id, mail) {
  let results;
  if (mail) {
    const query = `SELECT u.id, u.mail, u.erstellt_ts, p.plz, r.name AS rolle, f.pfad AS profilbild, u.umkreisEinstellung, u.baldEinstellung  
    FROM User u
    INNER JOIN Rolle r ON u.rolleId = r.id
    INNER JOIN PLZ p ON u.plzId = p.id
    LEFT OUTER JOIN File f ON u.pofilbildId = f.id 
    WHERE u.id = ? and u.mail = ? limit 1`;

    results = await conn.query(query, [id, mail]).catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
    if (results) {
      results = results[0];
    } else {
      return { error: "Fehler bei Db" };
    }
  } else {
    const query = `SELECT u.id, u.mail, u.erstellt_ts, p.plz, r.name AS rolle, f.pfad AS profilbild, u.umkreisEinstellung, u.baldEinstellung  
    FROM User u
    INNER JOIN Rolle r ON u.rolleId = r.id
    INNER JOIN PLZ p ON u.plzId = p.id
    LEFT OUTER JOIN File f ON u.pofilbildId = f.id 
    WHERE u.id = ? limit 1`;

    results = await conn.query(query, [id]).catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
    if (results) {
      results = results[0];
    } else {
      return { error: "Fehler bei Db" };
    }
  }

  if (results.length > 0) {
    return results[0];
  } else {
    return { error: "User nicht vorhanden oder falscher Token" };
  }
}

async function saveRefreshToken(token) {
  const query = `INSERT INTO JwtRefreshToken(token) VALUES(?)`;

  let results = await conn.query(query, [token]).catch((_error) => {
    console.log(_error);
    return { error: _error };
  });

  if (results) {
    return results[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function deleteRefreshToken(token) {
  const query = `DELETE FROM JwtRefreshToken j WHERE j.token = ?`;

  let results = await conn.query(query, [token]).catch((_error) => {
    console.log(_error);
    return { error: _error };
  });

  if (results) {
    return results[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function existRefreshToken(token) {
  const query = `SELECT * FROM JwtRefreshToken j WHERE j.token = ?`;

  let results = await conn.query(query, [token]).catch((_error) => {
    console.log(_error);
    return { error: "Fehler bei Db" };
  });

  if (results) {
    results = results[0];
  } else {
    return { error: "Fehler bei Db" };
  }

  if (results && results.length > 0) {
    return true;
  } else {
    return false;
  }
}

async function userExists(mail, passwort) {
  const query = `SELECT u.id, u.mail, u.passwort, u.erstellt_ts FROM User u WHERE u.mail = ?`;
  let result = {};
  let results = await conn.query(query, [mail]).catch((error) => {
    console.log(error);
    return { error: "Fehler bei Db" };
  });

  if (!results) {
    return { error: "Fehler bei Db" };
  } else {
    results = results[0];
  }

  if (results.length > 0) {
    result = results[0];
    const validPasswort = await bcrypt.compare(passwort, result.passwort);
    console.log("Passwort valide: " + validPasswort);
    if (validPasswort) {
      return result;
    } else {
      return { error: "Passwort nicht korrekt" };
    }
  } else {
    return { error: "User nicht vorhanden" };
  }
}

async function mailExists(mail) {
  const query = `SELECT u.mail, u.erstellt_ts FROM User u WHERE u.mail = ?`;

  let results = await conn.query(query, [mail]).catch((error) => {
    console.log(error);
    return { error: "Fehler bei Db" };
  });

  if (results) {
    return results[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function favoritVeranstaltung(userId, veranstaltungId) {
  const query = `INSERT INTO Favorit(veranstaltungId, userId) VALUES(?, ?) ON DUPLICATE KEY UPDATE valide = IF(valide=1, 0, 1)`;

  let results = await conn
    .query(query, [veranstaltungId, userId])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler in Db" };
    });

  if (results) {
    return results[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function addUserToInstitut(userId, institutionId) {
  const query = `INSERT INTO MitgliedUserInstitution(userId, institutionId) VALUES(?, ?) ON DUPLICATE KEY UPDATE userId=userId`;

  let results = await conn
    .query(query, [userId, institutionId])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler in Db" };
    });

  if (results) {
    return results[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function getInstitutionenFromUser(userId) {
  const query = `SELECT i.id, i.name, i.beschreibung FROM MitgliedUserInstitution m 
  INNER JOIN Institution i ON m.institutionId = i.id 
  WHERE istGenehmigt = 1 AND m.userId = ?`;

  let results = await conn
    .query(query, [userId])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler in Db" };
    });

  if (results) {
    return results[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function isUserBetreiber(userId) {
  const query = `SELECT * FROM User u 
  INNER JOIN Rolle r ON u.rolleId = r.id AND r.id = 3
  WHERE u.id = ?
  `;

  let results = await conn.query(query, [Number(userId)]).catch((error) => {
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

async function isUserGenehmiger(userId) {
  const query = `SELECT * FROM User u 
  INNER JOIN Rolle r ON u.rolleId = r.id AND r.id = 2
  WHERE u.id = ?
  `;

  let results = await conn.query(query, [Number(userId)]).catch((error) => {
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

async function updateUserEinstellungen(
  userId,
  umkreisEinstellung,
  baldEinstellung
) {
  if (!umkreisEinstellung) {
    umkreisEinstellung = -1;
  }
  if (!baldEinstellung) {
    baldEinstellung = -1;
  }

  const query = `UPDATE User u SET u.umkreisEinstellung = IF(? > 0, ?, u.umkreisEinstellung), u.baldEinstellung = IF(? > 0, ?, u.baldEinstellung)
  WHERE u.id = ?`;

  let results = await conn
    .query(query, [
      Number(umkreisEinstellung),
      Number(umkreisEinstellung),
      Number(baldEinstellung),
      Number(baldEinstellung),
      Number(userId),
    ])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler in Db" };
    });

  if (results) {
    return results[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function updateUserRolle(userId, rolleId, userIdBetreiber) {
  // UserRollen: 1=User 2=Gehnemiger 3=Betreiber
  const query = `UPDATE User u SET u.rolleId = ? WHERE u.id = ?`;
  const queryIstBetreiber = `SELECT * FROM User u 
  INNER JOIN Rolle r ON u.rolleId = r.id AND r.id = 3
  WHERE u.id = ?`;

  let results = await conn
    .query(queryIstBetreiber, [Number(userIdBetreiber)])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler in Db" };
    });

  if (results) {
    results = results[0];
    // User ist kein Betreiber und kann somit niemanden Rechte für Gehnemiger oder Betreiber geben
    if (results.length < 1) {
      return {
        error: "User hat nicht die nötigen Rechte, um Rolle zu vergeben",
      };
    }
  }

  results = await conn
    .query(query, [Number(rolleId), Number(userId)])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler in Db" };
    });

  if (results) {
    return results[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function updateUserInformation(id, mail, vorname, nachname, plz, tel) {
  // Falls noch keine ID für PLZ angelegt
  if (plz) {
    const queryPlz = `INSERT INTO PLZ(PLZ.plz) VALUES(?) ON DUPLICATE KEY UPDATE PLZ.plz = PLZ.plz;`;
    await conn.query(queryPlz, [plz]).catch((error) => {
      console.log(error);
      return { error: "Fehler in DB" };
    });
  }

  const query = `UPDATE User u SET u.vorname = IF(1=?, u.vorname, ?), 
  u.nachname = IF(1=?, u.nachname, ?), u.tel = IF(1=?, u.tel, ?), u.plzId = IF(1=?, u.plzId, (SELECT PLZ.id FROM PLZ WHERE PLZ.plz = ?))
  WHERE id = ? and mail = ?`;

  let results = await conn
    .query(query, [
      vorname ? 0 : 1,
      vorname,
      nachname ? 0 : 1,
      nachname,
      tel ? 0 : 1,
      tel,
      plz ? 0 : 1,
      plz ? plz : "00000",
      id,
      mail,
    ])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler in DB" };
    });

  if (results) {
    return results[0];
  } else {
    return { error: "Fehler bei Db" };
  }
}

module.exports = {
  getuserById: getuserById,
  getUser: getUser,
  registerUser: registerUser,
  userExists: userExists,
  saveRefreshToken: saveRefreshToken,
  existRefreshToken: existRefreshToken,
  deleteRefreshToken: deleteRefreshToken,
  logLogintoDB: logLogintoDB,
  saveProfilbildIdToUser: saveProfilbildIdToUser,
  getUserInfo: getUserInfo,
  updateUserInformation: updateUserInformation,
  favoritVeranstaltung: favoritVeranstaltung,
  updateUserEinstellungen: updateUserEinstellungen,
  updateUserRolle: updateUserRolle,
  addUserToInstitut: addUserToInstitut,
  isUserBetreiber: isUserBetreiber,
  getInstitutionenFromUser: getInstitutionenFromUser,
  isUserGenehmiger: isUserGenehmiger
};
