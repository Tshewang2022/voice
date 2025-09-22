import { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";
import asyncHandler from 'express-async-handler';
import { blockUserSchema, deactivateAcctSchema, updateProfileSchema, createBlockList } from "../../validations/setting.validation";
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
const deactivateAccount = asyncHandler(async(req:Request, res:Response)=>{
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

// from today onwards, it will be laser focused on one thing, that is creating the chat application
// my dateline is only 1 month left now. need to do more work and put more effort from here onwards;
const getBlockedUsers = asyncHandler(async(req:Request, res:Response)=>{
    const {error, value} = blockUserSchema.validate(req.body);
    if(error){
        throw new ApiError(400, error.details[0].message)
    }
    // user_id, n:n => this will give an issue
    const {user_id} = value;

    // sometimes giving the sync issues;
    const user = await prisma.blockedUser.findMany({
        where:{user_id:user_id}
    })
    if(!user){
        throw new ApiError(404, 'No block list found');
    }

    // else give all the list of blocked list
    res.status(200).json({
        success:true,
        data:user,
        message:"Blocked contact list successfully fetched"
    })

})

// to block users from the chat
const blockUser = asyncHandler(async(req:Request, res:Response)=>{
    const {error, value} = createBlockList.validate(req.body);
    if(error){
        throw new ApiError(400, error.details[0].message)
    }
    const {user_id, phone} = value;
    const findUserByPhone = await prisma.blockedUser.findFirst({
        where: { phone: phone }
    })

    if (findUserByPhone) {
        // User is already blocked
        res.status(400).json({ message: "User is already blocked." });
    } else {
        // Block the user
        const blockedUser = await prisma.blockedUser.create({
            data: { user_id, phone }
        });
    res.status(201).json({ message: "User blocked successfully.", blockedUser });
    }
})

export{updateProfile, deactivateAccount, getBlockedUsers, blockUser};