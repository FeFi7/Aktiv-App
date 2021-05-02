const express = require("express");
const compression = require("compression");
//const bodyParser = require('body-parser')
const routerVeranstaltungen = require("./routes/veranstaltungRoute");
const routerUser = require("./routes/userRoute");
const routerFileUpload = require("./routes/fileUploadRoute");
const routerInstitution = require("./routes/institutionRoute");
const secureRoute = require("./routes/secureRoute");
const passport = require("passport");
const cors = require("cors");
const fs = require("fs");

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());

//var access = fs.createWriteStream('/var/log/node/node' + process.env.PORT + '.log');
//rocess.stdout.write = process.stderr.write = access.write.bind(access);

process.on("uncaughtException", function (err) {
  console.error(err && err.stack ? err.stack : err);
});

app.use(compression());
app.use(express.urlencoded({ extended: true }));
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
app.use("/api/institutionen", routerInstitution);
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
