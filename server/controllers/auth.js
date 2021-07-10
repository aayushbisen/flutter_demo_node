import jwt from "jsonwebtoken";

import User from "../models/user";

import { validationResult } from 'express-validator'

export const register = async (req, res) => {
  const errs = validationResult(req);

  if (!errs.isEmpty()) {
    return res.status(400).json({ code: 'bad-email', message: "Please enter a valid email address" });
  }

  console.log(req.body);
  const { name, email, password } = req.body;

  // validation
  if (!name) return res.status(400).json({ code: "name-require", message: "Name is required" });

  if (!password || password.length < 6)
    return res
      .status(400)
      .json({ message: "Password is required and should be min 6 characters long", code: "password-require-short" });

  let userExist = await User.findOne({ email }).exec();

  if (userExist) return res.status(400).json({ code: "email-taken", message: "Email is taken" });

  // register
  const user = new User(req.body);

  try {
    await user.save();
    console.log("USER CREATED", user);
    return res.json({
      code: "user-created",
      message: "SignUp successfull, user is created",

      ok: true
    });
  }

  catch (err) {
    console.log("CREATE USER FAILED", err["message"]);
    return res.status(400).json({ code: "signup-error", message: "SignUp error. Please try again" });
  }
};

export const login = async (req, res) => {
  const { email, password } = req.body;
  try {
    // check if user with that email exist
    let user = await User.findOne({ email }).exec();
    // console.log("USER EXIST", user);

    // if there is no user
    if (!user) res.status(400).json({ code: 'no-user', message: "User with that email not found." });

    // let's compare password
    user.comparePassword(password, (err, match) => {
      console.log("COMPARE PASSWORD IN LOGIN ERR", err);

      if (!match || err) return res.status(400).json({ code: 'bad-password', message: "Wrong password" });

      // GENERATE A TOKEN THEN SEND AS RESPONSE TO CLIENT

      let token = jwt.sign({ _id: user._id }, process.env.JWT_SECRET, {
        expiresIn: "7d",
      });

      res.json({
        code: 'signin-success',
        message: 'Login success',
        token,
        user: {
          _id: user._id,
          name: user.name,
          email: user.email,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
        },
      });
    });
  } catch (err) {
    console.log("LOGIN ERROR", err);
    res.status(400).json({ code: 'signin-failed', message: "Signin failed" });
  }
};
