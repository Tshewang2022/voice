import { PrismaClient } from '@prisma/client';
import { Request, Response } from 'express';
import asyncHandler from 'express-async-handler';
import { get, setWithExpiry } from '../config/redis.config';
import { generateAuthToken } from '../utils/token';
import ApiError from '../utils/ApiError';
import bcrypt from 'bcryptjs';

import { registerUserSchema, loginUserSchema } from '../validations/auth.validation';

const prisma = new PrismaClient();
const registerUser = asyncHandler(async (req: Request, res: Response) => {
    const { error, value } = registerUserSchema.validate(req.body);
    if (error) {
        throw new ApiError(400, error.details[0].message);
    }

    const { first_name, last_name, email, password, phone, otp } = value;

    // Check if user exists in cache first (faster lookup)
    const cachedUser = await get(`user:phone:${phone}`);
    if (cachedUser) {
        throw new ApiError(409, 'User already exists');
    }

    // need to optimize this solutions
    const getOtp = await get(`otp:${email}`); 
    if(!getOtp){
        throw new ApiError(404, 'otp from redis cannot be empty');
    }
    // console.log(getOtp, 'otp from the redis'); the data type should be same
    if(getOtp!=otp){
        throw new ApiError(400, 'Invalid OTP'); // this solution is not good
    }
    // authenticate it

    const hashedPassword = await bcrypt.hash(password, 12);

    // Create new user, everything is a art. master it
    const newUser = await prisma.users.create({
        data: {
            first_name,
            last_name,
            email,
            password: hashedPassword,
            phone
        },
        select: {
            id: true,
            first_name: true,
            last_name: true,
            email: true,
            phone: true,
            created_at: true,
            // Exclude password and sensitive fields from response
        }
    });
    res.status(201).json({
        success: true,
        message: 'Account registered successfully',
        data: newUser
    });
});

const loginUser = asyncHandler(async(req:Request, res:Response)=>{
    const {error, value} = loginUserSchema.validate(req.body);
    if (error) {
        throw new ApiError(400, error.details[0].message);
    }

    const {phone, password}= value;
    // check the user
    const user = await prisma.users.findUnique({
        where:{
            phone:phone
        },
    })

    if(!user){
       throw new ApiError(404, 'User not found'); 
    }

    // there is risk where it can introduce bug in here
    const isMatched = await bcrypt.compare(password, user.password);
    if(!isMatched){
        throw new ApiError(401, 'Invalid credentials');
    }

    // genrate token
    const token = generateAuthToken(user.id);
    res.status(200).json({
        success: true,
        message:"Login successfully",
        data: user,// i dont want tonsend everything to the frontend;(only, first_name, last_name, email, and phone);
        token:token
    })

})
// Don't forget to handle Prisma client cleanup
process.on('beforeExit', async () => {
    await prisma.$disconnect();
});

export { registerUser, loginUser };