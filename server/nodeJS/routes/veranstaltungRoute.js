var veranstaltungService = require("../services/veranstaltungService");
var userService = require("../services/userService");
var express = require("express");
var router = express.Router();
const passport = require("passport");

// [GET] bekomme tags (optional gefiltert)
router.get("/tags", async function (req, res) {
  const tag = req.query.tag;

  const results = await veranstaltungService.getTagsFiltered(tag);

  if (results.error) {
    return res.status(400).json(results);
  } else {
    return res.status(200).json(results);
  }
});

// [GET] bekomme einzelne Veranstaltung
router.get("/:veranstaltungId", async function (req, res) {
  const veranstaltungId = req.params.veranstaltungId;
  // ist query eine Zahl?
  if (!/^\d+$/.test(veranstaltungId)) {
    return res.status(400).send("Id keine Zahl");
  }

  let veranstaltung = await veranstaltungService.getVeranstaltungById(
    req.params.veranstaltungId
  );

  if (veranstaltung.error) {
    return res.status(400).json(veranstaltung);
  }
  if (veranstaltung.length === 0) {
    return res.status(404).json(veranstaltung);
  } else {
    veranstaltung = veranstaltung[0];
  }

  const veranstaltungFiles = await veranstaltungService.getVeranstaltungFilesById(
    req.params.veranstaltungId
  );
  if (veranstaltungFiles.error) {
    return res.status(400).json(veranstaltungFiles);
  }

  const veranstaltungTags = await veranstaltungService.getTagsToVeranstaltung(req.params.veranstaltungId)
  if (veranstaltungTags.error) {
    return res.status(400).json(veranstaltungTags);
  }

  veranstaltung.files = veranstaltungFiles;
  veranstaltung.tags = veranstaltungTags;
  return res.status(200).json(veranstaltung);
});

// [DELETE] lösche einzelne Veranstaltung
router.delete(
  "/:veranstaltungId",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.user._id;
    const veranstaltungId = req.params.veranstaltungId;
    // ist query eine Zahl?
    if (!/^\d+$/.test(veranstaltungId)) {
      return res.status(400).send("Id keine Zahl");
    }

    // Ist User Betreiber oder Ersteller?
    const resultIsUserErsteller = await veranstaltungService.isUserVeranstaltungErsteller(
      veranstaltungId,
      userId
    );
    if (resultIsUserErsteller.error || !resultIsUserErsteller) {
      const resultIsUserBetreiber = await userService.isUserBetreiber(userId);
      if (resultIsUserBetreiber.error || !resultIsUserBetreiber) {
        const resultIsUserGenehmiger = await userService.isUserGenehmiger(
          userId
        );
        if (resultIsUserGenehmiger.error || !resultIsUserGenehmiger) {
          return res.status(400).json({
            error: "Nur Ersteller, Betreiber und Genehmiger können Veranstaltungen löschen",
          });
        }
      }
    }

    const result = await veranstaltungService.deleteVeranstaltung(
      veranstaltungId
    );

    if (result.error) {
      return res.status(400).send(result);
    } else {
      return res.send(result);
    }
  }
);

// [POST] genehmige einzelne Veranstaltung
router.post(
  "/:veranstaltungId/genehmigen",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.user._id;
    const veranstaltungId = req.params.veranstaltungId;
    // ist query eine Zahl?
    if (!/^\d+$/.test(veranstaltungId)) {
      return res.status(400).send("Id keine Zahl");
    }

    // Ist User Betreiber oder Genehmiger?
    const resultIsUserGenehmiger = await userService.isUserGenehmiger(userId);
    if (resultIsUserGenehmiger.error || !resultIsUserGenehmiger) {
      const resultIsUserBetreiber = await userService.isUserBetreiber(userId);
      if (resultIsUserBetreiber.error || !resultIsUserBetreiber) {
        return res.status(400).json({
          error:
            "Nur Genehmiger und Betreiber können Veranstaltungen genehmigen",
        });
      }
    }

    const result = await veranstaltungService.genehmigeVeranstaltung(
      veranstaltungId
    );

    if (result.error) {
      return res.status(400).send(result);
    } else {
      return res.send(result);
    }
  }
);

