var institutionService = require("../services/institutionService");
var userService = require("../services/userService");
var express = require("express");
var router = express.Router();
const passport = require("passport");
const fileUploadService = require("../services/fileUploadService");

// [GET] bekomme alle ungenehmigten institution
router.get(
  "/ungenehmigt",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.user._id;

    const resultIsUserBetreiber = await userService.isUserBetreiber(userId);

    if (resultIsUserBetreiber.error || !resultIsUserBetreiber) {
      return res.status(400).json({
        error: "Nur Betreiber können ungenehmigte Institutionen abrufen",
      });
    }

    const result = await institutionService.getUngenehmigteVeranstaltungen();
    if (result.error) {
      res.status(400).json(result);
    } else {
      res.status(200).json(result);
    }
  }
);

// [GET] bekomme einzelne institution
router.get("/:institutionId", async function (req, res) {
  let institutionId = req.params.institutionId;
  // ist query eine Zahl?
  if (!/^\d+$/.test(institutionId)) {
    return res.status(400).send("institutionId ist keine Zahl");
  }
  const result = await institutionService.getInstitutionById(institutionId);
  if (result.error) {
    res.status(400).json(result);
  } else {
    res.status(200).json(result);
  }
});

// [POST] Hinterlege Profilbild für Institution
router.post(
  "/:institutionId/profilbild",
  passport.authenticate("jwt", { session: false }),
  fileUploadService.upload.single("file"),
  async function (req, res) {
    const userId = req.user._id;
    const institutionId = req.params.institutionId;
    if (!/^\d+$/.test(institutionId)) {
      return res.status(400).send("institutionId keine Zahl");
    }
    const resultIsUserInInstitution = await institutionService.isUserInInstitution(
      userId,
      institutionId
    );

    if (resultIsUserInInstitution.error || !resultIsUserInInstitution) {
      return res.status(400).json({
        error: "User ist nicht als Verwalter in Institution registriert",
      });
    }

    try {
      if (req.file == undefined) {
        return res.status(400).send({ error: "Keine Datei gefunden" });
      }

      const result = await fileUploadService.createFileInDb(
        req.file.filename,
        req.file.mimetype
      );
      await institutionService.saveProfilbildIdToInstitution(
        institutionId,
        result.id
      );

      if (result.error) {
        return res.status(400).send(result);
      } else {
        return res.status(200).send(result);
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
  }
);

// [POST] genehmige einzelne institution
router.post(
  "/:institutionId/genehmigen",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.user._id;
    let institutionId = req.params.institutionId;
    // ist query eine Zahl?
    if (!/^\d+$/.test(institutionId)) {
      return res.status(400).send("institutionId ist keine Zahl");
    }

    const resultIsUserBetreiber = await userService.isUserBetreiber(userId);

    if (resultIsUserBetreiber.error || !resultIsUserBetreiber) {
      return res.status(400).json({
        error: "Nur Betreiber können Institutionen genehmigen",
      });
    }

    const result = await institutionService.genehmigeInstitution(institutionId);
    if (result.error) {
      res.status(400).json(result);
    } else {
      res.status(200).json(result);
    }
  }
);

// [POST] Erstelle eine institution (mit Fabi gecoded)
router.post(
  "/*",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    let body = req.body;
    const userId = req.user._id;

    if (!body.name) {
      return res.status(400).send({ error: "Name nicht vorhanden" });
    }
    if (!body.beschreibung) {
      return res.status(400).send({ error: "Beschreibung nicht vorhanden" });
    }

    const istNameVorhanden = await institutionService.isInstitutionNameVorhanden(body.name)

    if(istNameVorhanden || istNameVorhanden.error){
      return res.status(400).json({error: "Name der Institution schon vergeben"})
    }

    const result = await institutionService.erstelleInstitution(
      body.name,
      body.beschreibung,
      userId
    );

    if (result.error) {
      return res.status(400).send(result);
    } else {
      return res.send(result);
    }
  }
);

// [PUT] update einzelne institution
router.put(
  "/:institutionId",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.user._id;
    let institutionId = req.params.institutionId;
    // ist query eine Zahl?
    if (!/^\d+$/.test(institutionId)) {
      return res.status(400).send("institutionId ist keine Zahl");
    }

    const resultIsUserInInstitution = await institutionService.isUserInInstitution(
      userId,
      institutionId
    );

    if (resultIsUserInInstitution.error || !resultIsUserInInstitution) {
      return res.status(400).json({
        error: "User ist nicht als Verwalter in Institution registriert",
      });
    }

    let body = req.body;
    if (!body.name) {
      return res.status(400).send({ error: "Name nicht vorhanden" });
    }
    if (!body.beschreibung) {
      return res.status(400).send({ error: "Beschreibung nicht vorhanden" });
    }

    const result = await institutionService.updateInstitutionById(
      institutionId,
      body.name,
      body.beschreibung
    );

    if (result.error) {
      return res.status(400).send(result);
    } else {
      return res.send(result);
    }
  }
);

// [DELETE] lösche einzelne institution
router.delete(
  "/:institutionId",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.user._id;
    let institutionId = req.params.institutionId;
    // ist query eine Zahl?
    if (!/^\d+$/.test(institutionId)) {
      return res.status(400).send("institutionId ist keine Zahl");
    }

    const resultInstitution = await institutionService.getInstitutionById(
      institutionId
    );

    if (resultInstitution.error) {
      return res.status(400).json(resultInstitution);
    }
    if (resultInstitution.length < 1) {
      return res.status(400).json({ error: "Institution nicht vorhanden" });
    }

    const resultIsUserInInstitution = await institutionService.isUserInInstitution(
      userId,
      institutionId
    );
    const resultIsUserBetreiber = await userService.isUserBetreiber(userId);

    if (resultIsUserBetreiber.error || resultIsUserInInstitution.error) {
      return res
        .status(400)
        .json(resultIsUserBetreiber || resultIsUserInInstitution);
    }
    if (!resultIsUserBetreiber && !resultIsUserInInstitution) {
      return res
        .status(400)
        .send(
          "Sie haben nicht die nötigen Rechte, um diese Institution zu löschen"
        );
    }

    const result = await institutionService.deleteInstitutionById(
      institutionId
    );

    if (result.error) {
      return res.status(400).send(result);
    } else {
      return res.send(result);
    }
  }
);

module.exports = router;
