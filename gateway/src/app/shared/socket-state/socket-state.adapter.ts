import { INestApplicationContext, WebSocketAdapter } from '@nestjs/common';
import { IoAdapter } from '@nestjs/platform-socket.io';
import socketio from 'socket.io';
import { JwtService } from '@nestjs/jwt';
import { RedisPropagatorService } from '@app/shared/redis-propagator/redis-propagator.service';

import { SocketStateService } from './socket-state.service';
import { UserService } from '@src/service/user.service';
import {CONSTANT_MSG} from 'common-dto';

interface TokenPayload {
  readonly userId: string;
  readonly data : any ;
}

export interface AuthenticatedSocket extends socketio.Socket {
  auth: TokenPayload;

}

export class SocketStateAdapter extends IoAdapter implements WebSocketAdapter {
  public constructor(
    private readonly app: INestApplicationContext,
    private readonly socketStateService: SocketStateService,
    private readonly redisPropagatorService: RedisPropagatorService,
    private readonly jwtService : JwtService,
    private readonly userService : UserService
  ) {
    super(app);
  }

  public create(port: number, options: socketio.ServerOptions = {}): socketio.Server {
    const server = super.createIOServer(port, options);
    this.redisPropagatorService.injectSocketServer(server);

    server.use(async (socket: AuthenticatedSocket, next) => {
      const token = socket.handshake.query?.token || socket.handshake.headers?.authorization;

      if (!token) {
        return next(new Error('Authentication error'));
      }
     try {
        const jwtPayload: any = await this.jwtService.verifyAsync(token);
        if(jwtPayload){
          if(jwtPayload.permission === "CUSTOMER"){
            socket.auth = {
              userId: jwtPayload.permission+'_'+jwtPayload.patientId,
              data: jwtPayload
            };
          } else if(jwtPayload.permission === "ATTENDER") {
            socket.auth = {
              userId: jwtPayload.permission+'_'+jwtPayload.appId,
              data: jwtPayload,
            };
          } else {
            socket.auth = {
              userId: jwtPayload.role.indexOf('DOCTOR') != -1 ? 'DOCTOR'+'_'+jwtPayload.userId : jwtPayload.role.indexOf('ADMIN') != -1 ? 'ADMIN'+'_'+jwtPayload.userId : jwtPayload.role.indexOf('DOC_ASSISTANT') != -1 ? 'DOC_ASSISTANT'+'_'+jwtPayload.userId : 'DOCTOR'+'_'+jwtPayload.userId,
              data: jwtPayload,
            };
          }
         return next();
        }else {
          return next(new Error('Authentication error'));
        }
        
      } catch (e) {
        return next(e);
      }
    });

    return server;
  }

  public bindClientConnect(server: socketio.Server, callback: Function): void {
    server.on('connection', (socket: AuthenticatedSocket) => {
      if (socket.auth) {
        this.socketStateService.add(socket.auth.userId, socket);
        console.log("connection >> " +  socket.auth.userId);
        var socketList = this.socketStateService.get(socket.auth.userId);
        console.log("Connection count ");
        console.log(socketList.length);
        this.updateDoctorAndPatient(socket.auth.data, CONSTANT_MSG.LIVE_STATUS.ONLINE);
        socket.on('disconnect', () => {
          this.socketStateService.remove(socket.auth.userId, socket);
          socketList = this.socketStateService.get(socket.auth.userId);
          console.log("disconnect >> " +  socket.auth.userId);
          console.log("Disconnect count ");
          console.log(socketList.length);
          if(socketList.length === 0){
            this.updateDoctorAndPatient(socket.auth.data, CONSTANT_MSG.LIVE_STATUS.OFFLINE);
          }
          socket.removeAllListeners('disconnect');
        });
      }
      callback(socket);
    });
  }

  public async updateDoctorAndPatient(userInfo, status){
    if(userInfo.permission === "CUSTOMER"){
     const updatedStatus = await this.userService.updateDoctorAndPatient(CONSTANT_MSG.ROLES.PATIENT, userInfo.patientId, status, 0);
    }else {
      const updatedStatus = await this.userService.updateDoctorAndPatient(CONSTANT_MSG.ROLES.DOCTOR, userInfo.doctor_key, status, 0);
    }
  }

  
}
