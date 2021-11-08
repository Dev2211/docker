import { Injectable, Inject, RequestTimeoutException } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices/client/client-proxy';
import { HealthCheckMicroServiceInterface, CONSTANT_MSG } from 'common-dto';
import { timeout, catchError } from 'rxjs/operators';
import { TimeoutError } from 'rxjs/internal/util/TimeoutError';
import { throwError } from 'rxjs/internal/observable/throwError';
import { of } from 'rxjs/internal/observable/of';

@Injectable()
export class HealthCheckService {

    constructor(@Inject('REDIS_SERVICE') private readonly redisClient: ClientProxy) {

    }

    async onModuleInit() {
        this.redisClient.connect();
        console.log(`${await this.checkAuthService() ? `${CONSTANT_MSG.AUTH} ${CONSTANT_MSG.SERVICE_ACTIVE_MSG}` : `${CONSTANT_MSG.AUTH} ${CONSTANT_MSG.SERVICE_INACTIVE_MSG}`}`);
        console.log(`${await this.checkCalendarService() ? `${CONSTANT_MSG.CALENDER} ${CONSTANT_MSG.SERVICE_ACTIVE_MSG}` : `${CONSTANT_MSG.CALENDER} ${CONSTANT_MSG.SERVICE_INACTIVE_MSG}`}`);
        console.log(`${await this.checkChatService() ? `${CONSTANT_MSG.CHAT} ${CONSTANT_MSG.SERVICE_ACTIVE_MSG}` : `${CONSTANT_MSG.CHAT} ${CONSTANT_MSG.SERVICE_INACTIVE_MSG}`}`);
    }

    onModuleDestroy() {
        this.redisClient.close();
    }

    async checkAuthService(): Promise<boolean> {
        const authService: HealthCheckMicroServiceInterface = await this.redisClient.send<HealthCheckMicroServiceInterface>({ cmd: "auth_service_healthCheck" }, '')
            .pipe(timeout(1000),
                catchError(val => {
                    console.log(`${CONSTANT_MSG.AUTH} ${CONSTANT_MSG.SERVICE_INACTIVE_MSG}`)
                    return of({ success: false });
                })
            )
            .toPromise();
        return authService.success;
    }

    async checkCalendarService(): Promise<boolean> {
        const calendarService: HealthCheckMicroServiceInterface = await this.redisClient.send<HealthCheckMicroServiceInterface>({ cmd: "calendar_service_healthCheck" }, '')
            .pipe(timeout(1000),
                catchError(val => {
                    console.log(`${CONSTANT_MSG.CALENDER} ${CONSTANT_MSG.SERVICE_INACTIVE_MSG}`)
                    return of({ success: false })
                })
            )
            .toPromise();
        return calendarService.success;
    }

    async checkChatService(): Promise<boolean> {
        const chatService: HealthCheckMicroServiceInterface = await this.redisClient.send<HealthCheckMicroServiceInterface>({ cmd: "chat_service_healthCheck" }, '')
            .pipe(timeout(1000),
                catchError(val => {
                    console.log(`${CONSTANT_MSG.CHAT} ${CONSTANT_MSG.SERVICE_INACTIVE_MSG}`)
                    return of({ success: false })
                })
            )
            .toPromise();
        return chatService.success;
    }
}
