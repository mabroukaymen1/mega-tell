const path = require('path');
const express = require('express');
const router = express.Router();
const userController = require('../controleur/user.controleur');
const UserServices = require('../service/user.service');

router.post('/registration', userController.registration);
router.post('/login', userController.login);

router.get('/verification', (req, res) => {
  const { email, code } = req.query;
  // Perform verification logic here
  // If verification is successful, redirect or send a response
  // If verification fails, handle the error
});

router.get('/verify', async (req, res) => {
  const { email, code } = req.query;

  try {
    const isVerified = await UserServices.verifyUser(email, code);

    if (isVerified) {
      res.redirect('/verified');
    } else {
      res.status(400).send('Invalid verification code');
    }
  } catch (error) {
    console.error('Error verifying user:', error);
    res.status(500).send('An error occurred during verification');
  }
});

module.exports = router;