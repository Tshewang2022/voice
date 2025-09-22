import Joi from 'joi';

const getContactListSchema = Joi.object({
    user_id: Joi.string().required()
})

const createContactListSchema = Joi.object({
    user_id: Joi.string().required(),
    first_name: Joi.string().min(3).max(50).required(),
    last_name: Joi.string().min(3).max(50).required(),
    phone: Joi.string().min(8).required(),
})
export {getContactListSchema, createContactListSchema}