import { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";
import asyncHandler from 'express-async-handler';
import { deactivateAcctSchema, updateProfileSchema } from "../../validations/setting.validation";
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

// privacy settings
const deactivateAccount =asyncHandler(async(req:Request, res:Response)=>{
    const {error, value} = deactivateAcctSchema.validate(req.body);
    if(error){
        throw new ApiError(400, error.details[0].message);
    }

    // changing account status from is_active to false;
    const {user_id, is_deactivated} = value;
    const user = await prisma.users.findUnique({
        where:{id:user_id}
    })
    if(!user){
        throw new ApiError(404, 'User not found')
    }

    const updateAcctStatus = await prisma.accountSettings.update({
        where:{user_id:user_id},
        data:{
            is_account_deactivated:is_deactivated
        }
    })

    res.status(200).json({
        success:true,
        message:"Account updated successfully",
        data:updateAcctStatus
    })

})

// blocked users// probably need the database for this
const blockUser =asyncHandler(async(req:Request, res:Response)=>{
    const {error,value} = req.body;
})

// delete account => account_status=> inactive;
// you cannot permantly delete the account, just move them the to achieve part of the db
// even if you delete the social media, it really never get deleted from the server, because they need your information

export{updateProfile, deactivateAccount};