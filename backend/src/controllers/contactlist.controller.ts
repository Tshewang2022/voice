import { PrismaClient } from "@prisma/client";
import {Request, Response} from 'express';
import asyncHandler from "express-async-handler";
import { createContactListSchema, getContactListSchema } from "../validations/contactlist.validation";
import ApiError from "../utils/ApiError";


const prisma = new PrismaClient();
// add to contact list
// get from the contact list
// update the contact list
// scrap the contact list
// need to have the access to the contact list=> then put the phone number into the database
const getContactList =asyncHandler(async(req:Request, res:Response)=>{
    const {error, value} = getContactListSchema.validate(req.body);
    if(error){
        throw new ApiError(400, error.details[0].message)
    }

    const {user_id} = value;
    // definitly need to create a look up table for blocked users and contact list
    // this will most probably give me annoying bug
    const contactList = await prisma.contactList.findMany({where:{user_id:user_id}});

    // this for checking the empty array;
    if(contactList.length === 0){
        throw new ApiError(404, 'No contact list found');
    }
    res.status(200).json({ contactList });

});

const createContactList = asyncHandler(async(req:Request, res:Response)=>{
   const {error, value} =createContactListSchema.validate(req.body);
   if(error){
    throw new ApiError(400, error.details[0].message)
   }

   const {user_id, first_name, last_name, phone} = value;
   const user = await prisma.contactList.findFirst({where:{user_id:user_id}});
   if(user){
    throw new ApiError(404, 'No contact list found');
   }

    const newContact = await prisma.contactList.create({
        data: {
        user_id,
        first_name,
        last_name,
        phone,
        },
    });

    res.status(201).json({
        status: "success",
        data: newContact,
    });
   

});

export {getContactList, createContactList};