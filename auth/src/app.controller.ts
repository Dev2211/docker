import { Controller, Logger, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { MessagePattern } from '@nestjs/microservices';
import { HealthCheckMicroServiceInterface } from 'common-dto';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  
  @MessagePattern({ cmd: 'auth_service_healthCheck' })
  getAuth(): HealthCheckMicroServiceInterface {
    console.log("Hit to auth to check");
   return { success : true};
 }


  
}
