import { sign, SignOptions } from "jsonwebtoken";
import * as dotenv from "dotenv";

dotenv.config();

const ACCESS_TOKEN_SECRET = process.env.JWT_ACCESS_SECRET as string || "voiceapp" ; // there is high chance it might come undefined;
const REFRESH_TOKEN_SECRET = process.env.JWT_REFRESH_SECRET as string || "voiceapp"; // decrypt token, this should be included;

/**
 * Generate a JWT token
 * @param userId string
 * @param secret string
 * @param options SignOptions
 */
const generateToken = (userId: string, secret: string, options: SignOptions): string => {
  const payload = { userId }; // you can extend with roles, email, etc.
  return sign(payload, secret, options);
};

/**
 * Generate both Access & Refresh tokens
 */
const generateAuthToken = (userId: string) => {
  const refreshToken = generateToken(userId, REFRESH_TOKEN_SECRET, { expiresIn: "12d" });
  const accessToken = generateToken(userId, ACCESS_TOKEN_SECRET, { expiresIn: "1h" });

  return {
    accessToken,
    refreshToken,
  };
};

export { generateAuthToken };
