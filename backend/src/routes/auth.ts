import { Router } from "express";
import { registerUser, loginUser, forgotPassword } from "../controllers/user.controller";

const authRouter = Router();
authRouter.post('/v1/user/register', registerUser);
authRouter.post('/v1/user/login', loginUser);
authRouter.post('/v1/user/forgot-password', forgotPassword);


export {authRouter};