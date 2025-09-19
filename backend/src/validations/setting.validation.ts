import  Joi from 'joi';

const updateProfileSchema =Joi.object({
    first_name: Joi.string().min(3).max(50).required(),
    last_name: Joi.string().min(3).max(50).required(),
    email: Joi.string().email().required(),
    phone: Joi.string().min(8).required(),
})

export{updateProfileSchema};