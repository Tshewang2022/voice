import { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";
import asyncHandler from 'express-async-handler';
import { updateProfileSchema } from "../../validations/setting.validation";
import ApiError from "../../utils/ApiError";
const prisma =new PrismaClient();

// proper handling of error from backend, it does not expose  the backend design(db, and schema);
// profile update-> name, email, phone, and password, profile_image

const updateProfile =asyncHandler(async(req:Request, res:Response)=>{
    const {error, value }= updateProfileSchema.validate(req.body);
    if(error){
        throw new ApiError(400, error.details[0].message);
    }
    const {first_name, last_name, email, phone} = value;
    
    const user = await prisma.users.findUnique({
        where:{phone:phone}, select:{id:true, email:true, first_name:true, last_name:true, phone:true}
    })
    // if this code get exe, there is critical issue in the design;
    if(!user){
        throw new ApiError(404, 'User not fouud');
    }

    const updateDetails = await prisma.users.update({
        where:{phone:phone}, 
        data:{
            first_name:first_name,
            last_name:last_name,
            email:email,
            phone:phone
        }
    })

    res.status(200).json({
        success:true,
        message:"Acccount updated successfully",
        data: updateDetails
    })

})
// all the following need to have the database table;

// biometric login // should be implemented only frontend code.

// privacy settings

// blocked users

// delete account => account_status=> inactive;
export{updateProfile};