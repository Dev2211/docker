import {
  Injectable,
  Inject,
  UseFilters,
  OnModuleDestroy,
  OnModuleInit,
  HttpStatus,
} from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { Observable } from 'rxjs';
import {
  UserDto,
  AppointmentDto,
  DoctorConfigCanReschDto,
  PrescriptionDto,
  DocConfigDto,
  WorkScheduleDto,
  PatientDto,
  DoctorDto,
  HospitalDto,
} from 'common-dto';
import { AllClientServiceException } from 'src/common/filter/all-clientservice-exceptions.filter';
import { UserService } from './user.service';
import { patient } from '@src/common/decorator/patientPermission.decorator';

@Injectable()
export class CalendarService implements OnModuleInit, OnModuleDestroy {
  constructor(
    @Inject('REDIS_SERVICE') private readonly redisClient: ClientProxy,
  ) {}

  onModuleInit() {
    this.redisClient.connect();
  }

  onModuleDestroy() {
    this.redisClient.close();
  }

  @UseFilters(AllClientServiceException)
  public setPatientTokenExpiry(patientId: number): Promise<any> {
    return this.redisClient
      .send({ cmd: 'set_patient_token_expiry' }, patientId)
      .toPromise();
  }

  @UseFilters(AllClientServiceException)
  public setDoctorTokenExpiry(doctorId: number): Promise<any> {
    return this.redisClient
      .send({ cmd: 'set_doctor_token_expiry' }, doctorId)
      .toPromise();
  }

  @UseFilters(AllClientServiceException)
  public getPatientTokenExpiry(patientId: number): Promise<any> {
    return this.redisClient
      .send({ cmd: 'get_patient_token_expiry' }, patientId)
      .toPromise();
  }

  @UseFilters(AllClientServiceException)
  public getDoctorTokenExpiry(doctorId: number): Promise<any> {
    return this.redisClient
      .send({ cmd: 'get_doctor_token_expiry' }, doctorId)
      .toPromise();
  }

  @UseFilters(AllClientServiceException)
  public patientTokenExpiryFinal(patientId: number): Promise<any> {
    return this.redisClient
      .send({ cmd: 'patient_token_expiry_final' }, patientId)
      .toPromise();
  }

  @UseFilters(AllClientServiceException)
  public updateDoctorTokenExpiry(doctorId: number): Promise<any> {
    return this.redisClient
      .send({ cmd: 'updated_doctor_token_expiry_final' }, doctorId)
      .toPromise();
  }

