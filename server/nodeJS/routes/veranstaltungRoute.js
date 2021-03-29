var veranstaltungService = require("../services/veranstaltungService")
var express = require('express');
var router = express.Router();


router.use(function timeLog(req, res, next) {
  console.log('Time: ', Date.now());
  next();
});

// [GET] einzelne Veranstaltung
router.get('/:veranstaltungId', async function(req, res) {

  res.json(veranstaltungService.getVeranstaltungById(req.params.veranstaltungId));
});

// [GET] alle Veranstaltung
router.get('/*', async function(req, res) {
  let limit = 25
  let page = 1

  if(typeof req.query.limit !== 'undefined'){
    // ist query eine Zahl?
    if(/^\d+$/.test(req.query.limit)){
        limit = req.query.limit
    }
  }
  if(typeof req.query.page !== 'undefined'){
    if(/^\d+$/.test(req.query.page)){
      page = req.query.page
    }
  }
  
  res.json({limit: limit, page: page})
});

module.exports = router;