import { PrismaClient } from "@prisma/client";
import {Request, Response} from 'express';
import asyncHandler from "express-async-handler";
import { createContactListSchema, getContactListSchema } from "../validations/contactlist.validation";
import ApiError from "../utils/ApiError";

// will run the hacking  script
// the code is getting exec, but it is throwing like the system error
const prisma = new PrismaClient();

const getContactList =asyncHandler(async(req:Request, res:Response)=>{
    const {error, value} = getContactListSchema.validate(req.body);
    if(error){
        throw new ApiError(400, error.details[0].message)
    }
    
    const {user_id} = value;
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
   const user = await prisma.contactList.findFirst({where:{phone:phone}});
   if(user){
    throw new ApiError(409, 'Phone number already added');
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
        message:"Contact created successfully",
        data: newContact,

    });
});

export {getContactList, createContactList};