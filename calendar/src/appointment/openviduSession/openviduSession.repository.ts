import { Repository, EntityRepository } from "typeorm";
import {  Logger, InternalServerErrorException } from "@nestjs/common";
import {OpenViduSession} from "./openviduSession.entity";


@EntityRepository(OpenViduSession)
export class OpenViduSessionRepository extends Repository<OpenViduSession> {

    private logger = new Logger('OpenViduSessionRepository');
   
    async createSession(sessionDetails: any, isAttenderAvailable: boolean): Promise<any> {

        const { doctorKey, sessionName, sessionId, appointmentId } = sessionDetails;
        let openSession: OpenViduSession;
        
    
        try {
            if(isAttenderAvailable) {
                openSession = await this.findOne({
                    where : {
                        appointmentId : appointmentId
                    }
                });
            } else {
                openSession = await this.findOne({
                    where : {
                        doctorKey : doctorKey
                    }
                });
            }
            if(openSession){
                openSession.sessionName = sessionName;
                openSession.sessionId = sessionId;
                if(isAttenderAvailable)
                openSession.appointmentId = appointmentId;

                await this.update({doctorKey : doctorKey, openviduSessionId : openSession.openviduSessionId }, openSession); 
                return openSession.openviduSessionId;
            } else {

                openSession = new OpenViduSession();
                
                openSession.doctorKey = doctorKey;
                openSession.sessionName = sessionName;
                openSession.sessionId = sessionId;
                if(isAttenderAvailable)
                openSession.appointmentId = appointmentId;
                const app : OpenViduSession =  await this.save(openSession);
                return app.openviduSessionId;
            }  
        } catch (error) {
            if (error.code === "22007") {
                this.logger.warn(`OpenVidu session date is invalid ${sessionId} data`);
            } else {
                this.logger.error(`Unexpected Openvidu session save error` + error.message);
                throw new InternalServerErrorException();
            }
        }
    }

}