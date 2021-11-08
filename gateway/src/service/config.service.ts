import { Injectable } from '@nestjs/common';
import { Transport } from '@nestjs/microservices';
import config from 'config';

@Injectable()
export class ConfigService {

    private readonly envConfig: { [key: string]: any } = null;

    constructor() {
      const redisConfig = config.get('redis'); 

      this.envConfig = {};

      this.envConfig.redisService = {
          options: {
              url: `redis://${redisConfig.host}:${redisConfig.port}`,
            },
        transport: Transport.REDIS
      };
    }
  
    get(key: string): any {
      return this.envConfig[key];
    }

}