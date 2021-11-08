import { Transport, MicroserviceOptions } from '@nestjs/microservices';
import { NestMicroserviceOptions } from '@nestjs/common/interfaces/microservices/nest-microservice-options.interface';


export const OPTIONS: NestMicroserviceOptions & MicroserviceOptions = {
    transport: Transport.REDIS,
    options: {
      url: 'redis://localhost:6379',
    },
  };