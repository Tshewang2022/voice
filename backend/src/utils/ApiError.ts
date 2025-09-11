class ApiError extends Error {
    public statusCode: number;
    public isOptional: boolean;

    constructor(statusCode: number, message: string, isOptional: boolean = true, stack: string = '') {
        super(message);
        this.statusCode = statusCode;
        this.isOptional = isOptional;

        if (stack) {
            this.stack = stack;
        } else {
            Error.captureStackTrace(this, this.constructor);
        }
    }
}

export default ApiError; // ← Use this instead of module.exports