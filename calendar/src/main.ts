import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';
import { OPTIONS } from './main.options';

async function bootstrap() {

  const logger = new Logger('bootstrap');

  const app = await NestFactory.createMicroservice(AppModule, OPTIONS );
  await app.listen(() => logger.log('Calendar microservice is listening'));
}
bootstrap();
