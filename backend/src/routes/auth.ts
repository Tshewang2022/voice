import { Router } from "express";
import { registerUser, loginUser } from "../controllers/user.controller";

const authRouter = Router();
authRouter.post('/v1/user/register', registerUser);
authRouter.post('/v1/user/login', loginUser);


export {authRouter};