import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';
import { OPTIONS } from './main.options';
import { Transport, MicroserviceOptions } from '@nestjs/microservices';
import { NestMicroserviceOptions } from '@nestjs/common/interfaces/microservices/nest-microservice-options.interface';

const logger = new Logger('Blog');

async function bootstrap() {
  const app = await NestFactory.createMicroservice(AppModule, OPTIONS );
  await app.listen(() => logger.log('Auth microservice is listening'));
  
  // const app1 = await NestFactory.createMicroservice<MicroserviceOptions>(AppModule, {
  //   transport: Transport.REDIS,
  //   options: {
  //     url: 'redis://localhost:6379',
  //   },
  // });
}
bootstrap();