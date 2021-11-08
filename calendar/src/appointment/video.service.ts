import { Injectable, HttpStatus, Logger } from '@nestjs/common';
import { OpenViduSessionTokenRepository } from './openviduSession/openviduSessionToken.repository';
import { OpenViduSessionRepository } from './openviduSession/openviduSession.repository';
import {DoctorRepository} from './doctor/doctor.repository';
import { OpenViduService } from './open-vidu.service';
import { Session } from 'openvidu-node-client';
import { Doctor } from './doctor/doctor.entity';
import { PatientDetails } from './patientDetails/patientDetails.entity';
import { CONSTANT_MSG, queries } from 'common-dto';
import { OpenViduSession } from './openviduSession/openviduSession.entity';
import { OpenViduSessionToken } from './openviduSession/openviduSessionToken.entity';
import {AppointmentRepository} from './appointment.repository';
var moment = require('moment');


@Injectable()
export class VideoService {

    private logger = new Logger('VideoService');

    constructor(private openViduSessionTokenRepository : OpenViduSessionTokenRepository, 
        private openViduSessionRepo : OpenViduSessionRepository, private openViduService : OpenViduService,
        private doctorRepository: DoctorRepository,
        private appointmentRepository:AppointmentRepository){

    }


    async createDoctorSession(doc : Doctor, type: any, appointmentId: any, patientId: any) : Promise<any>{
        try {
            this.logger.log("Create FDoc " + doc.doctorName);

            // check existing session
            let removeSession = await this.removeSessionAndTokenByDoctor(doc, 0);
            this.logger.log("createDoctorSession1" );

            let session : Session = await this.openViduService.createSession();
            this.logger.log("createDoctorSession2" );
            const token = await this.openViduService.createTokenForDoctor(session);
            this.logger.log("createDoctorSession3" );
            const sessionId = session.getSessionId();
            this.logger.log("sessionId " + sessionId);
            let OVSessionData = {
                sessionId : session.getSessionId(),
                sessionName : doc.doctorName + '_'+ new Date().getTime(),
                //sessionName : doc.doctorName + '_'+ moment().valueOf(),
                doctorKey : doc.doctorKey
            }
            this.logger.log("OVSessionData => " + JSON.stringify(OVSessionData));
            const openViduSessionId = await this.openViduSessionRepo.createSession(OVSessionData,  false);
            
            this.logger.log("Token => " + token);
            if(type === 'DOCTOR') {
                const OVsessionTokenDate = {
                    openviduSessionId : openViduSessionId, 
                    token : token,
                    doctorId : doc.doctorId
                }
                this.logger.log("OVsessionTokenDate => " + JSON.stringify(OVsessionTokenDate));
                await this.openViduSessionTokenRepository.createTokenForDoctorAndPatient(OVsessionTokenDate, type);
                return {isToken : true, token : token, isDoctor : true, isPatient : false, sessionId : sessionId, doctorName : doc.doctorName };
            } 
            else {
                const OVsessionTokenDate = {
                    openviduSessionId : openViduSessionId, 
                    token : token,
                    doctorId : doc.doctorId,
                    patientId: patientId
                }
                this.logger.log("OVsessionTokenDate => " + JSON.stringify(OVsessionTokenDate));
                await this.openViduSessionTokenRepository.createTokenForDoctorAndPatient(OVsessionTokenDate, type);
                return {isToken : true, token : token, isDoctor : false, isPatient : true, sessionId : sessionId, patient : patientId, appointmentId : appointmentId, openViduSessionId: openViduSessionId };
            }
        } catch (e) {
            this.logger.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
        
    }

    async createSessionAndTokenByAppId(appointmentDetails, type, userType) {

        if(type === 'createSessionAndToken') {
            let session : Session = await this.openViduService.createSession();
            const token = await this.openViduService.createTokenForDoctor(session);
            const sessionId = session.getSessionId();
            let OVSessionData = {
                sessionId : sessionId,
                sessionName : appointmentDetails.doctor_name + '_'+ new Date().getTime(),
                doctorKey : appointmentDetails.doctorKey,
                appointmentId: appointmentDetails.id,
            }
            const openViduSessionId = await this.openViduSessionRepo.createSession(OVSessionData, true);
            const OVsessionTokenDate = {
                openviduSessionId : openViduSessionId, 
                token : token,
                doctorId : appointmentDetails.doctorId,
                appointmentId: appointmentDetails.id
            }
            this.logger.log("OVsessionTokenDate => " + JSON.stringify(OVsessionTokenDate));
            await this.openViduSessionTokenRepository.createTokenForDoctorAndPatient(OVsessionTokenDate, type);
            return {isToken : true, token : token, isDoctor: userType === CONSTANT_MSG.ROLES.DOCTOR ? true : false, isPatient: userType === CONSTANT_MSG.ROLES.PATIENT ? true : false, isAttender: userType === CONSTANT_MSG.ROLES.ATTENDER ? true : false, sessionId: sessionId, appointmentId: appointmentDetails.id, doctorName: appointmentDetails.doctorName, isSessionAlreadyStarted: false, doctorEmail: appointmentDetails.doctorEmail, patient : appointmentDetails.patient_id,patientName: appointmentDetails.patientName,
                patientEmail: appointmentDetails.patientEmail,
                patientPhone : appointmentDetails.patientPhone,
                attenderName: appointmentDetails.attender_name,
                attenderMobile: appointmentDetails.attender_mobile,
                attenderEmail: appointmentDetails.attender_email,
                doctorKey: appointmentDetails.doctorKey,
                doctorId: appointmentDetails.doctorId };
        }

    }

    async getSessionsByAppId(appointmentDetails: any, userType: string, details: any) {
        try {
            const openViduSession: OpenViduSession = await this.openViduSessionRepo.findOne({ appointmentId: appointmentDetails.id });
            let sessionDetails;
            if (openViduSession) {
                const session: Session = await this.openViduService.findSessionFromSessionId(openViduSession.sessionId);
                const token = await this.openViduService.createTokenForDoctor(session);
                let oViduTokForDocOrAttender = '';
                if (userType === 'PATIENT') {
                    await this.openViduSessionTokenRepository.createTokenForDoctorAndPatient({ openviduSessionId: openViduSession.openviduSessionId, token, doctorId: appointmentDetails.doctorId, patientId: appointmentDetails.patientId }, userType);
                    // if(details.attender.attenderDetails.length) {
                        // const attenderSession: Session = await this.openViduService.findSessionFromSessionId(openViduSession.sessionId);
                        oViduTokForDocOrAttender = await this.openViduService.createTokenForDoctor(session);
                    // }
                    // //If doctor try to join (exist session created by attender) delete the doctor old session.
                    // const openViduSessionList : OpenViduSession[] =  await this.openViduSessionRepo.find({ where: {
                    //     doctorKey : appointmentDetails.doctorKey,
                    //     appointmentId: null,
                    // }});
                    // const sessionIdList : string[] = openViduSessionList.map(value =>  value.sessionId);
                    // const openViduSessionTokenList : OpenViduSessionToken[] = await this.openViduSessionTokenRepository.find({
                    //     where : {
                    //         doctorId : appointmentDetails.doctorId,
                    //         appointmentId: null,
                    //         patientId: null
                    //     }
                    // });
                    // // await this.openViduSessionTokenRepository.remove(openViduSessionTokenList)
                    // openViduSessionTokenList && openViduSessionTokenList.length > 0 && await this.openViduSessionRepo.remove(openViduSessionList);
                    // // await this.openViduService.removeSessionList(sessionIdList);
                }
                return {
                    isToken: true,
                    sessionId: openViduSession.sessionId,
                    token: token,
                    doctorName: appointmentDetails.doctorName || appointmentDetails.doctor_name,
                    isDoctor: userType === CONSTANT_MSG.ROLES.DOCTOR ? true : false,
                    isPatient: userType === CONSTANT_MSG.ROLES.PATIENT ? true : false,
                    isAttender: userType === CONSTANT_MSG.ROLES.ATTENDER ? true : false,
                    appointmentId: appointmentDetails.id,
                    isSessionAlreadyStarted: true,
                    patient: appointmentDetails.patient_id,
                    doctorEmail: appointmentDetails.doctorEmail,
                    attender: details.attender || [],
                    isAttenderAvailable: details.isAttenderAvailable,
                    oViduTokForDocOrAttender: oViduTokForDocOrAttender,
                    patientName: appointmentDetails.patientName,
                    patientEmail: appointmentDetails.patientEmail,
                    patientPhone : appointmentDetails.patientPhone,
                    attenderName: appointmentDetails.attender_name,
                    attenderMobile: appointmentDetails.attender_mobile,
                    attenderEmail: appointmentDetails.attender_email,
                    doctorKey: appointmentDetails.doctorKey,
                    doctorId: appointmentDetails.doctorId,
                    appointment_date :appointmentDetails.appointment_date,
                    startTime : appointmentDetails.startTime,
                    endTime : appointmentDetails.endTime,
                    patientFirstName : appointmentDetails.patientFirstName,
                    patientLastName : appointmentDetails.patientLastName,
                    doctorFirstName : appointmentDetails.doctorFirstName,
                    doctorLastName : appointmentDetails.doctorLastName  
                }
            }
            if (userType === 'PATIENT') {                
                return await this.getSessionTokenByDoctor(details);
            } else if(userType === 'ATTENDER') {
                return {
                    isToken: true,
                    sessionId: '',
                    token: '',
                    doctorName: appointmentDetails.doctorName || appointmentDetails.doctor_name,
                    isDoctor: userType === CONSTANT_MSG.ROLES.DOCTOR ? true : false,
                    isPatient: userType === CONSTANT_MSG.ROLES.PATIENT ? true : false,
                    isAttender: userType === CONSTANT_MSG.ROLES.ATTENDER ? true : false,
                    appointmentId: appointmentDetails.id,
                    isSessionAlreadyStarted: true,
                    patient: appointmentDetails.patient_id,
                    doctorEmail: appointmentDetails.doctorEmail,
                    attender: appointmentDetails.attender || [],
                    isAttenderAvailable: true,
                    oViduTokForDocOrAttender: '',
                    patientName: appointmentDetails.patientName,
                    patientEmail: appointmentDetails.patientEmail,
                    patientPhone : appointmentDetails.patientPhone,
                    attenderName: appointmentDetails.attender_name,
                    attenderMobile: appointmentDetails.attender_mobile,
                    attenderEmail: appointmentDetails.attender_email,
                    doctorKey: appointmentDetails.doctorKey,
                    doctorId: appointmentDetails.doctorId,
                    appointment_date :appointmentDetails.appointment_date,
                    startTime : appointmentDetails.startTime,
                    endTime : appointmentDetails.endTime,
                    patientFirstName : appointmentDetails.patientFirstName,
                    patientLastName : appointmentDetails.patientLastName,
                    doctorFirstName : appointmentDetails.doctorFirstName,
                    doctorLastName : appointmentDetails.doctorLastName                  }
            }
            sessionDetails = await this.createSessionAndTokenByAppId(appointmentDetails, 'createSessionAndToken', userType);
            return sessionDetails;
        } catch (err) {
            console.log("Error in checkVideoSessionExistOrNot function: ", err);
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                isToken: false,
                message: CONSTANT_MSG.UNEXPECTED_ERROR,
            };
        }
    }

