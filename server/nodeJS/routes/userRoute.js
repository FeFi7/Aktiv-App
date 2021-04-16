var userService = require("../services/userService");
const fileUploadService = require("../services/fileUploadService");
var express = require("express");
var router = express.Router();
const passport = require("passport");
const jwt = require("jsonwebtoken");

const config = require("config");
const jwtConfig = config.get("Customer.jwtConfig");
const SECRET_TOKEN = jwtConfig.secret;
const SECRET_TOKEN_REFRESH = jwtConfig.refreshSecret;

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

// [GET] bekomme einzelne user
router.get("/", async function (req, res) {
  let query = req.query;

  if (!query.mail) {
    return res.status(400).send({ error: "Mail nicht vorhanden" });
  }
  const result = await userService.userExists(query.mail);

  if (result.length > 0) {
    return res.json({ istVorhanden: true, user: result[0] });
  } else {
    return res.json({ istVorhanden: false });
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
        console.log("bin hier")
        if (error) return next(error);

        const body = { _id: user.id, mail: user.mail };
        const accessToken = jwt.sign({ user: body }, SECRET_TOKEN, {
          expiresIn: "30m",
        });
        const refreshToken = jwt.sign({ user: body }, SECRET_TOKEN_REFRESH);

        const saveRefreshResult = await userService.saveRefreshToken(
          refreshToken
        );

        if (!saveRefreshResult.error) {
          return res.json({ accessToken, refreshToken });
        } else {
          return res.status(400).json({ error: "Fehler bei Db" });
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
      expiresIn: "20m",
    });
    const refreshTokenNeu = jwt.sign({ user: user.user }, SECRET_TOKEN_REFRESH);

    await userService.deleteRefreshToken(refreshToken).catch((error) => console.log(error));
    await userService.saveRefreshToken(refreshTokenNeu).catch((error) => console.log(error));
    return res.json({
      accessToken, refreshTokenNeu
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
        return res.status(400).send({ error: "Kein datei gefunden" });
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
      res.status(400).json(result);
    } else {
      res.status(200).json(result);
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
      body.tel
    );

    if (result.error) {
      res.status(400).json(result);
    } else {
      res.status(200).json(result);
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

module.exports = router;
