import {
  Injectable,
  Inject,
  UseFilters,
  RequestTimeoutException,
  OnModuleInit,
  OnModuleDestroy,
} from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import {
  UserDto,
  DoctorDto,
  HealthCheckMicroServiceInterface,
  PatientDto,
  HospitalDto,
} from 'common-dto';
import { Observable, throwError, TimeoutError, of } from 'rxjs';
import { timeout, catchError } from 'rxjs/operators';
import { HealthCheckService } from './health-check.service';

@Injectable()
export class UserService implements OnModuleInit, OnModuleDestroy {
  constructor(
    @Inject('REDIS_SERVICE') private readonly redisClient: ClientProxy,
    private readonly healthCheckService: HealthCheckService,
  ) {}

  async onModuleInit() {
    this.redisClient.connect();
  }

  onModuleDestroy() {
    this.redisClient.close();
  }

  public async signUp(userDto: UserDto): Promise<any> {
    if (await this.healthCheckService.checkAuthService()) {
      const userDtoRes = await this.redisClient
        .send({ cmd: 'auth_user_signUp' }, userDto)
        .pipe(
          catchError((err) => {
            // console.log(err);
            // return of({ error: err.message ? err.message : 'Auth service is in offline' })
            return throwError(err);
          }),
        )
        .toPromise();
      return userDtoRes;
    } else {
      return { error: 'Auth service is in offline' };
    }
  }

  public validateEmailPassword(loginDto: UserDto): Observable<any> {
    return this.redisClient.send(
      { cmd: 'auth_user_validate_email_password' },
      loginDto,
    );
  }

  public findUserByEmail(email: string): Observable<any> {
    return this.redisClient.send({ cmd: 'auth_user_find_by_email' }, email);
  }

  public findUserByPhone(phone: string): Observable<any> {
    return this.redisClient.send({ cmd: 'auth_patient_find_by_phone' }, phone);
  }

  public usersList(): Observable<any> {
    return this.redisClient.send({ cmd: 'auth_user_list' }, '');
  }

  public doctorList(id): Observable<any> {
    return this.redisClient.send({ cmd: 'auth_doctor_list' }, id);
  }

  public doctorView(doctorDto: DoctorDto): Observable<any> {
    return this.redisClient.send({ cmd: 'auth_doctor_view' }, doctorDto);
  }

  public doctorsLogin(userDto: UserDto): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_doctor_login' }, userDto)
      .toPromise();
  }

  public doctorsResetPassword(userDto: UserDto): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_doctor_reset_password' }, userDto)
      .toPromise();
  }

  public patientLogin(patientDto: PatientDto): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_patient_login' }, patientDto)
      .toPromise();
  }

  public patientRegistration(patientDto: any): Promise<any> {
    const patient = this.redisClient
      .send({ cmd: 'auth_patient_registration' }, patientDto)
      .pipe(
        catchError((err) => {
          return throwError(err);
        }),
      )
      .toPromise();
    return patient;
  }

  public findPatientByPhone(phone: string): Observable<any> {
    return this.redisClient.send({ cmd: 'auth_patient_find_by_phone' }, phone);
  }

  public adminDetails(accountKeyArray:any): Promise <any> {
    return this.redisClient.send({cmd: 'admin_details'},accountKeyArray).toPromise();
  }

  public updateDoctorAndPatient(role: string, id: string, status: string, appointmentId: any) {
    let userInfo = {
      role: role,
      id: id,
      status: status,
      appointmentId: appointmentId
    };
    return this.redisClient
      .send({ cmd: 'update_patient_doctor_live_status' }, userInfo)
      .toPromise();
  }
  
  public getDoctorId(doctorKey: string): Promise<any> {
    return this.redisClient.send({ cmd: 'doctor_id' }, doctorKey).toPromise();
  }

  public doctorRegistration(doctorDto: any, user: any): Promise<any> {
    doctorDto.user = user;
    return this.redisClient
      .send({ cmd: 'auth_doctor_registration' }, doctorDto)
      .toPromise();
  }

  public findDoctorByEmail(email: string): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_user_find_by_email' }, email)
      .toPromise();
  }

  public accountRegistration(doctorDto: any, user: any): Promise<any> {
    user.doctorDto = doctorDto;
    return this.redisClient
      .send({ cmd: 'auth_account_registration' }, user)
      .toPromise();
  }

  public doctorsForgotPassword(userDto: any): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_doctor_forgotpassword' }, userDto)
      .toPromise();
  }

  public patientForgotPassword(patientDto: PatientDto): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_patient_forgotpassword' }, patientDto)
      .toPromise();
  }

  public patientResetPassword(userDto: any): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_patient_resetpassword' }, userDto)
      .toPromise();
  }

  public patientChangePassword(patientDto: any, user: any): Promise<any> {
    patientDto.user = user;
    return this.redisClient
      .send({ cmd: 'auth_patient_changepassword' }, patientDto)
      .toPromise();
  }

  public doctorChangePassword(patientDto: any, user: any): Promise<any> {
    patientDto.user = user;
    return this.redisClient
      .send({ cmd: 'auth_doctor_changepassword' }, patientDto)
      .toPromise();
  }

  public OTPVerification(patientDto: PatientDto): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_patient_otp_verification' }, patientDto)
      .toPromise();
  }

  public patientLoginForPhone(patientDto: PatientDto): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_patient_login_for_phone' }, patientDto)
      .toPromise();
  }

  public sendEmailWithTemplate(data: any): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_send_email_with_template' }, data)
      .toPromise();
  }

  public doctorRegistrationNew(doctorDto: any): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_doctor_registration_new' }, doctorDto)
      .toPromise();
  }

  public updateDoctorTimeZone(user: any, docConfigDto: any): Promise<any> {
    user.docConfigDto = docConfigDto;
    return this.redisClient
      .send({ cmd: 'auth_user_timezone_update' }, user)
      .toPromise();
  }

  public getUserByUserId(user: any): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_get_user_by_userId' }, user)
      .toPromise();
  }

  public doctorSetPasswordByLink(doctorDto:any, email:any): Promise<any> {
    doctorDto.email = email;
    return this.redisClient.send( { cmd: 'auth_doctor_set_password_by_link' }, doctorDto).toPromise();
}

  public patientResetPasswordLink(patientDto: PatientDto): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_patient_reset_passwordlink' }, patientDto)
      .toPromise();
  }

  public updatePatientPassword(patientDto: any, patientId: any): Promise<any> {
    patientDto.patientId = patientId;
    return this.redisClient
      .send({ cmd: 'auth_update_patient_password' }, patientDto)
      .toPromise();
  }

  public doctorsResetPasswordLink(userDto: any): Promise<any> {
    return this.redisClient
      .send({ cmd: 'auth_doctor_reset_password_link' }, userDto)
      .toPromise();
  }
}
