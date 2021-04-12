const express = require('express');
const router = express.Router();
const fileUploadService = require('../services/fileUploadService')

// [POST] Hinterlege neue Datei
router.post('/*',  fileUploadService.upload.single('file'), async function(req, res){
  try {
    if (req.file == undefined) {
      return res.status(400).send({ error: "Kein datei gefunden" });
    }
    
    const result = await fileUploadService.createFileInDb(req.file.filename, req.file.mimetype);

    if(result.error){
      return res.status(400).send(result)
    }
    else{
      return res.status(200).send(result)
    }
  } catch (err) {
    console.log(err);

    if (err.code == "LIMIT_FILE_SIZE") {
      return res.status(500).send({
        message: "Datei muss kleiner als 5MB sein",
      });
    }

    res.status(500).send({
      error: `${err}`,
    });
  } 
});
  
module.exports = router;