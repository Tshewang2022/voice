import Joi from 'joi';

const registerUserSchema = Joi.object({
    first_name: Joi.string().min(3).max(50).required(),
    last_name: Joi.string().min(3).max(50).required(),
    email: Joi.string().email().required(),
    otp: Joi.number().min(4).required(),
    phone: Joi.string().min(8).required(),
    password: Joi.string().min(3).required(),
})

const loginUserSchema = Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().min(3).required(),
})

export { registerUserSchema, loginUserSchema };