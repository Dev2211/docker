import { Injectable, Inject, UseFilters } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { HealthCheckService } from './health-check.service';
import { AllClientServiceException } from 'src/common/filter/all-clientservice-exceptions.filter';
import { Observable } from 'rxjs';


@Injectable()
export class VideoService {

    constructor(@Inject('REDIS_SERVICE') private readonly redisClient: ClientProxy,
                private readonly healthCheckService: HealthCheckService) {
    }

    async onModuleInit() {
    this.redisClient.connect();
    }

    onModuleDestroy() {
        this.redisClient.close();
    }

    @UseFilters(AllClientServiceException)
    public videoDoctorSessionCreate(doctor_key : string) : Promise <any> {
        return this.redisClient.send({ cmd : 'video_doctor_session_create'}, doctor_key).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public createTokenForPatientByDoctor(doctor_key : string, appointmentId : string) : Promise <any> {
        let reqData = {doctorKey : doctor_key, appointmentId : appointmentId};
        return this.redisClient.send({ cmd : 'video_patient_create_token_by_doctor'}, reqData).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public getPatientTokenForDoctor(appointmentId : any, patientId : string) : Promise <any> {
        let reqData = {appointmentId : appointmentId, patientId : patientId};
        // data.patientId =patientId;
        return this.redisClient.send({ cmd : 'video_get_patient_token_for_doctor'}, reqData).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public getAttenderTokenForAppId(appointmentId : any) : Promise <any> {
        let reqData = {appointmentId : appointmentId};
        return this.redisClient.send({ cmd : 'get_Attender_video_token'}, reqData).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public updateDocStatusByPatient(data : any) : Promise <any> {
        // let reqData = {appointmentId : data.appointmentId, patientId : patientId};
        return this.redisClient.send({ cmd : 'update_doctor_status_by_patient'}, data).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public getAppDetailsByPat(data : any, patientId : string) : Promise <any> {
        let reqData = {appointmentId : data.appointmentId, patientId : patientId};
        return this.redisClient.send({ cmd : 'get_app_details_by_patient'}, reqData).toPromise();
    }

    
    @UseFilters(AllClientServiceException)
    public removePatientTokenByDoctor(doctor_key : string, appointmentId : string, status : string) : Promise <any> {
        let reqData = {doctorKey : doctor_key, appointmentId : appointmentId, status : status};
        return this.redisClient.send({ cmd : 'video_remove_patient_token_by_doctor'}, reqData).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public removeSessionAndTokenByDoctor(doctor_key : string,appointmentId:string) : Promise <any> {
        let reqData = {doctorKey : doctor_key, appointmentId : appointmentId};
        return this.redisClient.send({ cmd : 'video_remove_session_token_by_doctor'}, reqData).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public getDoctorAppointments(doctorKey : string, timeZone: string) : Promise <any> {
        var data = {
            doctorKey: doctorKey,
            timeZone: timeZone
        }
        return this.redisClient.send({ cmd : 'get_doctor_appointments'}, data).toPromise();
    }

    // @UseFilters(AllClientServiceException)
    // public getPrescription(doctorKey : string) : Promise <any> {
    //     return this.redisClient.send({ cmd : 'get_prescription_list'}, doctorKey).toPromise();
    // }

    // @UseFilters(AllClientServiceException)
    // public getReport(patientId : any) : Promise <any> {
    //     return this.redisClient.send({ cmd : 'get_report_list'}, patientId).toPromise();
    // }

    @UseFilters(AllClientServiceException)
    public patientUpcomingAppointments(patientId:any,paginationNumber,limit:any, patientDetailFromDb: any) : Promise <any> {
        let user = {
            patientId:patientId,
            paginationNumber:0,
            limit:0,
            timeZone: patientDetailFromDb.time_zone
        }
        return this.redisClient.send({ cmd : 'patient_upcoming_appointments'},user).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public updateConsultationStatus(docKey, appointmentId): Promise <any> {

        let dataObject = {
            docKey : docKey,
            appointmentId: appointmentId
        }
        console.log('dataObject ', dataObject)
        return this.redisClient.send({ cmd : 'consultation_status_update'}, dataObject).toPromise();
    }

  @UseFilters(AllClientServiceException)
  public getPrescription(doctorKey: string): Promise<any> {
    return this.redisClient
      .send({ cmd: 'get_prescription_list' }, doctorKey)
      .toPromise();
  }

  @UseFilters(AllClientServiceException)
  public getReport(doctor_key:any, patientId: any, appointmentId: any): Promise<any> {
    let reqData = { doctor_key: doctor_key, patientId: patientId, appointmentId: appointmentId };
    return this.redisClient
      .send({ cmd: 'get_report_list' }, reqData)
      .toPromise();
  }

  @UseFilters(AllClientServiceException)
    public getPrescriptionDetails(appoinmnetId: Number): Promise<any>  {
        return this.redisClient.send({ cmd: 'get_prescription_details' }, appoinmnetId).toPromise()
    }
}
