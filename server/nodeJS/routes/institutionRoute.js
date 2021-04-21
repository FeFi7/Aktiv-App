var institutionService = require("../services/institutionService")
var express = require('express');
var router = express.Router();

// [GET] bekomme einzelne institution
router.get('/:institutionId', async function (req, res) {
  let institutionId = req.params.institutionId;
  // ist query eine Zahl?
  if (! /^\d+$/.test(req.params.institutionId)) {
    return res.status(400).send("institutionId ist keine Zahl");
  }
  const result = await institutionService.getInstitutionById(institutionId);
  if (result.error) {
    res.status(400).json(result);
  } else {
    res.status(200).json(result);
  }
});


// [POST] Erstelle eine institution (mit Fabi gecoded)
router.post('/*', async function (req, res) {

  let body = req.body;

  if (!body.name) {
    return res.status(400).send({ error: "Name nicht vorhanden" });
  }
  if (!body.beschreibung) {
    return res.status(400).send({ error: "Beschreibung nicht vorhanden" });
  }

  const result = await institutionService.erstelleInstitution(
    body.name,
    body.beschreibung
  );

  if (result.error) {
    return res.status(400).send(result);
  } else {
    return res.send(result);
  }

});

// [PUT] update einzelne institution
router.put('/:institutionId', async function (req, res) {
  let institutionId = req.params.institutionId;
    // ist query eine Zahl?
    if (! /^\d+$/.test(req.params.institutionId)) {
      return res.status(400).send("institutionId ist keine Zahl");
    }
  let body = req.body;
  if (!body.name) {
    return res.status(400).send({ error: "Name nicht vorhanden" });
  }
  if (!body.beschreibung) {
    return res.status(400).send({ error: "Beschreibung nicht vorhanden" });
  }

  const result = await institutionService.updateInstitutionById(
    body.name,
    body.beschreibung
  );

  if (result.error) {
    return res.status(400).send(result);
  } else {
    return res.send(result);
  }
});

// [DELETE] lösche einzelne institution
router.delete('/:institutionId', async function (req, res) {

  res.json(institutionService.getinstitutionById(req.params.institutionId));
});







module.exports = router;