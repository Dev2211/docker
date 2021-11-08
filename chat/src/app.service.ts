import { Injectable } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

@Injectable()
export class AppService {

  @MessagePattern({ cmd: 'create' })
  getHello(): string {
    return 'Hello sir from chat';
  }
}
