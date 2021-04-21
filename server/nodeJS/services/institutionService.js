let conn = require("../db").getConnection();

async function erstelleInstitution(name, beschreibung) {
  //  if ((await mailExists(mail)).length > 0) {
  //    return { error: "User schon vorhanden" };
  // }

  const query = `INSERT INTO Institution(name,beschreibung) VALUES (?,?)`;

  let results = await conn
    .query(query, [name, beschreibung])
    .catch((_error) => {
      console.log(_error);
      return { error: _error };
    });

  if (results.length > 0) {
    return results[0];
  } else {
    return { error: "Institution nicht vorhanden" };
  }
}

async function getInstitutionById(institutionsId) {
  const query = `SELECT i.id, i.name, i.beschreibung, i.istGenehmigt, f.pfad AS institutionBild  FROM Institution i LEFT OUTER JOIN File f ON i.imageId=f.id  WHERE i.id = ?`;

  let result = await conn
    .query(query, [Number(institutionsId)])
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

async function updateInstitutionById(institutionId, name, beschreibung) {
  const query = `UPDATE Institution i SET i.name = ?, i.beschreibung = ? WHERE i.id = ?`;

  let result = await conn
    .query(query, [name, beschreibung, Number(institutionId)])
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

async function deleteInstitutionById(institutionId) {
  const queryDeleteInstitution = `DELETE FROM Institution i WHERE i.id = ?`;
  const queryDeleteInstitutionVerwaltung = `DELETE FROM MitgliedUserInstitution m WHERE m.institutionId = ?`;

  let resultDeleteInstitution = await conn
    .query(queryDeleteInstitution, [Number(institutionId)])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
  if (!resultDeleteInstitution) {
    return { error: "Fehler bei Db" };
  }

  let resultDeleteInstitutionVerwaltung = await conn
    .query(queryDeleteInstitutionVerwaltung, [Number(institutionId)])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
  if (!resultDeleteInstitutionVerwaltung) {
    return { error: "Fehler bei Db" };
  }

  return resultDeleteInstitution;
}

async function genehmigeInstitution(institutionId) {
  const query = `UPDATE Institution i SET i.istGenehmigt = 1 WHERE i.id = ?`;

  let result = await conn
    .query(query, [Number(institutionId)])
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

async function isUserInInstitution(userId, institutionId) {
  const query = `SELECT * FROM MitgliedUserInstitution m WHERE m.userId = ? AND m.institutionId = ?`;

  let result = await conn
    .query(query, [Number(userId), Number(institutionId)])
    .catch((error) => {
      console.log(error);
      return { error: "Fehler bei Db" };
    });
  if (result) {
    result = result[0];
    if (result.length > 0) {
      return true;
    } else {
      return false;
    }
  } else {
    return { error: "Fehler bei Db" };
  }
}

async function saveProfilbildIdToInstitution(institutionId, pofilbildId) {
  const query = `UPDATE Institution i SET i.imageId = ? WHERE i.id = ?`;

  let results = await conn
    .query(query, [pofilbildId, institutionId])
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

module.exports = {
  getInstitutionById: getInstitutionById,
  erstelleInstitution: erstelleInstitution,
  updateInstitutionById: updateInstitutionById,
  isUserInInstitution: isUserInInstitution,
  genehmigeInstitution: genehmigeInstitution,
  saveProfilbildIdToInstitution: saveProfilbildIdToInstitution,
  deleteInstitutionById: deleteInstitutionById,
};
