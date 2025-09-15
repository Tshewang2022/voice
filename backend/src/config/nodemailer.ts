import nodemailer, { Transporter } from "nodemailer";

const user = process.env.SMTP_USER as string;
const password = process.env.SMTP_PASS as string;

if (!user || !password) {
    throw new Error("SMTP_USER and SMTP_PASS must be set in environment variables");
}

const transporter: Transporter = nodemailer.createTransport({
    host: "smtp-relay.brevo.com",
    port: 587,
    secure: false, // use TLS
    auth: {
        user,
        pass: password,
    },
});

export { transporter };
