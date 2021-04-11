var userService = require("../services/userService");
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
  if (!body.plz) {
    return res.status(400).send({ error: "Plz nicht vorhanden" });
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
    body.plz,
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
        if (error) return next(error);

        const body = { _id: user.id, email: user.mail };
        const accessToken = jwt.sign({ user: body }, SECRET_TOKEN, {
          expiresIn: "3000m",
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

  jwt.verify(refreshToken, SECRET_TOKEN_REFRESH, (err, user) => {
    if (err) {
      return res.sendStatus(403);
    }

    const accessToken = jwt.sign({ user: user.user }, SECRET_TOKEN, {
      expiresIn: "20m",
    });

    res.json({
      accessToken,
    });
  });
});

module.exports = router;
