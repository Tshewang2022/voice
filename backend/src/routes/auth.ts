import { Router } from "express";
import { registerUser, loginUser, forgotPassword } from "../controllers/user.controller";

const authRouter = Router();
authRouter.post('/register', registerUser);
authRouter.post('/login', loginUser);
authRouter.post('/forgot-password', forgotPassword);


export {authRouter};