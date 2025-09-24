import { Response, Request } from 'express';
import { validateEmailSchema } from '../validations/auth.validation';
import { transporter } from '../config/nodemailer';
import ApiError from '../utils/ApiError';
import { setWithExpiry } from '../config/redis.config';

const generateOtp = async (req: Request, res: Response) => {
    const { error, value } = validateEmailSchema.validate(req.body);

    if (error) {
        throw new ApiError(400, error.details[0].message)
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
    await setWithExpiry(`otp:${email}`, otp, 3600);
    res.status(201).json({
        success: true,
        message: "OTP sent successfully in your email",
        otp: otp
    })

}

export { generateOtp };