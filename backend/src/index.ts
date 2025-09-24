import express, { Request, Response } from "express";
import { otpRouter } from "./routes/opt";
import {authRouter} from './routes/auth';
import { contactRouter } from "./routes/contact/contact.route";
import { settings } from "./routes/setting/user.settings";
// ready to write the production ready code
const app = express();
const PORT = process.env.PORT || 3000;

// how can i optimize this code
app.use(express.json());
app.use('/api/v1', otpRouter);
app.use('/api/v1', authRouter);
app.use('/api/v1', settings);
app.use('/api/v1', contactRouter);


app.get("/", (req: Request, res: Response) => {
    res.send("Hello from TypeScript + Node.js!");
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
