let conn = require("../db").getConnection();
const multer = require("multer");

var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    if (file.mimetype == "image/jpeg") {
      cb(null, "/uploads/images");
    } else if (file.mimetype == "image/png") {
      cb(null, "/uploads/images");
    } else if (file.mimetype == "application/pdf") {
      cb(null, "/uploads/flyer");
    } else {
      console.log(file.mimetype);
      cb({ error: "File types allowed .jpeg, .jpg .png and .pdf!" });
    }
  },
  filename: function (req, file, cb) {
    var datetimestamp = Date.now();
    var name =
      datetimestamp +
      "-" +
      file.originalname.toLowerCase().split(" ").join("-");
    cb(null, name);
  },
});

var upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 5,
  },
});

async function createFileInDb(pfad, typ) {
  const queryInsert = `INSERT INTO File (pfad, typ) VALUES( ?, ?)`;
  const querySelect = `SELECT * FROM File f WHERE f.id = ?`;

  const params = [pfad, typ];

  const resultInsert = (
    await conn.query(queryInsert, params).catch((error) => {
      console.log(error);
      return {error: "Fehler in der Db aufgetreten"};
    })
  )[0];

  const resultSelectInserted = (
    await conn.query(querySelect, resultInsert.insertId).catch((error) => {
      console.log(error);
      return {error: "Fehler in der Db aufgetreten"};
    })
  )[0];

  return resultSelectInserted[0];
}



module.exports = {
  createFileInDb: createFileInDb,
  upload: upload,
};
