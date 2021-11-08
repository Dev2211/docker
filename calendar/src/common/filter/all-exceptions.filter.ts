import { Catch, ArgumentsHost } from '@nestjs/common';
import { BaseRpcExceptionFilter } from '@nestjs/microservices';
import { throwError } from 'rxjs';

@Catch()
export class AllExceptionsFilter extends BaseRpcExceptionFilter {
  catch(  exceptionError :  any, host: ArgumentsHost) {
    // const exceptionError = exception.getError() as any
    const { response = {}, ...error } = {
      ...exceptionError,
      error: exceptionError.response.error,
      message: exceptionError.response.message,
      status: exceptionError.response.statusCode,
    }
    return throwError(error)
    // return super.catch(exception, host);
  }
}