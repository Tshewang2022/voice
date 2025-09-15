import { PrismaClient } from '@prisma/client';
import { Request, Response } from 'express';
import asyncHandler from 'express-async-handler';
import { get, setWithExpiry } from '../config/redis.config';
import ApiError from '../utils/ApiError';
import bcrypt from 'bcryptjs';

import { registerUserSchema, loginUserSchema } from '../validations/auth.validation';

const prisma = new PrismaClient();
// this code has to be optimized
// otp should be stored only for the 30 seconds
// should be done, for the login and register today, with the load testing 
// timing should be bit more strict from today
// The registration process should be as short as possible
const registerUser = asyncHandler(async (req: Request, res: Response) => {
    const { error, value } = registerUserSchema.validate(req.body);
    if (error) {
        throw new ApiError(400, error.details[0].message);
    }

    const { first_name, last_name, email, password, phone } = value;

    // Check if user exists in cache first (faster lookup)
    const cachedUser = await get(`user:phone:${phone}`);
    if (cachedUser) {
        throw new ApiError(409, 'User already exists');
    }

    // Check if user exists in database
    const existingUser = await prisma.users.findUnique({
        where: { phone: phone }
    });

    if (existingUser) {
        // Cache the existing user info to avoid future DB queries
        await setWithExpiry(`user:phone:${phone}`, JSON.stringify({ exists: true }), 3600); // Cache for 1 hour
        throw new ApiError(409, 'User already exists');
    }

    // Hash password with higher salt rounds for better security
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

    // Cache the user data for future lookups
    await setWithExpiry(`user:phone:${phone}`, JSON.stringify(newUser), 3600); // Cache for 1 hour
    await setWithExpiry(`user:id:${newUser.id}`, JSON.stringify(newUser), 3600);
    res.status(201).json({
        success: true,
        message: 'Account registered successfully',
        data: newUser
    });
});

// Don't forget to handle Prisma client cleanup
process.on('beforeExit', async () => {
    await prisma.$disconnect();
});

export { registerUser };