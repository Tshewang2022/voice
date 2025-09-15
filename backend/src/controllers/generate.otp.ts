import { Response, Request } from 'express';
import { validateEmailSchema } from '../validations/auth.validation';
import ApiError from '../utils/ApiError';
// complete and robust, authentication system will be build this week
const generateOtp = (req: Request, res: Response) => {
    const { error, value } = validateEmailSchema.validate(req.body);

    if (error) {
        throw new ApiError(400, 'Invalid email')
    }
    const { email } = value;



}

export { generateOtp };