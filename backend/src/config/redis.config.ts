import { createClient, RedisClientType } from 'redis';
const redisClient: RedisClientType = createClient({
    url: 'redis://localhost:6379',
    socket: {
        connectTimeout: 10000,
        reconnectStrategy: (retries: number): number => {
            // Exponential backoff
            return Math.min(retries * 100, 10000);
        }
    }
});

// this is alot things going in here, need to understand fully
// Add error handling for connection events
redisClient.on('error', (err: Error) => {
    console.error('Redis Client Error:', err);
});

redisClient.on('connect', () => {
    console.log('Redis Client Connected');
});

const getRedisClient = async (): Promise<RedisClientType | null> => {
    try {
        if (!redisClient.isOpen) {
            await redisClient.connect();
            console.log('Redis client connected successfully');
        }
        return redisClient;
    } catch (err) {
        console.error('Failed to connect to Redis:', err);
        return null;
    }
};

const setWithExpiry = async (
    key: string,
    value: string | number | object,
    expiresIn: number
): Promise<string | null> => {
    try {
        const client = await getRedisClient();
        if (!client) {
            throw new Error('Redis client not available');
        }

        // Fixed the type checking logic
        const stringValue = typeof value === 'object' ? JSON.stringify(value) : String(value);
        const result = await client.setEx(key, expiresIn, stringValue);
        return result;
    } catch (err) {
        console.error('Error setting value in Redis:', err);
        return null;
    }
};

const get = async <T = any>(key: string): Promise<T | null> => {
    try {
        const client = await getRedisClient();
        if (!client) {
            throw new Error('Redis client not available');
        }

        const value = await client.get(key);
        if (!value) return null;

        try {
            return JSON.parse(value) as T;
        } catch (parseErr) {
            // If JSON parsing fails, return the raw string value
            console.warn(`Failed to parse JSON for key ${key}, returning raw value`);
            return value as unknown as T;
        }
    } catch (err) {
        console.error('Error fetching data from Redis:', err);
        return null;
    }
};

const del = async (key: string): Promise<number> => {
    try {
        const client = await getRedisClient();
        if (!client) {
            throw new Error('Redis client not available');
        }
        return await client.del(key);
    } catch (err) {
        console.error('Error deleting key from Redis:', err);
        return 0;
    }
};

// Graceful shutdown
const closeRedisConnection = async (): Promise<void> => {
    try {
        if (redisClient.isOpen) {
            await redisClient.quit();
            console.log('Redis connection closed');
        }
    } catch (err) {
        console.error('Error closing Redis connection:', err);
    }
};

export { get, setWithExpiry, del, getRedisClient, closeRedisConnection };