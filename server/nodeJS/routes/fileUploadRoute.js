//var fileUploadService = require("../services/fileUploadService")
var express = require('express');
var router = express.Router();
var multer = require('multer');

var storage = multer.diskStorage({
  destination: function (req, file, cb) {
      if(file.mimetype == 'image/jpeg'){
          cb(null, '/uploads/images')
      } else if(file.mimetype == 'image/png'){
          cb(null, '/uploads/images')
      } else if(file.mimetype == 'application/pdf'){
          cb(null, '/uploads/flyer')
      } else {
          console.log(file.mimetype)
          cb({ error: 'File types allowed .jpeg, .jpg .png and .pdf!'})
      }
  },
  filename: function (req, file, cb){
      var datetimestamp = Date.now();
      var name = datetimestamp + "-" + file.originalname.toLowerCase().split(' ').join("-");
      cb(null, name);
  }
});

var upload = multer({
  storage: storage,
  limits: {
      fileSize: 1024 * 1024 * 5
  }
});

router.use(function timeLog(req, res, next) {
    console.log(req.headers.host + " Time: ", new Date().toISOString());
    next();
});

// [POST] Hinterlege neue Datei
router.post('/*', upload.single('file'), (req, res) => {
  try {
    if (req.file == undefined) {
      return res.status(400).send({ message: "Choose a file to upload" });
    }

    res.status(200).send({
      message: "File uploaded successfully: " + req.file.originalname,
    });
  } catch (err) {
    console.log(err);

    if (err.code == "LIMIT_FILE_SIZE") {
      return res.status(500).send({
        message: "File size should be less than 5MB",
      });
    }

    res.status(500).send({
      message: `Error occured: ${err}`,
    });
  } 
});
  
module.exports = router;