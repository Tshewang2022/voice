import express, { Request, Response } from "express";
import { otpRouter } from "./routes/opt";
import {authRouter} from './routes/auth';
// ready to write the production ready code
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use('/api', otpRouter);
app.use('/api', authRouter);


app.get("/", (req: Request, res: Response) => {
    res.send("Hello from TypeScript + Node.js!");
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
