import nodemailer, { Transporter } from "nodemailer";
import dotenv from 'dotenv';
import ApiError from "../utils/ApiError";

// see how to pro have written the code;
// every morning 1 hours dedicate one hour to read code from the pro;
dotenv.config();
const user = process.env.SMTP_USER as string;
const password = process.env.SMTP_PASS as string;
const token = process.env.JWT_ACCESS_SECRET as string;
if (!user && !password) {
    throw new ApiError(400, 'Required username and password to send smtp brevo mail');
}

const transporter: Transporter = nodemailer.createTransport({
    host: "smtp-relay.brevo.com",
    port: 587,
    secure: false,
    auth: {
        user: user,
        pass: password,
    },
});

export { transporter };
