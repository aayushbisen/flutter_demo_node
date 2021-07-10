import express from "express";
import { body } from "express-validator";

const router = express.Router();

// controllers
import { register, login } from "../controllers/auth";

router.post("/register", body('email').isEmail(), register);
router.post("/login", login);

module.exports = router;
