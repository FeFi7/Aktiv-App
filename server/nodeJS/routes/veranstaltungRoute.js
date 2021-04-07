var veranstaltungService = require("../services/veranstaltungService");
var express = require("express");
var router = express.Router();

router.use(function timeLog(req, res, next) {
  console.log(req.headers.host + " Time: ", new Date().toISOString());
  next();
});

// [GET] bekomme einzelne Veranstaltung
router.get("/:veranstaltungId", async function (req, res) {
  const veranstaltungId = req.params.veranstaltungId;
  // ist query eine Zahl?
  if (!/^\d+$/.test(veranstaltungId)) {
    res.status(400).send("Id keine Zahl");
  }

  const veranstaltung = await veranstaltungService.getVeranstaltungById(
    req.params.veranstaltungId
  );
  if (veranstaltung) {
    res.json(
      await veranstaltungService.getVeranstaltungById(
        req.params.veranstaltungId
      )
    );
  } else {
    res.status(404).send("Veranstaltung nicht vorhanden");
  }
});

// [PUT] update einzelne Veranstaltung
router.put("/:veranstaltungId", async function (req, res) {
  const veranstaltungId = req.params.veranstaltungId;
  // ist query eine Zahl?
  if (!/^\d+$/.test(veranstaltungId)) {
    res.status(400).send("Id keine Zahl");
  }

  if (veranstaltungService.getVeranstaltungById(veranstaltungId) === null) {
    res.status(404).send("Veranstaltung nicht vorhanden");
  }

  res.json(veranstaltungService.getVeranstaltungById(veranstaltungId));
});

// [DELETE] lösche einzelne Veranstaltung
router.delete("/:veranstaltungId", async function (req, res) {
  res.json(
    veranstaltungService.getVeranstaltungById(req.params.veranstaltungId)
  );
});

// [GET] bekomme alle Veranstaltung
router.get("/*", async function (req, res) {
  const limit = 25;
  const page = 1;

  if (req.query.limit) {
    // ist query eine Zahl?
    if (/^\d+$/.test(req.query.limit) && req.query.limit < 100) {
      limit = req.query.limit;
    }
  }
  if (req.query.page) {
    if (/^\d+$/.test(req.query.page)) {
      page = req.query.page;
    }
  }

  const veranstaltungen = await veranstaltungService.getVeranstaltungen(limit);

  res.send(veranstaltungen);
});

// [POST] Erstelle eine Veranstaltung
router.post("/*", async function (req, res) {
  let titel = req.body.titel;
  let beschreibung = req.body.beschreibung;
  let kontakt = req.body.kontakt;
  let beginn_ts = req.body.beginn_ts;
  let ende_ts = req.body.ende_ts;
  let ortBeschreibung = req.body.ortBeschreibung;
  let latitude = req.body.latitude;
  let longitude = req.body.longitude;
  let institutionId = req.body.institutionId;
  let userId = req.body.userId;
  let istGenehmigt = req.body.istGenehmigt;

  //-------------------------Überprüfung Parameter---------------------------
  if (!titel) {
    res.status(400).send("titel benötigt");
    return;
  }
  if (!beschreibung) {
    res.status(400).send("beschreibung benötigt");
    return;
  }
  if (!kontakt) {
    res.status(400).send("kontakt benötigt");
    return;
  }
  if (!beginn_ts) {
    res.status(400).send("beginn_ts benötigt");
    return;
  }
  if (!ende_ts) {
    res.status(400).send("ende_ts benötigt");
    return;
  }
  if (!ortBeschreibung) {
    res.status(400).send("ortBeschreibung benötigt");
    return;
  }
  if (latitude) {
    // ist numerisch?
    if (!/^-?\d+\.?\d*$/.test(latitude)) {
      res.status(400).send("latitude muss numerisch sein");
      return;
    }
  } else {
    res.status(400).send("latitude benötigt");
    return;
  }
  if (longitude) {
    // ist numerisch?
    if (!/^-?\d+\.?\d*$/.test(longitude)) {
      res.status(400).send("longitude muss numerisch sein");
      return;
    }
  } else {
    res.status(400).send("longitude benötigt");
    return;
  }
  if (institutionId) {
    // ist numerisch?
    if (!/^-?\d+\.?\d*$/.test(institutionId)) {
      res.status(400).send("institutionId muss numerisch sein");
      return;
    }
  } else {
    res.status(400).send("institutionId benötigt");
    return;
  }
  if (userId) {
    // ist numerisch?
    if (!/^-?\d+\.?\d*$/.test(userId)) {
      res.status(400).send("userId muss numerisch sein");
      return;
    }
  } else {
    res.status(400).send("userId benötigt");
    return;
  }
  if (!istGenehmigt) {
    istGenehmigt = 0;
  }
  //-------------------------Überprüfung Parameter---------------------------

  const veranstaltungen = await veranstaltungService.createVeranstaltung(
    titel,
    beschreibung,
    kontakt,
    beginn_ts,
    ende_ts,
    ortBeschreibung,
    latitude,
    longitude,
    institutionId,
    userId,
    istGenehmigt ? 1 : 0
  );

  if (veranstaltungen) {
    res.send(veranstaltungen);
    return;
  } else {
    res.sendStatus(400);
    return;
  }
});

module.exports = router;
