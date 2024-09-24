const db = require('../config/db');
const bcrypt = require("bcrypt");
const mongoose = require('mongoose');
const { Schema } = mongoose;

const userSchema = new mongoose.Schema({
    name: {
      type: String,
      required: [true, "Name can't be empty"],
    },
    userName: {
      type: String,
      required: [true, "UserName can't be empty"],
      unique: true,
    },
    societyName: {
      type: String,
      required: [true, "SocietyName is required"],
    },
    phoneNumber: {
      type: String,
      required: [true, "PhoneNumber is required"],
      unique: true,
    },
    email: {
      type: String,
      lowercase: true,
      required: [true, "Email can't be empty"],
      match: [
        /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
        "Email format is not correct",
      ],
      unique: true,
    },
    password: {
      type: String,
      required: [true, "Password is required"],
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
    isVerified: {
      type: Boolean,
      default: false,
    },
    verificationCode: {
      type: String,
    },
  });

// used while encrypting user entered password
userSchema.pre("save", async function() {var user = this;
  if(!user.isModified("name") && !user.isModified("userName") && !user.isModified("societyName") && !user.isModified("phoneNumber") && !user.isModified("email") && !user.isModified("password")) {
      return;
  }
  try {
      const salt = await bcrypt.genSalt(10);
      const hash = await bcrypt.hash(user.password, salt);

      user.password = hash;
  } catch (err) {
      throw err;
  }
});

//used while signIn decrypt
userSchema.methods.comparePassword = async function (candidatePassword) {
  try {
      console.log('----------------no password', this.password);
      const isMatch = await bcrypt.compare(candidatePassword, this.password);
      return isMatch;
  } catch (error) {
      throw error;
  }
};

const UserModel = db.model('user', userSchema);
module.exports = UserModel;