const express = require('express');
const router = express.Router();

router.get(
  '/jwt',
  (req, res, next) => {
    res.json({
      message: 'JWT ist valide',
      user: req.user,
      token: req.query.secret_token
    })
  }
);

module.exports = router;