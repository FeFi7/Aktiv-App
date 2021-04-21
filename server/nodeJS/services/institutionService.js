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



  async function getInstitutionById(institutionsId){
     const query = `SELECT i.id, i.name, i.beschreibung, i.istGenehmigt, f.pfad AS institutionBild  FROM Institution i LEFT OUTER JOIN File f ON i.imageId=f.id  WHERE i.id = ?`;

    let result =  (await conn.query(query, [Number(institutionsId)]).catch(error => {console.log(error); return { error: "Fehler bei Db" };}))
    if(result){
        return result[0]
    }
    else{
        return { error: "Fehler bei Db" };
    }
}

async function updateInstitutionById(institutionsId){
  const query = `UPDATE Institution  `;

 let result =  (await conn.query(query, [Number(institutionsId)]).catch(error => {console.log(error); return { error: "Fehler bei Db" };}))
 if(result){
     return result[0]
 }
 else{
     return { error: "Fehler bei Db" };
 }
}









  
module.exports = {
    getInstitutionById: getInstitutionById,
    erstelleInstitution: erstelleInstitution
}
