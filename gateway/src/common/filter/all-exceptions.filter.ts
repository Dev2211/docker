import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  ConflictException,
} from '@nestjs/common';
import { BaseExceptionFilter } from '@nestjs/core/exceptions/base-exception-filter';

@Catch()
export class AllExceptionsFilter extends BaseExceptionFilter {
  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();


    if(exception instanceof ConflictException){

      const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;

    response.status(status).json({
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
      message : exception
    });
    }else {
      
    const status =
    exception instanceof HttpException
      ? exception.getStatus()
      : HttpStatus.INTERNAL_SERVER_ERROR;

  response.status(status).json({
    statusCode: status,
    timestamp: new Date().toISOString(),
    path: request.url,
    message : exception
  });
    }

  }
}