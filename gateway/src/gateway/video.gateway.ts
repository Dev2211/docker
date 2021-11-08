import { UseInterceptors, Logger } from '@nestjs/common';
import { SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { RedisPropagatorInterceptor } from '@app/shared/redis-propagator/redis-propagator.interceptor';
import { Socket, Server } from 'socket.io';
import { VideoService } from '@src/service/video.service';
import socketio from 'socket.io';
import { SocketStateService } from '@app/shared/socket-state/socket-state.service';
import { CONSTANT_MSG } from 'common-dto';
import { UserService } from '@src/service/user.service';
import { CalendarService } from '@src/service/calendar.service'
import { copyFileSync } from 'fs';
var moment = require('moment');

interface TokenPayload {
  readonly userId: string;
  readonly data : any ;
}

export interface AuthenticatedSocket extends socketio.Socket {
  auth: TokenPayload;

}

@UseInterceptors(RedisPropagatorInterceptor)
@WebSocketGateway()
export class VideoGateway {
  
  @WebSocketServer() wss: Server;

  private logger = new Logger('VideoGateway');

  constructor(private readonly videoService : VideoService, private readonly socketStateService : SocketStateService,
    private readonly userService : UserService, private readonly calendarService : CalendarService ){

  }

  @SubscribeMessage('createTokenForDoctor')
  async createTokenForDoctor(client: AuthenticatedSocket, data : string) {
    this.logger.log(`Socket request for create Token for Doctor from Doc-key => ${client.auth.data.doctor_key}`);
    const response : any = await this.videoService.videoDoctorSessionCreate(client.auth.data.doctor_key);
    this.logger.log("response Doctor >>" + JSON.stringify(response));
    client.emit("videoTokenForDoctor", response);
    return response;
  }

  @SubscribeMessage('createTokenForPatientByDoctor')
  async createTokenForPatientByDoctor(client: AuthenticatedSocket, appointmentId : string) {
    this.logger.log(`Socket request for create Token for Patient from Doc-key => ${client.auth.data.doctor_key} and appointmentId => ${appointmentId}` );
    const response : any = await this.videoService.createTokenForPatientByDoctor(client.auth.data.doctor_key, appointmentId);
    this.logger.log("response Patient >>" + JSON.stringify(response));
    if(response.statusCode) {
      response.isDoctorNotAvailable = false;
      response.isPatientNotAvailable = true;
      client.emit("callStatusResponse", response);
    } else {
      let patientSocketList : Socket[] = this.socketStateService.get("CUSTOMER_"+response?.patient);
      this.logger.log("CUSTOMER_,patientSocketList >>" + response);
      patientSocketList.forEach( (val : Socket) => {
        val.emit("videoTokenForPatient", response);
      });
      if(response.isAttenderAvailable && response.isSessionAlreadyStarted){
        // let userDetail = await this.userService.findUserByEmail(response.doctorEmail).toPromise();
        // let patientDocSocketList: Socket[] = this.socketStateService.get("DOCTOR_" + userDetail?.id);
        // response.token = response.oViduTokForDocOrAttender ? response.oViduTokForDocOrAttender : response.token;
        // // response.oViduTokForDocOrAttender && delete response.oViduTokForDocOrAttender;
        // patientDocSocketList.forEach(async (val: Socket) => {
        //   val.emit("videoTokenForDoctor", response);
        // });
      }
        if(!response.attender.isNewAttender && response.attender.attenderDetails[0]){
          let attenderDetails = response.attender.attenderDetails[0];
          // response.oViduTokForDocOrAttender && delete response.oViduTokForDocOrAttender;          
          attenderDetails.video_call_details =  attenderDetails.video_call_details ? JSON.parse(attenderDetails.video_call_details) : null;
          if(attenderDetails.video_call_details) {
            console.log("Attender already in another session");
          } else {
            response.token = response.oViduTokForDocOrAttender ? response.oViduTokForDocOrAttender : response.token;
            let attenderSocketList : Socket[] = this.socketStateService.get("CUSTOMER_"+attenderDetails.patient_id);
            attenderSocketList.forEach( (val : Socket) => {
            val.emit("videoTokenForPatient", response);
          });
          }
        } else if(response.attender.isNewAttender && appointmentId){
          response.token = response.oViduTokForDocOrAttender ? response.oViduTokForDocOrAttender : response.token;
          let attenderSocketList : Socket[] = this.socketStateService.get("ATTENDER_"+appointmentId);
          attenderSocketList.forEach( (val : Socket) => {
            val.emit("videoTokenForPatient", response);
          });
        }      
    }
  }

  @SubscribeMessage('getPatientTokenForDoctor')
  async getPatientToken(client: AuthenticatedSocket, appointmentId : string) {
    this.logger.log(`Socket request get patient token for Doctor from  PatientId => ${client.auth.data.patientId} 
    and appointmentId => ${appointmentId}`);
    let response : any = [];
    if (appointmentId) {

      response = await this.videoService.getPatientTokenForDoctor(appointmentId, client.auth.data.patientId);
      this.logger.log("videoTokenForPatient response >>" + JSON.stringify(response));
    }
      client.emit("videoTokenForPatient", response);
      // let attenderSocketList : Socket[] = this.socketStateService.get("ATTENDER_"+appointmentId);
      //     this.logger.log("ATTENDER_,attenderSocketList >>" + attenderSocketList);
      //     attenderSocketList.forEach( (val : Socket) => {
      //       val.emit("videoTokenForPatient", response);
      //     });

    // client.emit("videoTokenForPatient", response);
  }

  @SubscribeMessage('getAttenderSessionToken')
  async getAttenderToken(client: AuthenticatedSocket, appointmentId : string) {
    this.logger.log(`Socket request get attender token for Doctor from  PatientId => ${client.auth.data.appointmentId} 
    and appointmentId => ${appointmentId}`);
    let response : any = [];
    if (appointmentId == client.auth.data.appId) {
      response = await this.videoService.getAttenderTokenForAppId(appointmentId);
      this.logger.log("videoTokenForAttender response >>" + JSON.stringify(response));
      const userDetail = await this.userService.getDoctorId(response.doctorKey);
      if(userDetail){
        var  timeZone = userDetail.docId[0].time_zone;
      }
      let userTimeZone;
      timeZone = timeZone ? timeZone : '+05:30';
      if(timeZone.includes('+')) {
          userTimeZone = timeZone.split('+')[1];
          response.appointment_date = moment(response.appointment_date).add(response.startTime).format('YYYY-MM-DDTHH:mm:ss');
          response.startTime = moment(response.startTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
          response.endTime = moment(response.endTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
          response.appointment_date = moment(new Date(response.appointment_date)).utcOffset('+' + userTimeZone).format("YYYY-MM-DD");
      } else {
        userTimeZone = timeZone.split('-')[1];
        response.appointment_date = moment(response.appointment_date).add(response.startTime).format('YYYY-MM-DDTHH:mm:ss');
        response.startTime = moment(response.startTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
        response.endTime = moment(response.endTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
        response.appointment_date = moment(new Date(response.appointment_date)).utcOffset('-' + userTimeZone).format("YYYY-MM-DD");
        response.appointment_date = new Date(response.appointment_date);
      }
      this.logger.log("videoTokenForAttender response after timeZone >>" + JSON.stringify(response));
    }
      client.emit("videoTokenForAttender", response);
      
  }

  @SubscribeMessage('updateDoctorSessionStatusByPatient')
  async updateDoctorSessionStatusByPatient(client: AuthenticatedSocket, data : any) {
    this.logger.log(`Socket request update doctor status for patient from  PatientId => ${client.auth.data.patientId} 
    and appointmentId => ${data.appointmentId}`);
    let response : any = [];
    if (data.appointmentId) {
      let appData = await this.videoService.getAppDetailsByPat(data, client.auth.data.patientId);
      if(!appData.statusCode){
        let userDetail = await this.userService.findUserByEmail(appData.DoctorDetails?.email).toPromise();
        appData.appointmentDetails.timeZone = userDetail.timeZone ? userDetail.timeZone : '+05:30';
        appData.appointmentDetails.isPatientStartConsultation = data.isPatientStartConsultation;
        response = await this.videoService.updateDocStatusByPatient(appData.appointmentDetails);
        if(response && response.isToken) {
          let patientDocSocketList: Socket[] = this.socketStateService.get("DOCTOR_" + userDetail?.id);
          patientDocSocketList.forEach(async (val: Socket) => {
              val.emit("videoTokenForDoctor", response);
          });
        } else if(response && response.statusCode) {
          response.isDoctorNotAvailable = true;
          response.isPatientNotAvailable = false;
          client.emit("callStatusResponse", response);
        } else{
          console.log("no response found for this updateDoctorSessionStatusByPatient socket function: ", response);
        }
      } else
      client.emit("callStatusResponse", response);
    } else {
      client.emit("videoTokenForPatient", response);
    }
  }

  @SubscribeMessage('removePatientTokenByDoctor')
  async removePatientTokenByDoctor(client: AuthenticatedSocket, data : any) {
    data.status = data.status ? data.status : CONSTANT_MSG.APPOINTMENT_STATUS.PAUSED;
    this.logger.log(`Socket request remove Patient Token By Doctor from Doc-key => ${client.auth.data.doctor_key} and appointmentId => ${data}` );
    const response:any = await this.videoService.removePatientTokenByDoctor(client.auth.data.doctor_key, data.appointmentId, data.status);
    this.logger.log("response >>" + JSON.stringify(response));
    let patientSocketList : Socket[] = this.socketStateService.get("CUSTOMER_"+response?.patient);
    patientSocketList.forEach( (val : Socket) => {
      val.emit("videoTokenRemoved", {...response, callEndStatus: data.status, appointmentId: data.appointmentId});
    });
    const userDetailFromDb = await this.userService.getUserByUserId(client.auth.data);
    const responseDoc : any = await this.videoService.getDoctorAppointments(client.auth.data.doctor_key, userDetailFromDb.time_zone);
    client.emit("getDoctorAppointments", responseDoc);
    
    if(response && response.attender && !response.attender.isNewAttender && response.attender.attenderDetails[0]){
      let patVideoCallDetails = response.attender.attenderDetails[0].video_call_details ? JSON.parse(response.attender.attenderDetails[0].video_call_details) : response.attender.attenderDetails[0].video_call_details;
      if(!patVideoCallDetails || (patVideoCallDetails && patVideoCallDetails.appointmentId == data.appointmentId)) {
        let attenderSocketList : Socket[] = this.socketStateService.get("CUSTOMER_"+response.attender.attenderDetails[0].patient_id);
        attenderSocketList.forEach( (val : Socket) => {
          val.emit("videoTokenRemoved", {...response, callEndStatus: data.status, appointmentId: data.appointmentId});
        });
      }
    } else if(response && response.attender.isNewAttender && data.appointmentId){
      let attenderSocketList : Socket[] = this.socketStateService.get("ATTENDER_"+data.appointmentId);
      this.logger.log("ATTENDER_,attenderSocketList >>" + attenderSocketList);
      attenderSocketList.forEach( (val : Socket) => {
        val.emit("videoTokenRemoved", {...response, callEndStatus: data.status, appointmentId: data.appointmentId});
      });
    }
  }

  @SubscribeMessage('removeSessionAndTokenByDoctor')
  async removeSessionAndTokenByDoctor(client: AuthenticatedSocket, appointmentId : string) {
    this.logger.log(`Socket request remove Session And Token By Doctor from Doc-key => ${client.auth.data.doctor_key} appId => ${appointmentId}` );
    if(appointmentId) {
      const response:any = await this.videoService.removeSessionAndTokenByDoctor(client.auth.data.doctor_key,appointmentId);
      this.logger.log("response >>" + JSON.stringify(response));
      let patientSocketList : Socket[] = this.socketStateService.get("CUSTOMER_"+response?.patient);
      patientSocketList.forEach( (val : Socket) => {
        val.emit("videoSessionRemoved", response);
      }); //TODO Check if attender is any other call not in this call
      if(!response.attender.isNewAttender && response.attender.attenderDetails[0]){
        let attenderSocketList : Socket[] = this.socketStateService.get("CUSTOMER_"+response.attender.attenderDetails[0].patient_id);
        attenderSocketList.forEach( (val : Socket) => {
          val.emit("videoSessionRemoved", response);
        });
      }else if(response.attender.isNewAttender && appointmentId){
        let attenderSocketList : Socket[] = this.socketStateService.get("ATTENDER_"+appointmentId);
        this.logger.log("ATTENDER_,attenderSocketList >>" + attenderSocketList);
        attenderSocketList.forEach( (val : Socket) => {
          val.emit("videoSessionRemoved", response);
        });
      }
    }
  }

  @SubscribeMessage('getAppointmentListForDoctor')
  async getDoctorAppointments(client: AuthenticatedSocket) {
    this.logger.log(`Socket request get appointments for Doctor from doctorKey => ${client.auth.data.doctor_key}`);
    let response: any = [];

    if (client.auth.data.doctor_key) {
      const userDetailFromDb = await this.userService.getUserByUserId(client.auth.data);
      response = await this.videoService.getDoctorAppointments(client.auth.data.doctor_key, userDetailFromDb.time_zone);
    }
    
    client.emit("getDoctorAppointments", response);
  }

  @SubscribeMessage('updateLiveStatusOfUser')
  async updateLiveStatus(client: AuthenticatedSocket, data : {status : string, appointmentId: any}) {
   let userInfo = client.auth.data;
    if(userInfo.permission === "CUSTOMER"){
      try {
        if(typeof data.appointmentId === 'object'){
          data.appointmentId = data.appointmentId.appointmentId;
        }
        this.logger.log(`Socket request update live status for ${CONSTANT_MSG.ROLES.PATIENT} => ${userInfo.patientId} and status => ${data.status}`);
        if(typeof data.appointmentId === 'object'){
          data.appointmentId = data.appointmentId.appointmentId;
        }
        const updatedStatus = await this.userService.updateDoctorAndPatient(CONSTANT_MSG.ROLES.PATIENT, userInfo.patientId, data.status, data.appointmentId);
        if (updatedStatus && updatedStatus.status) {
            //patient related doc list - today's appoinmnet without doctor duplication
            const patientDetailFromDb = await this.calendarService.getPatientByPatientId(userInfo);
            const patientTodayAppRes: any = await this.videoService.patientUpcomingAppointments(userInfo.patientId, 0, 0, patientDetailFromDb);
            let doctorArr = [0];
        
        
            let patientTodayApp = patientTodayAppRes && (patientTodayAppRes.length || patientTodayAppRes.length === 0) ?
                patientTodayAppRes : patientTodayAppRes.appointments;
        
            patientTodayApp.forEach(async (element) => {
                // this.logger.log(element);
                this.logger.log('doctor = >', element.doctorId);
                if (element.doctorId && (doctorArr.length && !doctorArr.includes(element.doctorId))) {
                    doctorArr.push(element.doctorId);
        
                    let userDetail = await this.userService.findUserByEmail(element.email).toPromise();
                    // docList -> DOCTOR
                    let patientDocSocketList: Socket[] = this.socketStateService.get("DOCTOR_" + userDetail?.id);
                    // emiting response
                    patientDocSocketList.forEach(async (val: Socket) => {
                        const response: any = await this.videoService.getDoctorAppointments(element?.doctorKey, "+05:30");
                    });
                }
        
            });
        }
      } catch (err) {
        console.log("Error in updateLiveStatusOfUser socket function: ", err);
      }
    }else {
      this.logger.log(`Socket request update live status for ${CONSTANT_MSG.ROLES.DOCTOR} => ${userInfo.doctor_key} and status => ${data.status}`);
      const updatedStatus = await this.userService.updateDoctorAndPatient(CONSTANT_MSG.ROLES.DOCTOR, userInfo.doctor_key, data.status, data.status === 'doctorRejectedSession' ? data.appointmentId : 0);
      if(data.status === 'doctorRejectedSession' && updatedStatus && updatedStatus.status) {
        let patientSocketList: Socket[] = this.socketStateService.get("CUSTOMER_" + updatedStatus?.data?.patientId);
        patientSocketList.forEach((val: Socket) => {
          val.emit("callStatusResponse", {isDoctorNotAvailable: true,
            isPatientNotAvailable: false,
          message: CONSTANT_MSG.DOC_NOT_AVAILABLE,});
        });
        if(!updatedStatus.attender.isNewAttender && updatedStatus.attender.attenderDetails[0]){
          let attenderSocketList: Socket[] = this.socketStateService.get("CUSTOMER_" + updatedStatus.attender.attenderDetails[0].patient_id);
          attenderSocketList.forEach((val: Socket) => {
            val.emit("callStatusResponse", {isDoctorNotAvailable: true,
            isPatientNotAvailable: false,
            message: CONSTANT_MSG.DOC_NOT_AVAILABLE,});
          });
        } else if(updatedStatus.attender.isNewAttender && data.appointmentId){          
          let attenderSocketList : Socket[] = this.socketStateService.get("ATTENDER_" + data.appointmentId);
          attenderSocketList.forEach((val: Socket) => {
            val.emit("callStatusResponse", {isDoctorNotAvailable: true,
            isPatientNotAvailable: false,
            message: CONSTANT_MSG.DOC_NOT_AVAILABLE,});
          });
        }
      }
    }
  }

  // Updated consultation status for appoitment
  @SubscribeMessage('updateAppointmentStatus')
  async updateAppointmentStatus(client: AuthenticatedSocket, data :{appointmentId: string}) {

    try {
      this.logger.log(`Socket request to update consultationStatus By Doctor from Doc-key => ${client.auth.data.doctor_key}${data.appointmentId}`);
      const response: any = await this.videoService.updateConsultationStatus(client.auth.data.doctor_key, data.appointmentId);
      this.logger.log("response >>" + JSON.stringify(response));
  
      // After successfull updatation emit to all patient to block appointment details change
      if (response && response.statusCode === 200) {
        let patientSocketList: Socket[] = this.socketStateService.get("CUSTOMER_" + response?.data?.patientId);
        patientSocketList.forEach((val: Socket) => {
          val.emit("updateConsultationStatus", {hasConsultation: true});
        });
      }
    } catch(err) {
      console.log("Error is printing in updateAppointmentStatus socket function: ", err);
    }
  }

  // Patient prescription data sent to patient in video consultation
  @SubscribeMessage('getPrescriptionList')
  async getPriscription(client: AuthenticatedSocket, appointmentId: any, patientId: any) {
    this.logger.log(
      `Socket request get appointments for Doctor from doctorKey => ${client.auth.data.doctor_key} ${ appointmentId.appointmentId} ${patientId.patientId}`,
    );
    
    let patientSocketprescripList: Socket[] = this.socketStateService.get("PATIENT_" + patientId.patientId);
    patientSocketprescripList.forEach((val: Socket) => {
      const response: any =  this.videoService.getPrescription(
        appointmentId.appointmentId,
      );
      client.emit('getPriscription', response);
    });
   
  }

   // doctor get report list from db to video conference
  @SubscribeMessage('getReportList')
  async getReport(client: AuthenticatedSocket, data:{patientId: number,appointmentId: number}) {
    this.logger.log(
      `Socket request get appointments for Doctor from patientKey => ${client.auth.data.doctor_key}${data.patientId, data.appointmentId}`,
    );
   
    let doctorRepSocketList : Socket[] = this.socketStateService.get("DOCTOR_"+ client.auth.data.doctor_key);
       doctorRepSocketList.forEach(async(val : Socket) => { 
      const response: any =  this.videoService.getReport( client.auth.data.doctor_key, data.patientId, data.appointmentId );
      val.emit('getReport', response);
      });
  
  }

  @SubscribeMessage('getPrescriptionDetails')
  async getPrescriptionDetails(client: AuthenticatedSocket, data: {appointmentId: Number}) {
    this.logger.log(
      `Socket request get prescription details for paitent from appointmentId => ${data.appointmentId} & doc_key => ${client.auth.data.doctor_key} `
    )
    const response : any = await this.userService.getDoctorId(client.auth.data.doctor_key);    
    const appointmentDet = await this.calendarService.getAppointmentDetails(data.appointmentId, false)
      if(appointmentDet?.length && appointmentDet[0].patientid ) {
      const getPrescriptionDetailsSocket: Socket [] = this.socketStateService.get(`CUSTOMER_${appointmentDet[0].patientid}`)
       let doctorsocket : Socket[] = this.socketStateService.get(`DOCTOR_${response?.docId[0]?.id}`);
        doctorsocket.forEach(async(i: Socket) => {
        const res: any = await this.videoService.getPrescriptionDetails(data.appointmentId)
        i.emit('getPrescriptionDetails', res)
      })
      getPrescriptionDetailsSocket.forEach(async(i: Socket) => {
        const res: any = await this.videoService.getPrescriptionDetails(data.appointmentId)
        i.emit('getPrescriptionDetails', res)
      })
      if(appointmentDet && appointmentDet[0].attenderId && appointmentDet[0].attenderMobile){
        const attenderDetails = await this.calendarService.getPatientDetails(appointmentDet[0].attenderId);
        let patVideoCallDetails = attenderDetails.videoCallDetails ? JSON.parse(attenderDetails.videoCallDetails) : attenderDetails.videoCallDetails;        
        if(!patVideoCallDetails || (patVideoCallDetails && patVideoCallDetails.appointmentId == data.appointmentId)) { 
          const getPrescriptionDetailsSocketforAttender: Socket [] = this.socketStateService.get(`CUSTOMER_${appointmentDet[0].attenderId}`)
          getPrescriptionDetailsSocketforAttender.forEach(async(i: Socket) => {
          const res: any = await this.videoService.getPrescriptionDetails(data.appointmentId)
          i.emit('getPrescriptionDetails', res)
          })
        }     
      } else if(appointmentDet && !appointmentDet[0].attenderId && appointmentDet[0].attenderMobile){
        const getPrescriptionDetailsSocketforNewAttender: Socket [] = this.socketStateService.get(`ATTENDER_${data.appointmentId}`)
        this.logger.log("ATTENDER_,getPrescriptionDetailsSocketforNewAttender >>" + getPrescriptionDetailsSocketforNewAttender);
        getPrescriptionDetailsSocketforNewAttender.forEach(async(i: Socket) => {
          const res: any = await this.videoService.getPrescriptionDetails(data.appointmentId)
          i.emit('getPrescriptionDetails', res)
        })
      }
  }
}

  @SubscribeMessage('emitPauseStatus')
  async emitPauseStatus(client: AuthenticatedSocket, data: {appointmentId: Number}) {
    this.logger.log(
      `Socket request emit video call pause status for paitent from appointmentId => ${data.appointmentId}`
    )

    const appointmentDet = await this.calendarService.getAppointmentDetails(data.appointmentId, true)
    const appoinmentId = appointmentDet?.[0]?.patientid
    if(appoinmentId) {
      const getPrescriptionDetailsSocket: Socket [] = this.socketStateService.get(`CUSTOMER_${appointmentDet[0].patientid}`)
      // getPrescriptionDetailsSocket.forEach(async(i: Socket) => {
      //   i.emit('emitPauseStatus', { appoinmentId, status: 'CALL_PAUSED_BY_DOCTOR' })
      // })
      getPrescriptionDetailsSocket?.[0]?.emit('emitPauseStatus', { appoinmentId: data.appointmentId, status: 'CALL_PAUSED_BY_DOCTOR' })
    }
  }

}