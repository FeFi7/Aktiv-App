var institutionService = require("../services/institutionService")
var express = require('express');
var router = express.Router();

router.use(function timeLog(req, res, next) {
  console.log( req.headers.host + ' Time: ', new Date().toISOString());
  next();
});

// [GET] bekomme einzelne institution
router.get('/:institutionId', async function(req, res) {
  let institutionId = req.params.institutionId;
  // ist query eine Zahl?
  if(! /^\d+$/.test(req.params.institutionId)){
    res.sendStatus(400);
    res.send("Id keine Zahl")
}

  if(institutionService.getinstitutionById(req.params.institutionId) === null){
    res.sendStatus(404);
    res.send("institution nicht vorhanden")
  }
  
  res.json(institutionService.getinstitutionById(req.params.institutionId));
});

// [PUT] update einzelne institution
router.put('/:institutionId', async function(req, res) {

  let institutionId = req.params.institutionId;
  // ist query eine Zahl?
  if(! /^\d+$/.test(req.params.institutionId)){
    res.sendStatus(400);
    res.send("Id keine Zahl")
  }

  if(institutionService.getinstitutionById(req.params.institutionId) === null){
    res.sendStatus(404);
    res.send("institution nicht vorhanden")
  }
  
  res.json(institutionService.getinstitutionById(req.params.institutionId));
});

// [DELETE] lösche einzelne institution
router.delete('/:institutionId', async function(req, res) {

  res.json(institutionService.getinstitutionById(req.params.institutionId));
});

// [GET] bekomme alle institution
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
  
  res.json(institutionService.getinstitutionen())
});

// [POST] Erstelle eine institution
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
  
  res.json(institutionService.getinstitutionen())
});

module.exports = router;