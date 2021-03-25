var express = require('express');
var router = express.Router();

router.use(function timeLog(req, res, next) {
  console.log('Time: ', Date.now());
  next();
});

router.get('/*', async function(req, res) {
  res.send('API für Veranstaltungen');
});

module.exports = router;