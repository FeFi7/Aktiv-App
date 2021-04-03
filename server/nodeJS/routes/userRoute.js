var userService = require("../services/userService")
var express = require('express');
var router = express.Router();

router.use(function timeLog(req, res, next) {
  console.log( req.headers.host + ' Time: ', new Date().toISOString());
  next();
});

// [GET] bekomme einzelne user
router.get('/:userId', async function(req, res) {
  let userId = req.params.userId;
  // ist query eine Zahl?
  if(! /^\d+$/.test(req.params.userId)){
    res.sendStatus(400);
    res.send("Id keine Zahl")
}

  if(userService.getuserById(req.params.userId) === null){
    res.sendStatus(404);
    res.send("user nicht vorhanden")
  }
  
  res.json(userService.getuserById(req.params.userId));
});

// [PUT] update einzelne user
router.put('/:userId', async function(req, res) {

  let userId = req.params.userId;
  // ist query eine Zahl?
  if(! /^\d+$/.test(req.params.userId)){
    res.sendStatus(400);
    res.send("Id keine Zahl")
  }

  if(userService.getuserById(req.params.userId) === null){
    res.sendStatus(404);
    res.send("user nicht vorhanden")
  }
  
  res.json(userService.getuserById(req.params.userId));
});

// [DELETE] lösche einzelne user
router.delete('/:userId', async function(req, res) {

  res.json(userService.getuserById(req.params.userId));
});

// [GET] bekomme alle user
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
  
  res.json(userService.getuseren())
});

// [POST] Erstelle eine user
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
  
  res.json(userService.getuseren())
});

module.exports = router;