// [GET] bekomme alle Veranstaltung
router.get("/*", async function (req, res) {
  const latitudeUlm = 48.39962;
  const longitudeUlm = 9.99661;
  const sortsErlaubt = ["beginn_ts", "entfernung"];

  const query = req.query;
  let page = query.page;
  let bis = query.bis;
  let istGenehmigt = query.istGenehmigt;
  let limit = query.limit;
  let userId = query.userId;
  let vollText = query.vollText;
  let datum = query.datum;
  let entfernung = query.entfernung;
  let latitude = query.latitude;
  let longitude = query.longitude;
  let sorting = query.sorting;
  let plz = query.plz;

  if (limit) {
    // ist query eine Zahl?
    if (!(/^\d+$/.test(limit) && limit < 100)) {
      limit = 25;
    }
  } else {
    limit = 25;
  }
  if (page) {
    if (!/^\d+$/.test(page)) {
      page = 1;
    }
  } else {
    page = 1;
  }
  // falls keine entfernung mitgegeben, 100km standard
  if (entfernung) {
    if (!/^\d+$/.test(entfernung)) {
      entfernung = 100;
    }
  } else {
    entfernung = 100;
  }
  if (latitude) {
    if (!/^[+-]?\d+(\.\d+)?$/.test(latitude)) {
      latitude = latitudeUlm;
    }
  } else {
    latitude = latitudeUlm;
  }
  if (longitude) {
    if (!/^[+-]?\d+(\.\d+)?$/.test(longitude)) {
      longitude = longitudeUlm;
    }
  } else {
    longitude = longitudeUlm;
  }
  // falls keine userId mitgegeben Wert 0 und es wird in der Funktion nicht beachtet
  if (userId) {
    if (!/^\d+$/.test(userId)) {
      userId = 0;
    }
  } else {
    userId = 0;
  }
  if (plz) {
    if (!/^\d+$/.test(plz)) {
      return res.status(400).json({ error: "Keine passende plz" });
    }
  }
  if (!istGenehmigt) {
    istGenehmigt = 1;
  }
  if (!sorting) {
    sorting = sortsErlaubt[0];
  } else {
    if (!sortsErlaubt.includes(sorting)) {
      sorting = sortsErlaubt[0];
    }
  }
  if (!bis) {
    const dt = new Date();
    bis = `${(dt.getFullYear()+2).toString().padStart(4, "0")}-${(dt.getMonth())
      .toString()
      .padStart(2, "0")}-${dt
      .getDate()
      .toString()
      .padStart(2, "0")} ${dt
      .getHours()
      .toString()
      .padStart(2, "0")}:${dt
      .getMinutes()
      .toString()
      .padStart(2, "0")}:${dt.getSeconds().toString().padStart(2, "0")}`;
  }

  const veranstaltungen = await veranstaltungService.getVeranstaltungen(
    limit,
    istGenehmigt,
    bis,
    userId,
    page,
    vollText,
    datum,
    latitude,
    longitude,
    entfernung,
    sorting,
    plz
  );

  if (veranstaltungen.error) {
    res.status(400).json(veranstaltungen);
  } else {
    res.status(200).json(veranstaltungen);
  }
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
  let fileIds = req.body.fileIds;
  let tags = req.body.tags;
  let plz = req.body.plz;

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
  if (!plz) {
    return res.status(400).send({ error: "plz benötigt" });
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
    return res.status(400).send({ error: "longitude benötigt" });
  }
  if (institutionId) {
    // ist numerisch?
    if (!/^-?\d+\.?\d*$/.test(institutionId)) {
      return res
        .status(400)
        .send({ error: "institutionId muss numerisch sein" });
    }
  } else {
    institutionId = 0;
  }
  if (userId) {
    // ist numerisch?
    if (!/^-?\d+\.?\d*$/.test(userId)) {
      return res.status(400).send({ error: "userId muss numerisch sein" });
    }
  } else {
    return res.status(400).send({ error: "userId benötigt" });
  }
  if (!istGenehmigt) {
    istGenehmigt = 0;
  }
  if (fileIds) {
    try {
      fileIds = JSON.parse(fileIds);
    } catch (e) {
      console.log("Fehler bei Parsung FileIds");
      return res
        .status(400)
        .json({ error: "fileIds werden nicht als Array übergeben" });
    }
    if (!Array.isArray(fileIds)) {
      return res
        .status(400)
        .json({ error: "fileIds werden nicht als Array übergeben" });
    }
  }
  if (tags) {
    try {
      tags = JSON.parse(tags);
    } catch (e) {
      console.log("Fehler bei Parsung tags");
      return res
        .status(400)
        .json({ error: "tags werden nicht als Array übergeben" });
    }
    if (!Array.isArray(tags)) {
      return res
        .status(400)
        .json({ error: "tags werden nicht als Array übergeben" });
    }
  }
  //-------------------------Überprüfung Parameter---------------------------
  const veranstaltungen = await veranstaltungService.createVeranstaltung(
    titel,
    beschreibung,
    kontakt,
    plz,
    beginn_ts,
    ende_ts,
    ortBeschreibung,
    latitude,
    longitude,
    institutionId,
    userId,
    istGenehmigt
  );

  if (veranstaltungen.error) {
    return res.status(400).json(veranstaltungen);
  }

  if (fileIds) {
    const veranstaltungenFileIds = await veranstaltungService.addFileIdsToVeranstaltung(
      veranstaltungen.insertId,
      fileIds
    );

    if (veranstaltungenFileIds.error) {
      return res.status(400).json(veranstaltungenFileIds);
    }
  }
  if (tags) {
    const veranstaltungTags = await veranstaltungService.addTagsToVeranstaltung(
      veranstaltungen.insertId,
      tags
    );

    if (veranstaltungTags.error) {
      return res.status(400).json(veranstaltungTags);
    }
  }

  return res.status(200).json(veranstaltungen);
});

module.exports = router;
