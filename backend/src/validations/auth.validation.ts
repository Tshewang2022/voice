import Joi from 'joi';

const registerUserSchema = Joi.object({
    first_name: Joi.string().min(3).max(50).required(),
    last_name: Joi.string().min(3).max(50).required(),
    email: Joi.string().email().required(),
    phone: Joi.string().min(8).required(),
    password: Joi.string().min(3).required(),
    otp:Joi.number().required()
})

const loginUserSchema = Joi.object({
    phone: Joi.string().min(8).required(),
    password: Joi.string().min(3).required(),
})

const validateEmailSchema = Joi.object({
    email: Joi.string().email().required(),
})
export { registerUserSchema, loginUserSchema, validateEmailSchema };