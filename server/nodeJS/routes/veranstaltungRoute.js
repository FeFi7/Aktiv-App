var veranstaltungService = require("../services/veranstaltungService");
var express = require("express");
var router = express.Router();
const passport = require('passport');

// [GET] bekomme einzelne Veranstaltung
router.get("/:veranstaltungId", async function (req, res) {
  const veranstaltungId = req.params.veranstaltungId;
  // ist query eine Zahl?
  if (!/^\d+$/.test(veranstaltungId)) {
    return res.status(400).send("Id keine Zahl");
  }

  const veranstaltung = await veranstaltungService.getVeranstaltungById(
    req.params.veranstaltungId
  );
  if (veranstaltung) {
    return res.json(
      await veranstaltungService.getVeranstaltungById(
        req.params.veranstaltungId
      )
    );
  } else {
    return res.status(404).send("Veranstaltung nicht vorhanden");
  }
});

// [PUT] update einzelne Veranstaltung
router.put("/:veranstaltungId", async function (req, res) {
  const veranstaltungId = req.params.veranstaltungId;
  // ist query eine Zahl?
  if (!/^\d+$/.test(veranstaltungId)) {
    return res.status(400).send("Id keine Zahl");
  }

  if (veranstaltungService.getVeranstaltungById(veranstaltungId) === null) {
    return res.status(404).send("Veranstaltung nicht vorhanden");
  }

  res.json(veranstaltungService.getVeranstaltungById(veranstaltungId));
});

// [DELETE] lösche einzelne Veranstaltung
router.delete("/:veranstaltungId", async function (req, res) {
  return res.json(
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

  return res.send(veranstaltungen);
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
    return res.status(400).send({ error: "titel benötigt" });
  }
  if (!beschreibung) {
    return res.status(400).send({ error: "beschreibung benötigt" });
  }
  if (!kontakt) {
    return res.status(400).send({ error: "kontakt benötigt" });
  }
  if (!beginn_ts) {
    return res.status(400).send({ error: "beginn_ts benötigt" });
  }
  if (!ende_ts) {
    return res.status(400).send({ error: "ende_ts benötigt" });
  }
  if (!ortBeschreibung) {
    return res.status(400).send({ error: "ortBeschreibung benötigt" });
  }
  if (latitude) {
    // ist numerisch?
    if (!/^-?\d+\.?\d*$/.test(latitude)) {
      return res.status(400).send({ error: "latitude muss numerisch sein" });
    }
  } else {
    return res.status(400).send({ error: "latitude benötigt" });
  }
  if (longitude) {
    // ist numerisch?
    if (!/^-?\d+\.?\d*$/.test(longitude)) {
      return res.status(400).send({ error: "longitude muss numerisch sein" });
    }
  } else {
    return res.status(400).send({ error: "longitude benötigt"});
  }
  if (institutionId) {
    // ist numerisch?
    if (!/^-?\d+\.?\d*$/.test(institutionId)) {
      return res.status(400).send({ error: "institutionId muss numerisch sein" });
    }
  } else {
    return res.status(400).send({ error: "institutionId benötigt"});
  }
  if (userId) {
    // ist numerisch?
    if (!/^-?\d+\.?\d*$/.test(userId)) {
      return res.status(400).send({ error: "userId muss numerisch sein"});
    }
  } else {
    return res.status(400).send({ error: "userId benötigt" });
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