    async getSessionTokenByDoctor(details) {
        const openViduSession : OpenViduSession =  await this.openViduSessionRepo.findOne({doctorKey : details.doc.doctorKey}); 
            if(openViduSession){
                const session : Session = await this.openViduService.findSessionFromSessionId(openViduSession.sessionId);
                const token = await this.openViduService.createTokenForDoctor(session);
                let oViduTokForDocOrAttender = '';
                // if(details.attender.attenderDetails && details.attender.attenderDetails.length) {
                    // const attenderSession: Session = await this.openViduService.findSessionFromSessionId(openViduSession.sessionId);
                    oViduTokForDocOrAttender = await this.openViduService.createTokenForDoctor(session);
                // }
                const sessionId = openViduSession.openviduSessionId;
                let OVsessionTokenDate = {
                    openviduSessionId : sessionId, 
                    token : token,
                    patientId : details.patient.patientId,
                    doctorId : details.doc.doctorId,
                    appointmentId: details.appointmentId
                }
                let dto = {
                    status: 'inSession',
                    patientId: details.patient.patientId,
                }
                await this.doctorRepository.update({ doctorKey: details.doc.doctorKey }, {videoCallDetails: JSON.stringify(dto)});
                openViduSession.appointmentId = details.appointmentId;
                await this.openViduSessionRepo.update({openviduSessionId : openViduSession.openviduSessionId}, openViduSession); 
                await this.openViduSessionTokenRepository.createTokenForDoctorAndPatient(OVsessionTokenDate, CONSTANT_MSG.ROLES.PATIENT);
                this.logger.log("Token => " + token);
                return { isToken : true, token : token, isDoctor : false, isPatient : true, sessionId : sessionId, patient : details.patient.patientId, appointmentId : details.appointmentId, attender : details.attender || [], isAttenderAvailable: details.isAttenderAvailable, oViduTokForDocOrAttender: oViduTokForDocOrAttender};
            } else {
                return {
                    isToken : false,
                    message : "Doctor session not created"
                }
            }
    }

