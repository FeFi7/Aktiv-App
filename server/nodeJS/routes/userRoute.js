var userService = require("../services/userService");
const fileUploadService = require("../services/fileUploadService");
var institutionService = require("../services/institutionService");
var express = require("express");
var router = express.Router();
const passport = require("passport");
const jwt = require("jsonwebtoken");

const config = require("config");
const jwtConfig = config.get("Customer.jwtConfig");
const SECRET_TOKEN = jwtConfig.secret;
const SECRET_TOKEN_REFRESH = jwtConfig.refreshSecret;
const TOKEN_EXPIRE = jwtConfig.tokenExpire;

// [PUT] Ändern der persönlichen AppEinstellungen (Umkreis und Bald)
router.put(
  "/:userId/einstellungen",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.params.userId;
    const body = req.body;
    let umkreisEinstellung = body.umkreisEinstellung;
    let baldEinstellung = body.baldEinstellung;

    if (!/^\d+$/.test(userId)) {
      return res.status(400).send("Id keine Zahl");
    }
    if (umkreisEinstellung) {
      // ist query eine Zahl?
      if (!/^\d+$/.test(umkreisEinstellung)) {
        return res.status(400).send("umkreisEinstellung muss numerisch sein");
      }
    }
    if (baldEinstellung) {
      // ist query eine Zahl?
      if (!/^\d+$/.test(baldEinstellung)) {
        return res.status(400).send("baldEinstellung muss numerisch sein");
      }
    }
    const result = await userService.updateUserEinstellungen(
      userId,
      umkreisEinstellung,
      baldEinstellung
    );
    if (result.error) {
      return res.status(400).json(result);
    } else {
      return res.status(200).json(result);
    }
  }
);

// [GET] Bekomme alle verwalteten Institutionen von User
router.get(
  "/:userId/institutionen",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.params.userId;

    if (!/^\d+$/.test(userId)) {
      return res.status(400).send("userId keine Zahl");
    }

    const result = await userService.getInstitutionenFromUser(userId);

    if (result.error) {
      return res.status(400).json(result);
    } else {
      return res.status(200).json(result);
    }
  }
);

// [POST] Verknüpfung von User mit Institution als Verwalter
router.post(
  "/:userId/institutionen/:institutionId",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.user._id;
    const userIdAdd = req.params.userId;
    const institutionId = req.params.institutionId;

    if (!/^\d+$/.test(userIdAdd)) {
      return res.status(400).send("userId keine Zahl");
    }
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

    const result = await userService.addUserToInstitut(
      userIdAdd,
      institutionId
    );

    if (result.error) {
      return res.status(400).json(result);
    } else {
      return res.status(200).json(result);
    }
  }
);

// [DELETE] Lösche Verknüpfung von User mit Institution als Verwalter
router.delete(
  "/:userId/institutionen/:institutionId",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.user._id;
    const userIdDelete = req.params.userId;
    const institutionId = req.params.institutionId;

    if (!/^\d+$/.test(userIdDelete)) {
      return res.status(400).send("userId keine Zahl");
    }
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

    const result = await userService.deleteUserToInstitut(
      userIdDelete,
      institutionId
    );

    if (result.error) {
      return res.status(400).json(result);
    } else {
      return res.status(200).json(result);
    }
  }
);

// [PUT] Ändern der Rolle des Users
router.put(
  "/:userId/rolle",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.params.userId;
    const body = req.body;
    let rolleId = body.rolleId;
    const user = req.user;

    if (!/^\d+$/.test(userId)) {
      return res.status(400).send("Id keine Zahl");
    }
    if (rolleId) {
      // ist query eine Zahl?
      if (!/^\d+$/.test(rolleId)) {
        return res.status(400).send("rolleId muss numerisch sein");
      }
    } else {
      return res.status(400).send("rolleId nicht vorhanden");
    }

    const result = await userService.updateUserRolle(userId, rolleId, user._id);
    if (result.error) {
      return res.status(400).json(result);
    } else {
      return res.status(200).json(result);
    }
  }
);

