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
    console.log('Exx >>>>>>-----------------------' +error);
    return throwError(exceptionError)
    // return super.catch(exception, host);
  }
}