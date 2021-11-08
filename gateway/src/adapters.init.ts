import { INestApplication } from '@nestjs/common';
import { RedisPropagatorService } from '@app/shared/redis-propagator/redis-propagator.service';
import { SocketStateAdapter } from '@app/shared/socket-state/socket-state.adapter';
import { SocketStateService } from '@app/shared/socket-state/socket-state.service';
import { JwtService } from '@nestjs/jwt';
import { UserService } from './service/user.service';


export const initAdapters = (app: INestApplication): INestApplication => {
  const socketStateService = app.get(SocketStateService);
  const redisPropagatorService = app.get(RedisPropagatorService);
  const jwtService = app.get(JwtService);
  const userService = app.get(UserService)

  app.useWebSocketAdapter(new SocketStateAdapter(app, socketStateService, redisPropagatorService, jwtService, userService));
  app.enableCors();

  return app;
};
