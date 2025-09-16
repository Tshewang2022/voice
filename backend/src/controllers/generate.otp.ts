import { Response, Request } from 'express';
import { validateEmailSchema } from '../validations/auth.validation';
import { transporter } from '../config/nodemailer';
import ApiError from '../utils/ApiError';
import { setWithExpiry } from '../config/redis.config';
// complete and robust, authentication system will be build this week
// i need to do the load testing on this api
// for the invalid email, it should not crash the server, but show proper error handling message
// need fix
// and need rate limiting for this api, cannot request more than 5 times and have to wait till 30s to 
// pass to request new otp;
// more than that, someting is wrong with the email or the backend code
// i forgot one thing that is device token
const generateOtp = async (req: Request, res: Response) => {
    const { error, value } = validateEmailSchema.validate(req.body);

    if (error) {
        throw new ApiError(400, 'Invalid email')
    }
    const { email } = value;

    const otp = String(Math.floor(100000 + Math.random() * 900000))

    const mailOptions = {
        from: "leeward192@gmail.com",
        to: email,
        subject: "Account verification",
        text: `Welcome to voice app. Your otp is ${otp}. Please do not share with anyone`
    }

    await transporter.sendMail(mailOptions);
    await setWithExpiry(`otp:${email}`, otp, 60);
    res.status(201).json({
        success: true,
        message: "OTP sent successfully in your email",
        otp: otp
    })

}

export { generateOtp };