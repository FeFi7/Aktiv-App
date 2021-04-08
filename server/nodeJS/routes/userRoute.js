var userService = require("../services/userService")
var express = require('express');
var router = express.Router();
const passport = require('passport');
const jwt = require('jsonwebtoken');

const config = require('config')
const jwtConfig = config.get('Customer.jwtConfig');
const SECRET_TOKEN = jwtConfig.secret;



// [POST] register User
router.post("/signup", async function(req, res){
  let body = req.body;

  if(!body.mail){
    return res.status(400).send({error: "Mail nicht vorhanden"});
  }
  if(!body.passwort){
    return res.status(400).send({error: "Passwort nicht vorhanden"});
  }
  if(!body.plz){
    return res.status(400).send({error: "Plz nicht vorhanden"});
  }
  if(!body.rolle){
    body.rolle = 1;
  }
  else{
      // ist numerisch?
      if (!/^-?\d+\.?\d*$/.test(body.rolle)) {
        body.rolle = 1;
      }
  }

  const result = await userService.registerUser(body.mail, body.passwort, body.plz, body.rolle);

  if(result.error){
    return res.status(400).send(result);
  }
  else{
    return res.send(result);
  }
})


// [GET] bekomme einzelne user
router.get('/', async function(req, res) {
  let query = req.query;

  if(!query.mail){
    return res.status(400).send({error: "Mail nicht vorhanden"});
  }
  const result = await userService.userExists(query.mail);

  if(result.length > 0){
    return res.json({istVorhanden: true, user: result[0]});
  }
  else{
    return res.json({istVorhanden: false});
  }
});


// [POST] login User
router.post('/login',async (req, res, next) => {
    passport.authenticate(
      'login',
      async (err, user, info) => {
        try {
          if (err || !user) {
            return res.status(401).json({error: info.message})
          }

          req.login(
            user,
            { session: false },
            async (error) => {
              if (error) return next(error);

              const body = { _id: user.id, email: user.mail };
              const token = jwt.sign({ user: body }, SECRET_TOKEN);

              return res.json({ token });
            }
          );
        } catch (error) {
          return next(error);
        }
      }
    )(req, res, next);
  }
);


module.exports = router;