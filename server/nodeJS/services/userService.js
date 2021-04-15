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

  const result = (
    await conn
      .query(queryUser, [mail, passwortHashed, rolleId])
      .catch((_error) => {
        console.log(_error);
        return { error: _error };
      })
  )[0];

  return result;
}

async function logLogintoDB(mail) {
  const query = `UPDATE User u SET u.lastLogin_ts = NOW() WHERE u.mail = ?`;

  const results = (
    await conn.query(query, [mail]).catch((error) => {
      console.log(error);
      return null;
    })
  )[0];

  return results;
}

async function saveProfilbildIdToUser(userId, pofilbildId) {
  const query = `UPDATE User u SET u.pofilbildId = ? WHERE u.id = ?`;

  const results = (
    await conn.query(query, [pofilbildId, userId]).catch((error) => {
      console.log(error);
      return null;
    })
  )[0];

  return results;
}

async function getUserInfo(id, mail) {
  let results;
  if (mail) {
    const query = `SELECT u.id, u.mail, u.erstellt_ts, p.plz, r.name AS rolle, f.pfad AS profilbild FROM User u
    INNER JOIN Rolle r ON u.rolleId = r.id
    INNER JOIN PLZ p ON u.plzId = p.id
    LEFT OUTER JOIN File f ON u.pofilbildId = f.id 
    WHERE u.id = ? and u.mail = ? limit 1`;

    results = (
      await conn.query(query, [id, mail]).catch((error) => {
        console.log(error);
        return { error: "Fehler bei Db" };
      })
    )[0];
  } else {
    const query = `SELECT u.id, u.mail, u.erstellt_ts, p.plz, r.name AS rolle, f.pfad AS profilbild FROM User u
    INNER JOIN Rolle r ON u.rolleId = r.id
    INNER JOIN PLZ p ON u.plzId = p.id
    LEFT OUTER JOIN File f ON u.pofilbildId = f.id 
    WHERE u.id = ? limit 1`;

    results = (
      await conn.query(query, [id]).catch((error) => {
        console.log(error);
        return { error: "Fehler bei Db" };
      })
    )[0];
  }

  if (results.length > 0) {
    return results[0];
  } else {
    return { error: "User nicht vorhanden" };
  }
}

async function saveRefreshToken(token) {
  const query = `INSERT INTO JwtRefreshToken(token) VALUES(?)`;

  const results = (
    await conn.query(query, [token]).catch((_error) => {
      console.log(_error);
      return { error: _error };
    })
  )[0];

  return results;
}

async function deleteRefreshToken(token) {
  const query = `DELETE FROM JwtRefreshToken j WHERE j.token = ?`;

  const results = (
    await conn.query(query, [token]).catch((_error) => {
      console.log(_error);
      return { error: _error };
    })
  )[0];

  return results;
}

async function existRefreshToken(token) {
  const query = `SELECT * FROM JwtRefreshToken j WHERE j.token = ?`;

  const results = (
    await conn.query(query, [token]).catch((_error) => {
      console.log(_error);
      return false;
    })
  )[0];

  if (results && results.length > 0) {
    return true;
  } else {
    return false;
  }
}

async function userExists(mail, passwort) {
  const query = `SELECT u.id, u.mail, u.passwort, u.erstellt_ts FROM User u WHERE u.mail = ?`;
  const results = (
    await conn.query(query, [mail]).catch((error) => {
      console.log(error);
      return null;
    })
  )[0];

  if (results.length > 0) {
    const validPasswort = await bcrypt.compare(passwort, results[0].passwort);
    console.log("Passwort valide: " + validPasswort)
    if (validPasswort) {
      return results[0];
    } else {
      return { error: "Passwort nicht korrekt" };
    }
  } else {
    return { error: "User nicht vorhanden" };
  }
}

async function mailExists(mail) {
  const query = `SELECT u.mail, u.erstellt_ts FROM User u WHERE u.mail = ?`;

  const results = (
    await conn.query(query, [mail]).catch((error) => {
      console.log(error);
      return null;
    })
  )[0];

  return results;
}

async function favoritVeranstaltung(userId, veranstaltungId) {
  const query = `INSERT INTO Favorit(veranstaltungId, userId) VALUES(?, ?) ON DUPLICATE KEY UPDATE valide = IF(valide=1, 0, 1)`;

  const results = (
    await conn.query(query, [veranstaltungId, userId]).catch((error) => {
      console.log(error);
      return {error: "Fehler in Db"};
    })
  )[0];

  return results;
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

  const results = (
    await conn
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
      })
  )[0];

  return results;
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
  favoritVeranstaltung: favoritVeranstaltung
};
