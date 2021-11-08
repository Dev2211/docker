import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthController } from './controller/auth.controller';
import { UserService } from './service/user.service';
import { ConfigService } from './service/config.service';
import { ClientProxyFactory } from '@nestjs/microservices';
import { JwtStrategy } from './common/jwt/jwt.strategy';
import { PassportModule } from '@nestjs/passport';
import { UserController } from './controller/user.controller';
import { ChatController } from './controller/chat.controller';
import { RolesGuard } from './common/guard/roles.guard';
import { APP_GUARD } from '@nestjs/core';
import { CalendarController } from './controller/calendar.controller';
import { CalendarService } from './service/calendar.service';
import { HealthCheckService } from './service/health-check.service';
import { VideoService } from './service/video.service';
import { VideoGateway } from './gateway/video.gateway';
import { JwtModule } from '@nestjs/jwt';
import config from 'config';
import { SharedModule } from './app/shared/shared.module';
import { ScheduleModule } from '@nestjs/schedule';
import {
    Logger,
    MiddlewareConsumer,
    Module,
    NestMiddleware,
    NestModule
} from '@nestjs/common';
import { PaymentReport } from './common/cron/paymentReport.cron';

const jwtConfig = config.get('JWT'); 
@Module({
  imports: [PassportModule.register({ defaultStrategy: "jwt" }), 
  JwtModule.register({
    secret : jwtConfig.secret,
    signOptions : {
      expiresIn : jwtConfig.expiresIn
    }
  }),
  SharedModule,
  ScheduleModule.forRoot()
],
  controllers: [AppController, AuthController, UserController, ChatController, CalendarController],
  providers: [AppService, UserService, CalendarService,
    {
      provide: 'REDIS_SERVICE',
      useFactory: (configService: ConfigService) => {
        return ClientProxyFactory.create(configService.get('redisService'));
      },
      inject: [
        ConfigService
      ]
    },
    ConfigService,
    JwtStrategy,
    {
      provide: APP_GUARD,
      useClass: RolesGuard,
    },
    HealthCheckService,
    VideoService,
    VideoGateway,
    PaymentReport
  ],
})


export class AppModule implements NestModule {
    configure(consumer: MiddlewareConsumer) {
        consumer
            .apply(LoggerMiddleware)
            .forRoutes('*');
    }
}


class LoggerMiddleware implements NestMiddleware {
    private logger: Logger;
    use(req: Request, res: Response, next: Function,) {
        this.logger = new Logger('AppModule');
        console.log("Request Url--> ", req['originalUrl'])
        this.logger.log('Request Url--> ', req['originalUrl'])
        next();
    }
}


