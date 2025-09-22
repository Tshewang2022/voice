import  Joi from 'joi';

const updateProfileSchema =Joi.object({
    first_name: Joi.string().min(3).max(50).required(),
    last_name: Joi.string().min(3).max(50).required(),
    email: Joi.string().email().required(),
    phone: Joi.string().min(8).required(),
})

const deactivateAcctSchema = Joi.object({
    user_id: Joi.string().required(),
    is_deactivated: Joi.boolean().required()
})

const blockUserSchema = Joi.object({
    user_id: Joi.string().required(),
})

const createBlockList =Joi.object({
    user_id: Joi.string().required(),
    phone: Joi.string().min(8).required(),
})
export{updateProfileSchema, deactivateAcctSchema, blockUserSchema, createBlockList};