// [POST] register User
router.post("/signup", async function (req, res) {
  let body = req.body;

  if (!body.mail) {
    return res.status(400).send({ error: "Mail nicht vorhanden" });
  }
  if (!body.passwort) {
    return res.status(400).send({ error: "Passwort nicht vorhanden" });
  }
  if (!body.rolle) {
    body.rolle = 1;
  } else {
    // ist numerisch?
    if (!/^-?\d+\.?\d*$/.test(body.rolle)) {
      body.rolle = 1;
    }
  }

  const result = await userService.registerUser(
    body.mail,
    body.passwort,
    body.rolle
  );

  if (result.error) {
    return res.status(400).send(result);
  } else {
    return res.send(result);
  }
});

// [POST] login User
router.post("/login", async (req, res, next) => {
  passport.authenticate("login", async (err, user, info) => {
    try {
      if (err || !user) {
        return res.status(401).json({ error: info.message });
      }

      req.login(user, { session: false }, async (error) => {
        if (error) return next(error);

        const body = { _id: user.id, mail: user.mail };
        const accessToken = jwt.sign({ user: body }, SECRET_TOKEN, {
          expiresIn: TOKEN_EXPIRE,
        });
        const refreshToken = jwt.sign({ user: body }, SECRET_TOKEN_REFRESH);

        const saveRefreshResult = await userService.saveRefreshToken(
          refreshToken
        );

        if (saveRefreshResult.error) {
          return res.status(400).json({ error: "Fehler bei Db" });
        } else {
          return res.json({ accessToken, refreshToken, id: user.id });
        }
      });
    } catch (error) {
      return next(error);
    }
  })(req, res, next);
});

// [POST] Generiere neuen AccessToken mithilfe des RefreshToken
router.post("/token", async function (req, res) {
  let refreshToken = req.body.token;

  if (!refreshToken) {
    return res.status(400).send({ error: "Kein Token empfangen" });
  }

  if (!(await userService.existRefreshToken(refreshToken))) {
    return res.status(400).json({ error: "Refreshtoken nicht korrekt" });
  }

  jwt.verify(refreshToken, SECRET_TOKEN_REFRESH, async (err, user) => {
    if (err) {
      return res.sendStatus(403);
    }

    const accessToken = jwt.sign({ user: user.user }, SECRET_TOKEN, {
      expiresIn: TOKEN_EXPIRE,
    });
    const refreshTokenNeu = jwt.sign({ user: user.user }, SECRET_TOKEN_REFRESH);

    await userService
      .deleteRefreshToken(refreshToken)
      .catch((error) => console.log(error));
    await userService
      .saveRefreshToken(refreshTokenNeu)
      .catch((error) => console.log(error));
    return res.json({
      accessToken,
      refreshTokenNeu,
    });
  });
});

