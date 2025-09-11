import { PrismaClient } from '@prisma/client';
import { Request, Response } from 'express';
import asyncHandler = require('express-async-handler');
import ApiError from '../utils/ApiError';
import { registerUserSchema, loginUserSchema } from '../validations/auth.validation';

// i want to write better code every time, test out new ideas, and experiment with it
const prisma = new PrismaClient();

// The registration process should be as short as possible
const registerUser = asyncHandler(async (req: Request, res: Response) => {
    const { error, value } = registerUserSchema.validate(req.body);
    if (error) {
        throw new ApiError(400, error.details[0].message);
    }

    const { first_name, last_name, email, password, otp, phone } = value;

    // this need to stored inside the caches(redis)
    const user = await prisma.users.findUnique({
        where: { phone: phone }
    })
    if (user) {
        throw new ApiError(409, 'User already exist');
    }

    // if the cache miss happened
    // create a new user
    // update the cache
    // display the response

});

export { registerUser };