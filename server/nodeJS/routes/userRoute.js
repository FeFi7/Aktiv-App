var userService = require("../services/userService")
var express = require('express');
var router = express.Router();

router.use(function timeLog(req, res, next) {
  console.log( req.headers.host + ' Time: ', new Date().toISOString());
  next();
});

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



module.exports = router;