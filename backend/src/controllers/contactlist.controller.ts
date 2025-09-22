import { PrismaClient } from "@prisma/client";
import {Request, Response} from 'express';
import asyncHandler from "express-async-handler";

const prisma = new PrismaClient();

const ContactList =asyncHandler(async(req:Request, res:Response)=>{
    

})