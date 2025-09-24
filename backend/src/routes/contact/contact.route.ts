import { getContactList, createContactList } from "../../controllers/contactlist.controller";

import {Router } from 'express';
const contactRouter = Router();
contactRouter.get('/get-contact', getContactList);
contactRouter.post('/create-contact', createContactList);

export {contactRouter};