import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { MessagePattern } from '@nestjs/microservices';
import { Observable } from 'rxjs';
import { HealthCheckMicroServiceInterface } from 'common-dto';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  
  @MessagePattern({ cmd: 'chat_service_healthCheck' })
  getAuth(): HealthCheckMicroServiceInterface {
    console.log("Hit to auth to check");
   return { success : true};
 }
  

}
