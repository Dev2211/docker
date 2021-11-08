import { Repository, EntityRepository } from "typeorm";
import {  Logger, InternalServerErrorException } from "@nestjs/common";
import {OpenViduSessionToken} from "./openviduSessionToken.entity";
import { CONSTANT_MSG } from "common-dto";


@EntityRepository(OpenViduSessionToken)
export class OpenViduSessionTokenRepository extends Repository<OpenViduSessionToken> {

    private logger = new Logger('OpenViduSessionTokenRepository');
   
    async createTokenForDoctorAndPatient(sessionTokenDetails: any, type : string): Promise<any> {

        const {openviduSessionId , token, doctorId, patientId} = sessionTokenDetails;

        let openSessionToken : OpenViduSessionToken;
        let whereCondition= {
            doctorId : doctorId,
            patientId : patientId ? patientId : null
        };

        openSessionToken = await this.findOne({
            where : whereCondition
        });
        try {

            if(openSessionToken){
                openSessionToken.openviduSessionId = openviduSessionId;
                openSessionToken.token = token;
                await this.update(whereCondition, openSessionToken);
                return openSessionToken.openviduSessionTokenId;
            }else {
                openSessionToken = new OpenViduSessionToken();
                openSessionToken.openviduSessionId = openviduSessionId;
                openSessionToken.token = token;
                openSessionToken.doctorId = doctorId;
                if(type === CONSTANT_MSG.ROLES.PATIENT){
                    openSessionToken.patientId = patientId;
                }
                const app =  await openSessionToken.save();  
                return app.openviduSessionTokenId;   
            }
    
        } catch (error) {
            if (error.code === "22007") {
                this.logger.warn(`Openvidu Session Id is invalid ${openviduSessionId} data on session token save`);
            } else {
                this.logger.error(`Unexpected Openvidu session token save error` + error.message);
                throw new InternalServerErrorException();
            }
        }
    }

}