import { generateOtp } from "../controllers/generate.otp";

import { Router } from "express";
const otpRouter = Router();
otpRouter.post('/common/generate-otp', generateOtp);


export { otpRouter };