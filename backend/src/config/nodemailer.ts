import nodemailer, { Transporter } from "nodemailer";
import dotenv from 'dotenv';

dotenv.config();
const user = process.env.SMTP_USER as string;
const password = process.env.SMTP_PASS as string;


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
