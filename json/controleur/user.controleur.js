const { UserServices, generateVerificationCode } = require('../service/user.service');
const dotenv = require('dotenv');
const jwt = require('jsonwebtoken');
const UserModel = require('../models/user.models');
dotenv.config();
const transporter = require('../config/emailconfig.js');

exports.registration = async (req, res, next) => {
  try {
    console.log("---req body---", req.body);
    const { name, userName, societyName, phoneNumber, email, password } = req.body;

    const duplicate = await UserServices.getUserByEmail(email);
    if (duplicate) {
      throw new Error(`User with email ${email} is already registered`);
    }

    // Register user
    const response = await UserServices.registerUser(name, userName, societyName, phoneNumber, email, password);

    // Generate and send verification code
    const verificationCode = generateVerificationCode();
    await UserServices.verification(email, verificationCode, req);

    // Redirect user to verification page
    res.redirect(`/verification?email=${email}&code=${verificationCode}`);

  } catch (err) {
    console.error("---> err -->", err);
    next(err);
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      throw new Error('Parameters are not correct');
    }

    let user = await UserServices.checkUser(email);

    if (!user) {
      throw new Error('User does not exist');
    }

    const isPasswordCorrect = await user.comparePassword(password);

    if (!isPasswordCorrect) {
      throw new Error(`Username or Password does not match`);
    }

    // Creating Token
    let tokenData = {
      _id: user._id,
      email: user.email,
      name: user.name,
      userName: user.userName,
      societyName: user.societyName,
      phoneNumber: user.phoneNumber
    };

    const token = await UserServices.generateAccessToken(tokenData, "secret", "1h");

    res.status(200).json({ status: true, success: "sendData", token: token });

  } catch (error) {
    console.error("Error logging in user:", error);
    next(error);
  }
};