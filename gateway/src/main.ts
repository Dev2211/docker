import { NestFactory, HttpAdapterHost } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { Logger } from '@nestjs/common';
import config from 'config';
import { AllExceptionsFilter } from './common/filter/all-exceptions.filter';
import { initAdapters } from './adapters.init';

async function bootstrap() {
  const logger = new Logger('bootstrap');
  const serverConfig = config.get('server');
  const app = await NestFactory.create(AppModule, {cors: true});
  app.enableCors();

  const options = new DocumentBuilder()
    .setTitle('Microservice')
    .setDescription('Microservice Sample API')
    .setVersion('1.0')
    .addBearerAuth(
      { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
      'JWT',
    )
    .build();
  const document = SwaggerModule.createDocument(app, options);
  SwaggerModule.setup('api', app, document);
  const { httpAdapter } = app.get(HttpAdapterHost);
  app.useGlobalFilters(new AllExceptionsFilter(httpAdapter));
  initAdapters(app);
  await app.listen(serverConfig.port);
  logger.log(`Gateway Application is started on ${serverConfig.port}`)
}
bootstrap();