// [POST] Hinterlege Bild für Profil
router.post(
  "/:userId/profilbild",
  fileUploadService.upload.single("file"),
  async function (req, res) {
    const userId = req.params.userId;
    if (!/^\d+$/.test(userId)) {
      return res.status(400).send("Id keine Zahl");
    }
    try {
      if (req.file == undefined) {
        return res.status(400).send({ error: "Keine Datei gefunden" });
      }

      const result = await fileUploadService.createFileInDb(
        req.file.filename,
        req.file.mimetype
      );
      await userService.saveProfilbildIdToUser(userId, result.id);

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

// [GET] Bekomme Informationen zu User
router.get(
  "/:userId",
  passport.authenticate("jwt", { session: false }),
  async function (req, res, next) {
    const userId = req.params.userId;
    if (!/^\d+$/.test(userId)) {
      return res.status(400).send("Id keine Zahl");
    }
    console.log("mail: " + req.user.mail);
    const result = await userService.getUserInfo(userId, req.user.mail);
    if (result.error) {
      return res.status(400).json(result);
    } else {
      return res.status(200).json(result);
    }
  }
);

// [DELETE] Lösche User (Nur als Betreiber möglich)
router.delete(
  "/:userId",
  passport.authenticate("jwt", { session: false }),
  async function (req, res, next) {
    const userId = req.user._id;
    const userZuEntfernenId = req.params.userId;
    if (!/^\d+$/.test(userZuEntfernenId)) {
      return res.status(400).send("Id keine Zahl");
    }

    const resultIsUserBetreiber = await userService.isUserBetreiber(userId);

    if (resultIsUserBetreiber.error || !resultIsUserBetreiber) {
      return res.status(400).json({
        error: "Nur Betreiber können User löschen",
      });
    }

    const result = await userService.deleteUser(userZuEntfernenId);
    if (result.error) {
      return res.status(400).json(result);
    } else {
      return res.status(200).json(result);
    }
  }
);

// [PUT] UPdate Informationen zu User
router.put(
  "/:userId",
  passport.authenticate("jwt", { session: false }),
  async function (req, res, next) {
    const userId = req.params.userId;
    if (!/^\d+$/.test(userId)) {
      return res.status(400).send("Id keine Zahl");
    }
    let body = req.body;
    const result = await userService.updateUserInformation(
      userId,
      req.user.mail,
      body.vorname,
      body.nachname,
      body.plz,
      body.tel,
      body.strasse,
      body.hausnummer
    );

    if (result.error) {
      return res.status(400).json(result);
    } else {
      return res.status(200).json(result);
    }
  }
);

// [POST] Generiere Favorit Verbindung von User zu Veranstaltung
router.post(
  "/:userId/favorit",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const veranstaltungId = req.body.veranstaltungId;
    const userId = req.params.userId;
    if (!/^\d+$/.test(userId)) {
      return res.status(400).send("userId keine Zahl");
    }
    if (veranstaltungId) {
      if (!/^\d+$/.test(veranstaltungId)) {
        return res.status(400).send("veranstaltungId keine Zahl");
      }
    } else {
      return res.status(400).send("veranstaltungId wird benötigt");
    }

    const result = await userService.favoritVeranstaltung(
      userId,
      veranstaltungId
    );

    if (result.error) {
      return res.status(400).json(result);
    } else {
      return res.status(200).json(result);
    }
  }
);

// [POST] Generiere Verbindung von Genehmiger zu PLZs
router.post(
  "/:userId/genehmigung",
  passport.authenticate("jwt", { session: false }),
  async function (req, res) {
    const userId = req.user._id;
    const userIdGenehmiger = req.params.userId;
    let plz = req.body.plz;
    if (!/^\d+$/.test(userIdGenehmiger)) {
      return res.status(400).send("userId keine Zahl");
    }

    if (plz) {
      try {
        plz = JSON.parse(plz);
      } catch (e) {
        console.log("Fehler bei Parsung plz");
        return res
          .status(400)
          .json({ error: "plz werden nicht als Array übergeben" });
      }
      if (!Array.isArray(plz)) {
        return res
          .status(400)
          .json({ error: "plz werden nicht als Array übergeben" });
      }
    }

    // Ist anfragender User Betreiber und Ziel Genehmiger?
    const resultIsUserGenehmiger = await userService.isUserGenehmiger(
      userIdGenehmiger
    );
    if (resultIsUserGenehmiger.error || !resultIsUserGenehmiger) {
      return res.status(400).json({
        error: "ZielUser besitzt keine Genehmigerrolle",
      });
    }
    const resultIsUserBetreiber = await userService.isUserBetreiber(userId);
    if (resultIsUserBetreiber.error || !resultIsUserBetreiber) {
      return res.status(400).json({
        error: "Nur Betreiber können PLZ zuweisen",
      });
    }

    const result = await userService.setGenehmigerPLZs(userIdGenehmiger, plz);

    if (result.error) {
      return res.status(400).json(result);
    } else {
      return res.status(200).json(result);
    }
  }
);

// [GET] bekomme einzelne user
router.get("/*", async function (req, res) {
  let query = req.query;

  if (!query.mail) {
    return res.status(400).send({ error: "Mail nicht vorhanden" });
  }
  const result = await userService.mailExists(query.mail);

  if (result.length > 0) {
    return res.json({ istVorhanden: true, user: result[0] });
  } else {
    return res.json({ istVorhanden: false });
  }
});

module.exports = router;
