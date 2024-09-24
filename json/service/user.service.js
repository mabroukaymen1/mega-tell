const UserModel = require("../models/user.models");
const jwt = require("jsonwebtoken");
const transporter = require("../config/emailconfig.js");

class UserServices {
  static async registerUser(name, userName, societyName, phoneNumber, email, password) {
    try {
      const verificationCode = generateVerificationCode();

      const createUser = new UserModel({
        name,
        userName,
        societyName,
        phoneNumber,
        email,
        password,
        verificationCode,
      });

      const savedUser = await createUser.save();
      return await savedUser.save();
    } catch (err) {
      throw err;
    }
  }

  static async getUserByEmail(email) {
    try {
      return await UserModel.findOne({ email });
    } catch (err) {
      console.log(err);
    }
  }

  static async checkUser(email) {
    try {
      return await UserModel.findOne({ email });
    } catch (error) {
      throw error;
    }
  }

  static async generateAccessToken(tokenData, JWTSecret_Key, JWT_EXPIRE) {
    return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
  }

  static async verification(email, verificationCode, req) {
    try {
      const host = req.get('host');
      const link = `http://${host}/verify?code=${verificationCode}`;

      let info = await transporter.sendMail({
        from: process.env.EMAIL_FROM,
        to: email,
        subject: "Verification Code",
        html: `Your verification code is: <strong>${verificationCode}</strong>. Click <a href="${link}">here</a> to verify your email.`,
      });

      console.log("Verification Code Email Sent...");
    } catch (error) {
      console.error("Error sending verification code email:", error);
      throw new Error("Failed to send verification code email");
    }
  }

  static async verifyUser(email, verificationCode) {
    try {
      const user = await UserModel.findOne({ email });

      if (!user) {
        throw new Error('User not found');
      }

      if (verificationCode === user.verificationCode) {
        user.isVerified = true;
        await user.save();
        return true;
      } else {
        throw new Error('Invalid verification code');
      }
    } catch (error) {
      throw error;
    }
  }
}

function generateVerificationCode() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

module.exports = {
  UserServices,
  generateVerificationCode,
};