    async createPatientTokenByDoctor(doc : Doctor, patient : PatientDetails, appointmentId:any, attender:any, isAttenderAvailable: boolean) : Promise<any> {
        try {
            if(isAttenderAvailable) {
                return await this.getSessionsByAppId({doctorName: doc.doctorName, doctorKey: doc.doctorKey, id: appointmentId, doctorId : doc.doctorId, patientId : patient.patientId, doctorEmail: doc.email}, 'PATIENT',
                {doc: doc, patient: patient, appointmentId: appointmentId, attender: attender, isAttenderAvailable: isAttenderAvailable});
            } else {
                return this.getSessionTokenByDoctor({doc: doc, patient: patient, appointmentId: appointmentId, attender: attender, isAttenderAvailable: isAttenderAvailable});
            }
        } catch (e) {
            this.logger.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async getPatientToken(doc : Doctor, patientId : number, appointmentId : number) : Promise<any> {
        try {
            const openViduSessionToken : OpenViduSessionToken =  await this.openViduSessionTokenRepository.findOne({where :
                {patientId : patientId, 
                doctorId : doc.doctorId}});
            if(openViduSessionToken){
                const sessionId = openViduSessionToken.openviduSessionId;
                return { isToken : true, token : openViduSessionToken.token, isDoctor : false, isPatient : true, sessionId : sessionId, appointmentId : appointmentId/*, appointmentDetail: [appDetail] */};
            } else if(appointmentId){            
                const openViduSession: OpenViduSession = await this.openViduSessionRepo.findOne({ appointmentId: appointmentId });
                if(openViduSession){
                    const session: Session = await this.openViduService.findSessionFromSessionId(openViduSession.sessionId);
                    const token = await this.openViduService.createTokenForDoctor(session);
                    return { isToken : true, token : token, isDoctor : false, isPatient : true, sessionId : openViduSession.sessionId, appointmentId : appointmentId};
                }
                return { isToken : false, message : "Still Token not created for patient" };
            } else { 
                return { isToken : false, message : "Still Token not created for patient" };
            }
        } catch (e) {
            this.logger.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async updateDocStatusByPatient(doc : Doctor, patientId : number, appointmentId : number, appDetail: any) : Promise<any> {
        try {
            if(appointmentId){
                let sessionData = {
                    status: 'videoSessionReady',
                    doctorKey: doc.doctorKey,
                    doctorId: doc.doctorId,
                    patientId: patientId,
                    appointmentId: appointmentId
                }
                // doc.videoCallDetails = JSON.stringify(sessionData);
                let dto = {
                    videoCallDetails: JSON.stringify(sessionData)
                }
                var values: any = dto;
                await this.doctorRepository.update({ doctorKey: doc.doctorKey }, values);
                return { isToken : true, token : '', isDoctor : false, isPatient : true, sessionId : '', appointmentId : appointmentId, appointmentDetail: [appDetail] };
            }
            else {
                return { isToken : false, message : "Still Token not created for patient" };
            }
        } catch (e) {
            this.logger.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async removePatientToken(doc : Doctor, patientId : number, appointmentId : number, status: string) : Promise<void> {

        const openViduSession : OpenViduSession =  await this.openViduSessionRepo.findOne({doctorKey : doc.doctorKey, appointmentId: appointmentId});
        if(openViduSession) {
            const openViduSessionToken : OpenViduSessionToken =  await this.openViduSessionTokenRepository.findOne({ where: {
                patientId : patientId,
                openviduSessionId: openViduSession.openviduSessionId
            }});
            if(openViduSessionToken) {
                openViduSession.appointmentId = null;
                await this.openViduSessionRepo.update({openviduSessionId: openViduSession.openviduSessionId}, openViduSession); 
                await this.openViduSessionRepo.update({openviduSessionId: openViduSession.openviduSessionId}, openViduSession); 
                await this.openViduSessionRepo.update({openviduSessionId: openViduSession.openviduSessionId}, openViduSession); 
                this.openViduSessionTokenRepository.remove(openViduSessionToken);
                await this.openViduService.removeTokenFromSession(openViduSession.sessionId, openViduSessionToken.token);
                var condition: any = {
                    id: appointmentId
                }
                let dto={
                    status: status
                }
                var values: any = dto;
                var updateAppStatus = await this.appointmentRepository.update( condition, values);
            }
        }
    }

    async removeSessionAndTokenByDoctor(doctor : Doctor,appointmentId:number) : Promise<void> {
        try {
            let sessionWhereCondition = { doctorKey : doctor.doctorKey, appointmentId: appointmentId ? appointmentId : null }
            let sessionTokenWhereCondition = { doctorId : doctor.doctorId }
            const openViduSessionList : OpenViduSession[] =  await this.openViduSessionRepo.find({ where: sessionWhereCondition });
            const sessionIdList : string[] = openViduSessionList.map(value =>  value.sessionId);
            const openViduSessionTokenList : OpenViduSessionToken[] = await this.openViduSessionTokenRepository.find({
                where : sessionTokenWhereCondition
            });
            openViduSessionList && openViduSessionList.forEach(async val => {
                val.appointmentId = null;
                await this.openViduSessionRepo.update(sessionWhereCondition, val);
            })
            await this.openViduSessionTokenRepository.remove(openViduSessionTokenList)
            openViduSessionTokenList && openViduSessionTokenList.length > 0 && await this.openViduSessionRepo.remove(openViduSessionList);
            await this.openViduService.removeSessionList(sessionIdList);
            var condition: any = {
                id: appointmentId
            }
            let dto={
                status:'completed'
            }
            var values: any = dto;
    
            if (appointmentId) {
            var updateAppStatus = await this.appointmentRepository.update( condition, values);
            }
        } catch(err) {
            this.logger.log("Erorr in removeSessionAndTokenByDoctor function : ", err);
        }
    }
   
    async removeSessionAndTokenByAppId(appointmentId:number) : Promise<void> {
        try {
            let sessionWhereCondition = { appointmentId: appointmentId };
            const openViduSessionList : OpenViduSession[] =  await this.openViduSessionRepo.find({ where: sessionWhereCondition });
            // let sessionTokenWhereCondition = { doctorId : doctor.doctorId }
            const sessionIdList : string[] = openViduSessionList.map(value =>  value.sessionId);
            // const openViduSessionTokenList : OpenViduSessionToken[] = await this.openViduSessionTokenRepository.find({
            //     where : sessionTokenWhereCondition
            // });
            openViduSessionList && openViduSessionList.forEach(async val => {
                val.appointmentId = null;
                await this.openViduSessionRepo.update(sessionWhereCondition, val);
            })
            // await this.openViduSessionTokenRepository.remove(openViduSessionTokenList)
            await this.openViduService.removeSessionList(sessionIdList);
        } catch(err) {
            this.logger.log("Erorr in removeSessionAndTokenByDoctor function : ", err);
        }
    }
}
