var veranstaltungService = require("../services/veranstaltungService")
var express = require('express');
var router = express.Router();

router.use(function timeLog(req, res, next) {
  console.log( req.headers.host + ' Time: ', new Date().toISOString());
  next();
});

// [GET] bekomme einzelne Veranstaltung
router.get('/:veranstaltungId', async function(req, res) {
  const veranstaltungId = req.params.veranstaltungId;
  // ist query eine Zahl?
  if(! /^\d+$/.test(veranstaltungId)){
    res.status(400);
    res.send("Id keine Zahl")
  }
  
  const veranstaltung = await veranstaltungService.getVeranstaltungById(req.params.veranstaltungId)
  if(veranstaltung){
    res.json(await veranstaltungService.getVeranstaltungById(req.params.veranstaltungId));
  }
  else{
    res.status(404);
    res.send("Veranstaltung nicht vorhanden")
  }
  
});

// [PUT] update einzelne Veranstaltung
router.put('/:veranstaltungId', async function(req, res) {
  const veranstaltungId = req.params.veranstaltungId;
  // ist query eine Zahl?
  if(! /^\d+$/.test(veranstaltungId)){
    res.status(400);
    res.send("Id keine Zahl")
  }

  if(veranstaltungService.getVeranstaltungById(veranstaltungId) === null){
    res.status(404);
    res.send("Veranstaltung nicht vorhanden")
  }
  
  res.json(veranstaltungService.getVeranstaltungById(veranstaltungId));
});

// [DELETE] lösche einzelne Veranstaltung
router.delete('/:veranstaltungId', async function(req, res) {

  res.json(veranstaltungService.getVeranstaltungById(req.params.veranstaltungId));
});

// [GET] bekomme alle Veranstaltung
router.get('/*', async function(req, res) {
  const limit = 25
  const page = 1

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

  const veranstaltungen = await veranstaltungService.getVeranstaltungen(limit) 
  
  res.send(veranstaltungen)
});

// [POST] Erstelle eine Veranstaltung
router.post('/*', async function(req, res) {
  let titel = req.body.titel;
  let beschreibung = req.body.beschreibung;
  let kontakt = req.body.kontakt;
  let beginn_ts = req.body.beginn_ts;
  let ende_ts = req.body.ende_ts;
  let ortBeschreibung = req.body.ortBeschreibung; 
  let latitude = req.body.latitude;
  let longitude = req.body.longitude;
  let institutionId = req.body.institutionId;
  let userId = req.body.userId;
  let istGenehmigt = req.body.istGenehmigt;

  //-------------------------Überprüfung Parameter---------------------------
  if(typeof titel === 'undefined'){
    res.status(400);
    res.send("titel benötigt");
    return;
  }
  if(typeof beschreibung === 'undefined'){
    res.status(400);
    res.send("beschreibung benötigt");
    return;
  }
  if(typeof kontakt === 'undefined'){
    res.status(400);
    res.send("kontakt benötigt");
    return;
  }
  if(typeof beginn_ts === 'undefined'){
    res.status(400);
    res.send("beginn_ts benötigt");
    return;
  }
  if(typeof ende_ts === 'undefined'){
    res.status(400);
    res.send("ende_ts benötigt");
    return;
  }
  if(typeof ortBeschreibung === 'undefined'){
    res.status(400);
    res.send("ortBeschreibung benötigt");
    return;
  }
  if(typeof latitude !== 'undefined'){
    // ist numerisch?
    if(!/^-?\d+\.?\d*$/.test(latitude)){
      res.status(400);
      res.send("latitude muss numerisch sein");
      return;
    }
  }
  else{
    res.status(400);
    res.send("latitude benötigt");
    return;
  }
  if(typeof longitude !== 'undefined'){
    // ist numerisch?
    if(!/^-?\d+\.?\d*$/.test(longitude)){
      res.status(400);
      res.send("longitude muss numerisch sein");
      return;
    }
  }
  else{
    res.status(400);
    res.send("longitude benötigt");
    return;
  }
  if(typeof institutionId !== 'undefined'){
    // ist numerisch?
    if(!/^-?\d+\.?\d*$/.test(institutionId)){
      res.status(400);
      res.send("institutionId muss numerisch sein");
      return;
    }
  }
  else{
    res.status(400);
    res.send("institutionId benötigt");
    return;
  }
  if(typeof userId !== 'undefined'){
    // ist numerisch?
    if(!/^-?\d+\.?\d*$/.test(userId)){
      res.status(400);
      res.send("userId muss numerisch sein");
      return;
    }
  }
  else{
    res.status(400);
    res.send("userId benötigt");
    return;
  }
  if(typeof istGenehmigt === 'undefined'){
    istGenehmigt = 0;
  }
  //-------------------------Überprüfung Parameter---------------------------

  const veranstaltungen = await veranstaltungService.createVeranstaltung(titel, 
  beschreibung, kontakt, beginn_ts, ende_ts, ortBeschreibung,
  latitude, longitude, institutionId, userId, istGenehmigt ? 1 : 0); 
  
  if(veranstaltungen){
    res.send(veranstaltungen);
    return
  }
  else{
    res.sendStatus(400);
    return
  }
  
});

module.exports = router;