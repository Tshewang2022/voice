import { generateOtp } from "../controllers/generate.otp";

import { Router } from "express";
const otpRouter = Router();
otpRouter.post('/v1/common/generate-otp', generateOtp);


export { otpRouter };