let conn = require("../db").getConnection();

async function createFile(pfad, typ){

    const query = `INSERT INTO File (pfad, typ) VALUES( ?, ?)`

    const params = [pfad, typ];

    const result = (await conn.query(query, params).catch(error => {console.log(error); return null;}))[0]

    return result; 
}


module.exports = {
    createFile: createFile
}