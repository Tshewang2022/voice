import { Router } from "express";
import { getBlockedUsers, updateProfile, deactivateAccount, blockUser } from "../../controllers/profile/update.settings";

const settings = Router();
settings.post('/update-profile', updateProfile);
settings.get('/all-blocked-users',getBlockedUsers);
settings.post('/deactivate-account', deactivateAccount);
settings.post('/block-user', blockUser)

export {settings};