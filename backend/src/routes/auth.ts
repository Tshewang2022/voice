import { Router } from "express";
import { registerUser } from "../controllers/user.controller";

const authRouter = Router();
authRouter.post('/v1/user/register', registerUser);

export {authRouter};