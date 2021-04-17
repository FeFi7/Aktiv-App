const express = require("express");
const compression = require("compression");
//const bodyParser = require('body-parser')
const routerVeranstaltungen = require("./routes/veranstaltungRoute");
const routerUser = require("./routes/userRoute");
const routerFileUpload = require("./routes/fileUploadRoute");
const secureRoute = require("./routes/secureRoute");
const passport = require("passport");
const cors = require("cors");

const app = express();
const port = 3000;

app.use(cors());

app.use(compression());
app.use(express.urlencoded({ extended: false }));
app.use(express.json());
app.use(function timeLog(req, res, next) {
  console.log(
    req.headers.host + " " + req.url + " Time: ",
    new Date().toISOString()
  );
  next();
});

require("./auth/auth");

app.use("/api/veranstaltungen", routerVeranstaltungen);
app.use("/api/fileupload", routerFileUpload);
app.use("/api/user", routerUser);
app.use(
  "/api/auth",
  passport.authenticate("jwt", { session: false }),
  secureRoute
);
app.get("/api/*", async (req, res) => res.send("Hello Aktiv App API!"));
app.get("/", async (req, res) => res.send("Hello Aktiv App!"));

app.use(function (err, req, res, next) {
  console.error(err);
  res.status(err.status || 500);
  res.json({ error: err });
});

app.listen(port, () =>
  console.log("AktivApp Backend listening on port " + port + "!")
);
