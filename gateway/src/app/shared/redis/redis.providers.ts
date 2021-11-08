import { Provider } from '@nestjs/common';
import Redis from 'ioredis';
import config from 'config';

import { REDIS_PUBLISHER_CLIENT, REDIS_SUBSCRIBER_CLIENT } from './redis.constants';

export type RedisClient = Redis.Redis;
const redisConfig = config.get('redis');

export const redisProviders: Provider[] = [
  {
    useFactory: (): RedisClient => {
      return new Redis({
        host: redisConfig.host,
        port: redisConfig.port,
      });
    },
    provide: REDIS_SUBSCRIBER_CLIENT,
  },
  {
    useFactory: (): RedisClient => {
      return new Redis({
        host: redisConfig.host,
        port: redisConfig.port,
      });
    },
    provide: REDIS_PUBLISHER_CLIENT,
  },
];
