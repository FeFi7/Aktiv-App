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

async function registerUser(mail, passwort, plz, rolleId) {
  if ((await userExists(mail)).length > 0) {
    return { error: "User schon vorhanden" };
  }

  // passwort hashen mit salt
  //const salt = await bcrypt.genSalt(10);
  const passwortHashed = await bcrypt.hash(passwort, 10);

  const queryPlz = `INSERT INTO PLZ(PLZ.plz) VALUES(?) ON DUPLICATE KEY UPDATE PLZ.plz = PLZ.plz;`;
  const queryUser = `INSERT INTO User(mail, passwort, rolleId, plzId) VALUES(?,?,?, (SELECT id FROM PLZ WHERE PLZ.plz = ?))`;

  await conn.query(queryPlz, [plz]).catch((_error) => {
    console.log(_error);
    return {error: _error};
  })

  const result = (
    await conn.query(queryUser, [mail, passwortHashed, rolleId, plz]).catch((_error) => {
      console.log(_error);
      return {error: _error};
    })
  )[0];

  return result;
}

async function userExists(mail) {
  const query = `SELECT u.mail, u.erstellt_ts FROM User u WHERE u.mail = ?`;

  const results = (
    await conn.query(query, [mail]).catch((error) => {
      console.log(error);
      return null;
    })
  )[0];

  return results;
}

async function saveRefreshToken(token) {
  const query = `INSERT INTO JwtRefreshToken(token) VALUES(?)`;

  const results = (
    await conn.query(query, [token]).catch((_error) => {
      console.log(_error);
      return {error: _error};
    })
  )[0];

  return results;
}

async function deleteRefreshToken(token) {
  const query = `DELETE FROM JwtRefreshToken j WHERE j.token = ?`;

  const results = (
    await conn.query(query, [token]).catch((_error) => {
      console.log(_error);
      return {error: _error};
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

  if(results.length > 0){
    return true;
  }
  else{
    return false;
  }

}

async function userExists(mail, passwort) {
  const query = `SELECT u.mail, u.passwort, u.erstellt_ts FROM User u WHERE u.mail = ?`;

  const results = (
    await conn.query(query, [mail]).catch((error) => {
      console.log(error);
      return null;
    })
  )[0];

  if(results.length > 0){
    const validPasswort = await bcrypt.compare(passwort, results[0].passwort);

    if(validPasswort){
      return results[0];
    }
    else{
      return {error: "Passwort nicht korrekt"}
    }
  }
  else{
    return {error: "User nicht vorhanden"}
  }

}

module.exports = {
  getuserById: getuserById,
  getUser: getUser,
  registerUser: registerUser,
  userExists: userExists,
  saveRefreshToken: saveRefreshToken,
  existRefreshToken: existRefreshToken,
  deleteRefreshToken: deleteRefreshToken
};
