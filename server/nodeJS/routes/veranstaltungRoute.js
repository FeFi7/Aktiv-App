var veranstaltungService = require("../services/veranstaltungService")
var express = require('express');
var router = express.Router();

router.use(function timeLog(req, res, next) {
  console.log( req.headers.host + ' Time: ', new Date().toISOString());
  next();
});

// [GET] bekomme einzelne Veranstaltung
router.get('/:veranstaltungId', async function(req, res) {
  let veranstaltungId = req.params.veranstaltungId;
  // ist query eine Zahl?
  if(! /^\d+$/.test(req.params.veranstaltungId)){
    res.sendStatus(400);
    res.send("Id keine Zahl")
}

  if(veranstaltungService.getVeranstaltungById(req.params.veranstaltungId) === null){
    res.sendStatus(404);
    res.send("Veranstaltung nicht vorhanden")
  }
  
  res.json(veranstaltungService.getVeranstaltungById(req.params.veranstaltungId));
});

// [PUT] update einzelne Veranstaltung
router.put('/:veranstaltungId', async function(req, res) {

  let veranstaltungId = req.params.veranstaltungId;
  // ist query eine Zahl?
  if(! /^\d+$/.test(req.params.veranstaltungId)){
    res.sendStatus(400);
    res.send("Id keine Zahl")
  }

  if(veranstaltungService.getVeranstaltungById(req.params.veranstaltungId) === null){
    res.sendStatus(404);
    res.send("Veranstaltung nicht vorhanden")
  }
  
  res.json(veranstaltungService.getVeranstaltungById(req.params.veranstaltungId));
});

// [DELETE] lösche einzelne Veranstaltung
router.delete('/:veranstaltungId', async function(req, res) {

  res.json(veranstaltungService.getVeranstaltungById(req.params.veranstaltungId));
});

// [GET] bekomme alle Veranstaltung
router.get('/*', async function(req, res) {
  let limit = 25
  let page = 1

  if(typeof req.query.limit !== 'undefined'){
    // ist query eine Zahl?
    if(/^\d+$/.test(req.query.limit) && req.query.limit < 100){
        limit = req.query.limit
    }
  }
  if(typeof req.query.page !== 'undefined'){
    if(/^\d+$/.test(req.query.page)){
      page = req.query.page
    }
  }
  
  res.json(veranstaltungService.getVeranstaltungen())
});

// [POST] Erstelle eine Veranstaltung
router.post('/*', async function(req, res) {
  let limit = 25
  let page = 1

  if(typeof req.query.limit !== 'undefined'){
    // ist query eine Zahl?
    if(/^\d+$/.test(req.query.limit) && req.query.limit < 100){
        limit = req.query.limit
    }
  }
  if(typeof req.query.page !== 'undefined'){
    if(/^\d+$/.test(req.query.page)){
      page = req.query.page
    }
  }
  
  res.json(veranstaltungService.getVeranstaltungen())
});

module.exports = router;