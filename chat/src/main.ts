import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';
import { OPTIONS } from './main.options';

const logger = new Logger('Blog');

async function bootstrap() {
  const app = await NestFactory.createMicroservice(AppModule, OPTIONS );
  await app.listen(() => logger.log('Chat microservice is listening'));
}
bootstrap();