    @UseFilters(AllClientServiceException)
    public createAppointment(appointmentDto: any, user: any, userDetailFromDb: any): Promise<any> {
        appointmentDto.user = user;
        appointmentDto.user.timeZone = userDetailFromDb.time_zone;
        appointmentDto.timeZone = userDetailFromDb.time_zone;
        return this.redisClient.send({cmd: 'calendar_appointment_create'}, appointmentDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public doctorList(user, userDetailFromDb: any): Observable<any> {
        user.paginationNumber = 0;
        user.timeZone = userDetailFromDb.time_zone;
        return this.redisClient.send({cmd: 'app_doctor_list'}, user);
    }

    @UseFilters(AllClientServiceException)
    public mobileVersion(): Observable<any> {
        return this.redisClient.send({cmd: 'app_mobile_version'}, {});
    }

    @UseFilters(AllClientServiceException)
    public meetingIdValidation(meetingId:any): Promise <any>  {
        return this.redisClient.send({cmd: 'meeting_id_validation'},meetingId).toPromise();;
    }

    @UseFilters(AllClientServiceException)
    public appointmentAlert(date:any): Promise <any> {
        return this.redisClient.send({cmd: 'appointment_alert'}, date).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public doctorView(user:any,doctorKey:any, userDetailFromDb: any): Observable<any> {
        user.doctorKey = doctorKey;
        user.timeZone = userDetailFromDb.time_zone;
        return this.redisClient.send({cmd: 'app_doctor_view'}, user);
    }
    
    @UseFilters(AllClientServiceException)
    public validateVideoCallAndGenrateSession(appointmentId ): Promise<any> {
        return this.redisClient.send({cmd: 'app_attender_session_create'}, appointmentId).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public getAppointmentByValidation(meetingId,passcode): Promise<any> {
        const validatingIdAndCode ={
            meetingId : meetingId,
            passcode : passcode
        }
        console.log(validatingIdAndCode);
        return this.redisClient.send({cmd: 'get_appointment_by_validation'}, validatingIdAndCode).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public hospitalDetails(accountKey): Observable<any> {
        return this.redisClient.send({cmd: 'app_hospital_details'}, accountKey);
    }


    @UseFilters(AllClientServiceException)
    public doctorCanReschView(user,key): Observable<any> {
        user.doctorKey = key;
        return this.redisClient.send({cmd: 'app_canresch_view'}, user);
    }

    @UseFilters(AllClientServiceException)
    public doctorConfigUpdate(user: any, docConfigDto: any): Observable<any> {
        user.docConfigDto = docConfigDto;
        return this.redisClient.send({cmd: 'app_doc_config_update'}, user);
    }

    @UseFilters(AllClientServiceException)
    public workScheduleEdit(workScheduleDto: any,user:any, userDetailFromDb: any): Observable<any> {
        workScheduleDto.user = user;
        workScheduleDto.timeZone = userDetailFromDb.time_zone;
        return this.redisClient.send({cmd: 'app_work_schedule_edit'}, workScheduleDto);
    }

    @UseFilters(AllClientServiceException)
    public workScheduleView(user: any,key:any, userDetailFromDb: any): Observable<any> {
        user.doctorKey = key;
        user.timeZone = userDetailFromDb.timeZone;
        return this.redisClient.send({cmd: 'app_work_schedule_view'},user);
    }

    @UseFilters(AllClientServiceException)
    public appointmentSlotsView(user: any,doctorKey:any,paginationNumber:number, userDetailFromDb: any): Observable<any> {
        user.doctorKey = doctorKey;
        user.paginationNumber = paginationNumber;
        user.timeZone = userDetailFromDb.time_zone;
        return this.redisClient.send({cmd: 'appointment_slots_view'},user);
    }

    @UseFilters(AllClientServiceException)
    public appointmentReschedule(appointmentDto: any,user:any, userDetailFromDb: any): Promise<any> {
        appointmentDto.user = user;
        appointmentDto.timeZone = userDetailFromDb.time_zone;
        appointmentDto.user.timeZone = userDetailFromDb.time_zone;
        return this.redisClient.send({cmd: 'appointment_reschedule'},appointmentDto).toPromise();
    }

    
    @UseFilters(AllClientServiceException)
    public appointmentCancel(appointmentDto: any,user:any): Promise<any> {
        appointmentDto.user = user;
        return this.redisClient.send({cmd: 'appointment_cancel'},appointmentDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public patientSearch(patientDto: any,user:any): Observable<any> {
        patientDto.user = user;
        return this.redisClient.send({cmd: 'app_patient_search'},patientDto);
    }

    @UseFilters(AllClientServiceException)
    public AppointmentView(user: any,appointmentId: any): Observable<any> {
        user.appointmentId=appointmentId.appointmentId;
        return this.redisClient.send({cmd: 'appointment_view'},user);
    }

    @UseFilters(AllClientServiceException)
    public doctorListForPatients(user: any): Observable<any> {
        return this.redisClient.send({cmd: 'doctor_list_patients'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientInsertion(patientDto: any,patientId:any): Promise<any> {
        patientDto.patientId=patientId;
        return this.redisClient.send({cmd: 'patient_details_insertion'},patientDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public findDoctorByCodeOrName(user: any,codeOrName:any): Observable<any> {
        user.codeOrName = codeOrName;
        return this.redisClient.send({cmd: 'find_doctor_by_codeOrName'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientDetailsEdit(patientDto : any) : Promise <any> {
        return this.redisClient.send({ cmd : 'patient_details_edit'}, patientDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public patientBookAppointment(patientDto : any, user: any) : Promise <any> {
        patientDto.timeZone = user.time_zone;
        return this.redisClient.send({ cmd : 'patient_book_appointment'}, patientDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public viewAppointmentSlotsForPatient(user : any, doctorDto : any, patientDetailFromDb: any) : Observable <any> {
        user.doctorKey = doctorDto.doctorKey;
        user.appointmentDate = doctorDto.appointmentDate;
        user.confirmation = doctorDto.confirmation;
        console.log("patientDetailFromDb.time_zonepatientDetailFromDb.time_zone: ", patientDetailFromDb.time_zone);
        user.timeZone = patientDetailFromDb.time_zone;
        return this.redisClient.send({ cmd : 'patient_view_appointment'}, user);
    }

    @UseFilters(AllClientServiceException)
    public patientPastAppointments(patientId:any,paginationNumber:any,limit:any, patientDetailFromDb: any) : Observable <any> {
        let user = {
            patientId:patientId,
            paginationNumber:paginationNumber,
            limit:limit,
            timeZone: patientDetailFromDb.time_zone
        }
        console.log(" patientDetailFromDb.time_zone patientDetailFromDb.time_zone: ",  patientDetailFromDb.time_zone)
        return this.redisClient.send({ cmd : 'patient_past_appointments'},user);
    }

    
    @UseFilters(AllClientServiceException)
    public patientUpcomingAppointments(patientId:any,paginationNumber,limit:any, patientDetailFromDb: any) : Observable <any> {
        let user = {
            patientId:patientId,
            paginationNumber:paginationNumber,
            limit:limit,
            timeZone: patientDetailFromDb.time_zone
        }
        console.log("jksbdkjfsbkjdfsd")
        return this.redisClient.send({ cmd : 'patient_upcoming_appointments'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientList(doctorKey:any,paginationNumber:any) : Observable <any> {
        let user = {
            doctorKey:doctorKey,
            paginationNumber:paginationNumber
        }
        return this.redisClient.send({ cmd : 'patient_list'},user);
    }

    @UseFilters(AllClientServiceException)
    public doctorPersonalSettingsEdit(user, doctorDto:DoctorDto) : Observable <any> {
        user.doctorDto=doctorDto;
        return this.redisClient.send({ cmd : 'doctor_details_edit'},user);
    }

    @UseFilters(AllClientServiceException)
    public hospitaldetailsView(user, accountKey:any) : Observable <any> {
        user.accountKey=accountKey;
        return this.redisClient.send({ cmd : 'hospital_details_view'},user);
    }

    @UseFilters(AllClientServiceException)
    public hospitaldetailsEdit(user, hospitalDto:HospitalDto) : Observable <any> {
        user.hospitalDto=hospitalDto;
        return this.redisClient.send({ cmd : 'hospital_details_edit'},user);
    }

    @UseFilters(AllClientServiceException)
    public doctorDetails(doctorKey:any,appointmentId:any, patient: any): Observable<any> {
        var details={
            doctorKey:doctorKey,
            appointmentId:appointmentId,
            timeZone: patient.time_zone,
            patientId: patient.patient_id
        }
        return this.redisClient.send({cmd: 'app_doctor_details'}, details);
    }

    @UseFilters(AllClientServiceException)
    public availableSlots(user:any,doctorDto:any, userDetailFromDb: any): Observable<any> {
        user.doctorKey = doctorDto.doctorKey;
        user.appointmentDate = doctorDto.appointmentDate;
        user.confirmation = doctorDto.confirmation;
        user.timeZone = userDetailFromDb.time_zone;
        return this.redisClient.send({cmd: 'app_doctor_slots'}, user);
    }

    @UseFilters(AllClientServiceException)
    public patientDetails(user:any, patientId:any,doctorKey:any) : Observable <any> {
        user.patientId = patientId;
        user.doctorKey = doctorKey;
        return this.redisClient.send({ cmd : 'patient_details'},user);
    }

    @UseFilters(AllClientServiceException)
    public reports(user:any, accountKey:any,paginationNumber:any) : Observable <any> {
        user.accountKey = accountKey;
        user.paginationNumber=paginationNumber;
        return this.redisClient.send({ cmd : 'reports_list'},user);
    }

    @UseFilters(AllClientServiceException)
    public listOfDoctorsInHospital(user:any, accountKey:any) : Observable <any> {
        user.accountKey = accountKey;
        return this.redisClient.send({ cmd : 'list_of_doctors'},user);
    }

    @UseFilters(AllClientServiceException)
    public viewDoctorDetails(user:any, doctorKey:any) : Observable <any> {
        user.doctorKey = doctorKey;
        return this.redisClient.send({ cmd : 'view_doctor_details'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientAppointmentCancel(appointmentDto: any,user:any): Promise<any> {
        appointmentDto.user = user;
        return this.redisClient.send({cmd: 'patient_appointment_cancel'},appointmentDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public detailsOfPatient(user:any, patientId:any,doctorKey:any) : Observable <any> {
        user.patientId = patientId;
        user.doctorKey = doctorKey;
        return this.redisClient.send({ cmd : 'details_of_patient'},user);
    }

    @UseFilters(AllClientServiceException)
    public adminDetailsOfPatient(user:any, patientId:any,accountKey:any) : Observable <any> {
        user.patientId = patientId;
        user.accountKey = accountKey;
        return this.redisClient.send({ cmd : 'admin_details_of_patient'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientUpcomingAppList(user:any, patientDto:any, userDetailFromDb: any) : Observable <any> {
        user.patientDto = patientDto;
        user.timeZone = userDetailFromDb.time_zone;
        return this.redisClient.send({ cmd : 'patient_upcoming_app_list'},user);
    }

    @UseFilters(AllClientServiceException)
    public adminPatientUpcomingAppList(user:any, patientDto:any, userDetailFromDb: any) : Observable <any> {
        user.patientDto = patientDto;
        user.timeZone = userDetailFromDb.time_zone;
        return this.redisClient.send({ cmd : 'admin_patient_upcoming_app_list'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientPastAppList(user:any, patientDto:any, userDetailFromDb: any) : Observable <any> {
        user.patientDto = patientDto;
        user.timeZone = userDetailFromDb.time_zone;
        return this.redisClient.send({ cmd : 'patient_past_app_list'},user);
    }

    @UseFilters(AllClientServiceException)
    public adminPatientPastAppList(user:any, patientDto:any, userDetailFromDb: any) : Observable <any> {
        user.patientDto = patientDto;
        user.timeZone = userDetailFromDb.time_zone;
        return this.redisClient.send({ cmd : 'admin_patient_past_app_list'},user);
    }

    @UseFilters(AllClientServiceException)
    public updatePatOnline(patientId:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'update_patient_online'},patientId).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public updatePatOffline(patientId:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'update_patient_offline'},patientId).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public updatePatLastActive(patientId:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'update_patient_last_active'},patientId).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public updateDocOnline(doctorKey:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'update_doctor_online'},doctorKey).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public updateDocOffline(doctorKey:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'update_doctor_offline'},doctorKey).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public updateDocLastActive(doctorKey:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'update_doctor_last_active'},doctorKey).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public patientGeneralSearch(user:any, patientSearch: any,doctorKey:any): Observable<any> {
        user.patientSearch = patientSearch;
        user.doctorKey = doctorKey;
        return this.redisClient.send({cmd: 'doc_patient_general_search'},user);
    }

    @UseFilters(AllClientServiceException)
    public adminPatientGeneralSearch(user:any, patientSearch: any,accountKey:any): Observable<any> {
        user.patientSearch = patientSearch;
        user.accountKey = accountKey;
        return this.redisClient.send({cmd: 'admin_patient_general_search'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientAppointmentReschedule(appointmentDto: any,user:any, patientDetailFromDb: any): Promise<any> {
        appointmentDto.user = user;
        appointmentDto.timeZone = patientDetailFromDb.time_zone;
        appointmentDto.user.timeZone = patientDetailFromDb.time_zone;
        return this.redisClient.send({cmd: 'patient_appointment_reschedule'},appointmentDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public getPatientDetails(patientId:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'get_patient_details'},patientId).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public appointmentPresentOnDate(user:any, appointmentDate:any, doctorKey: any, patientDetailFromDb: any) : Promise <any> {
        user.appointmentDate = appointmentDate;
        user.doctorKey = doctorKey;
        user.timeZone = patientDetailFromDb.time_zone;
        return this.redisClient.send({ cmd : 'patient_app_date'},user).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public getMilli(time:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'get_time_milli'},time).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public paymentOrder(accountDto:any, user:any) : Promise <any> {
        user.accountDto = accountDto;
        return this.redisClient.send({ cmd : 'get_payment_order'},user).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public paymentVerification(accountDto:any, user:any) : Promise <any> {
        user.accountDto = accountDto;
        return this.redisClient.send({ cmd : 'get_payment_verification'},user).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public paymentReciptDetails(pymntId: String) : Promise<any> {
        return this.redisClient.send({ cmd: 'payment_recipt_details' }, pymntId).toPromise()
    }

    @UseFilters(AllClientServiceException)
    public accountPatientsList(user:any, accountKey:any) : Promise <any> {
        user.accountKey = accountKey;
        return this.redisClient.send({ cmd : 'account_patients_list'},user).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public createPaymentLink(accountDto:any, user:any) : Promise <any> {
        user.accountDto = accountDto;
        return this.redisClient.send({ cmd : 'create_payment_link'},user).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public doctorInsertion(doctorDto:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'doctor_details_insertion'},doctorDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public accountdetailsInsertion(accountDto:any,user:any) : Promise <any> {
        user.accountDto = accountDto;
        return this.redisClient.send({ cmd : 'account_details_insertion'},user).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public listOfHospitals(user:any) : Observable <any> {
        return this.redisClient.send({ cmd : 'list_of_hospitals'},user);
    }

    @UseFilters(AllClientServiceException)
    public prescriptionInsertion(user: any, prescriptionDto:PrescriptionDto, patientDetailFromDb: any) : Observable <any> {
        user.prescriptionDto=prescriptionDto;
        user.timeZone = patientDetailFromDb.time_zone ? patientDetailFromDb.time_zone : '+05:30';
        return this.redisClient.send({ cmd : 'doctor_prescription_insertion'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientReport(reports: any) : Observable <any> {
        return this.redisClient.send({ cmd : 'patient_report'},reports);
    }
    @UseFilters(AllClientServiceException)
    public deleteReport(id: any) : Observable <any> {
        return this.redisClient.send({ cmd : 'patient_delete_report'},id);
    }

    @UseFilters(AllClientServiceException)
    public updateReport(data: any) : Observable <any> {
        return this.redisClient.send({ cmd : 'patient_update_report'},data);
    }

    @UseFilters(AllClientServiceException)
    public reportList(data: any) : Observable <any> {
        return this.redisClient.send({ cmd : 'report_list'},data);
    }

    @UseFilters(AllClientServiceException)
    public uploadFile(files: any) : Observable <any> {
        return this.redisClient.send({ cmd : 'upload_file'},files);
    }
    
    @UseFilters(AllClientServiceException)
    public getDoctorDetails(doctorKey:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'get_doctor_details'},doctorKey).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public getDoctorDetailsByEmail(email:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'get_doctor_details_by_email'},email).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public getHospitalDetails(accountKey:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'get_hospital_details'},accountKey).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public addDoctorSinature(reports: any) : Observable <any> {
        return  this.redisClient.send({ cmd : 'doctor_signature'},reports);
    }

    //Getting patient report in patient detail page
    @UseFilters(AllClientServiceException)
    public patientDetailLabReport(user:any, patientId:any, doctorKey:any) : Observable <any> {
        user.patientId = patientId;
        user.doctorKey = doctorKey;
        return this.redisClient.send({ cmd : 'patient_detail_labreport'},user);
    }

    @UseFilters(AllClientServiceException)
    public getMessageTemplate(data: any) : Promise<any> {
        return this.redisClient.send({ cmd : 'get_message_template'}, data).toPromise();
    }
    
    @UseFilters(AllClientServiceException)
    public sendConfirmationMailOrSMS(data: any): Promise<any> {
        return this.redisClient.send({ cmd: 'send_confirmation_email_or_sms'}, data).toPromise();
    }

   //Getting appointment list report 
   @UseFilters(AllClientServiceException)
   public appoinmentListReport(user:any) : Observable <any> {
   return this.redisClient.send({ cmd : 'appointment_list_report'},user);
   }
   
   //Getting amount list report 
   @UseFilters(AllClientServiceException)
   public amountListReport(user:any) : Observable <any> {
   return this.redisClient.send({ cmd : 'amount_list_report'},user);
   }

   //Send mail appointmnet response
   @UseFilters(AllClientServiceException)
   public sendMailAppointment(sendMail: any, user: any): Promise<any> {
    sendMail.user = user;
    return this.redisClient.send({cmd: 'send_mail_res'}, sendMail).toPromise();
   }

    //Getting advertisment list
    @UseFilters(AllClientServiceException)
    public advertisementList(data: any): Promise<any> {
        return this.redisClient.send({ cmd: 'advertisement_list' }, data).toPromise();
    }

    //get appointment details using appointment id
    @UseFilters(AllClientServiceException)
    public getAppointmentDetails(appoinmnetId: Number, isPausedSession: boolean): Promise<any>  {
        return this.redisClient.send({ cmd: 'get_appointment_details' }, {appoinmnetId, isPausedSession}).toPromise()
    }

    //get appoinment reports using appointment id
    @UseFilters(AllClientServiceException)
    public getAppointmentReports(appoinmnetId: any, user: any) : Promise<any> {
        user.appointmentId = appoinmnetId;
        return this.redisClient.send({ cmd: 'get_appointment_reports' }, user).toPromise()
    }

    @UseFilters(AllClientServiceException)
    public patientDetailsByPatientId(patientId: number) : Promise <any> {
        return this.redisClient.send({ cmd : 'patient_details_patientId'}, patientId).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public createDoctorDetail(doctorDto: DoctorDto) : Promise <any> {
        return this.redisClient.send({ cmd : 'create_doctor_detail'}, doctorDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public uploadDoctorRegistrationIdProof(registrationIdProof: any) : Promise <any> {
        return this.redisClient.send({ cmd : 'upload_doctor_reg_id_proof'}, registrationIdProof).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public getPatientByPatientId(patient: any) : Promise <any> {
        return this.redisClient.send({ cmd : 'auth_get_patient_by_id'}, patient).toPromise();
    }

     @UseFilters(AllClientServiceException)
    public patientDetailsByEmail(email: string) : Promise <any> {
        return this.redisClient.send({ cmd : 'patient_details_email'}, email).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public updateAttenderEmailByPatient(appointmentDto: any, user: any) : Promise <any> {
        appointmentDto.user = user;
        return this.redisClient.send({ cmd : 'update_attender_email_by_patient'}, appointmentDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public insertAttenderDetails(appointmentDto: any, user: any) : Promise <any> {
        appointmentDto.user = user;
        return this.redisClient.send({ cmd : 'insert_attender_email_by_patient'}, appointmentDto).toPromise();
    }
    
    @UseFilters(AllClientServiceException)
    public removeAttenderDetails(appointmentId : number, user: any) : Promise <any> {
        user.appointmentId=appointmentId;
        return this.redisClient.send({ cmd : 'remove_attender_details_by_patient'}, user).toPromise();
    }
}
