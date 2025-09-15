import { setWithExpiry } from '../config/redis.config';
// how can we define the type email
export const generateOpt = async (email: string) => {
    const otp = String(Math.floor(100000 + Math.random() * 900000));
    await setWithExpiry(`otp:${email}`, otp, 3600);

}