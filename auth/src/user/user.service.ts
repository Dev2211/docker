import { Injectable, HttpStatus, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UserRepository } from './user.repository';
import {
  UserDto,
  PatientDto,
  DoctorDto,
  CONSTANT_MSG,
  queries,
  Email,
  Sms,
} from 'common-dto';
import { JwtPayLoad } from 'src/common/jwt/jwt-payload.interface';
import { JwtPatientLoad } from 'src/common/jwt/jwt-patientload.interface';
import { JwtService } from '@nestjs/jwt';
import { AccountRepository } from './account.repository';
import { RolesRepository } from './roles.repository';
import { RolePermissionRepository } from './rolesPermission/role_permissions.repository';
import { PermissionRepository } from './permissions/permission.repository';
//import {queries} from "../config/query";
import { UserRoleRepository } from './user_role.repository';
import { PatientRepository } from './patient.repository';
import * as bcrypt from 'bcrypt';
var generator = require('generate-password');
import * as config from 'config';
const emailFromConfig = config.get('virujhEmail');

@Injectable()
export class UserService {
  email: Email;
  sms: Sms;
  constructor(
    @InjectRepository(UserRepository) private userRepository: UserRepository,
    private accountRepository: AccountRepository,
    private rolesRepository: RolesRepository,
    private rolePersmissionRepository: RolePermissionRepository,
    private permissionRepository: PermissionRepository,
    private userRoleRepository: UserRoleRepository,
    private patientRepository: PatientRepository,
    private readonly jwtService: JwtService,
  ) {}

  async signUp(userDto: UserDto): Promise<any> {
    return await this.userRepository.signUP(userDto);
  }

  async validateEmailPassword(userDto: UserDto): Promise<any> {
    const user = await this.userRepository.validateEmailPassword(userDto);
    if (!user) throw new UnauthorizedException('Invalid Credentials');

    const jwtUserInfo: JwtPayLoad = {
      email: user.email,
      userId: user.id,
      account_key: '',
      doctor_key: '',
      role: '',
      permissions: [],
      accountName: ' ',
      timeZone: '',
    };
    const accessToken = this.jwtService.sign(jwtUserInfo);
    user.accessToken = accessToken;
    return user;
  }

  async findByEmail(email: string): Promise<any> {
    return await this.userRepository.findOne({ email: email });
  }

  async findByPhone(phone: string): Promise<any> {
    return await this.patientRepository.findOne({ phone });
  }

  async adminDetails(accountKeyArray:any): Promise<any> {
    const adminDetails = await this.userRepository.query(queries.getAdminDetails,[accountKeyArray]);
    return adminDetails;      
  }

  async findByDoctorKey(doctor_key: string): Promise<any> {
    return await this.userRepository.findOne({ doctor_key });
  }

  async doctor_Login(email, password): Promise<any> {
    try {
      const user = await this.userRepository.validateEmailAndPassword(
        email,
        password,
      );
      console.log('user data  in user.service=>', user);
      if (
        user.message == CONSTANT_MSG.INVALID_CREDENTIALS ||
        user.message == CONSTANT_MSG.ACCOUNT_NOT_ACTIVATE
      ) {
        // throw new UnauthorizedException("Invalid Credentials");
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: user.message || 'Sorry, something went wrong',
        };
      }
      var accountId = user.account_id;
      var accountData = await this.accountKey(accountId);
      user.account_key = accountData.account_key;
      let userRole = [];
      var roles = await this.getRoles(user.id);
      roles.forEach(v => {
        userRole.push(v.roles);
      });
      user.accountName = accountData.account_name;

      if (!roles) throw new UnauthorizedException('Content Not Available');
      var rolesPermission = await this.getRolesPermissionId(user.id);
      let permissionArray = [];
      rolesPermission.forEach(v => {
        permissionArray.push(v.name);
      });
      const jwtUserInfo: JwtPayLoad = {
        email: user.email,
        userId: user.id,
        account_key: accountData.account_key,
        doctor_key: user.doctor_key,
        role: userRole,
        permissions: permissionArray,
        accountName: accountData.accountName,
        timeZone: user.time_zone,
      };
      console.log('=======jwtUserInfo', jwtUserInfo);
      const accessToken = this.jwtService.sign(jwtUserInfo);
      user.accessToken = accessToken;
      user.rolesPermission = rolesPermission;
      user.role = userRole;
      return user;
    } catch (e) {
      console.log(e);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  async accountKey(accountId: number): Promise<any> {
    return await this.accountRepository.findOne({ account_id: accountId });
  }

  async getRoles(userId: any): Promise<any> {
    return await this.rolesRepository.query(queries.getRoles, [userId]);
  }

  async roleId(userId: number): Promise<any> {
    return await this.userRoleRepository.findOne({ user_id: userId });
  }

  async getRolesPermissionId(userId: number): Promise<any> {
    const role = await this.rolePersmissionRepository.query(
      queries.getRolesPermission,
      [userId],
    );
    return role;
  }

  async patientLogin(email, password, timeZone): Promise<any> {
    try {
      const user = await this.patientRepository.validatePhoneAndPassword(
        email,
        password,
      );
      if (!user) {
        // throw new UnauthorizedException("Invalid Credentials");
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: CONSTANT_MSG.INVALID_CREDENTIALS,
        };
      }
      if (user.message) {
        return user;
      }
      timeZone = timeZone ? timeZone : '+05:30';
      const jwtUserInfo: JwtPatientLoad = {
        phone: user.phone,
        patientId: user.patient_id,
        permission: 'CUSTOMER',
        role: [CONSTANT_MSG.ROLES.PATIENT],
        timeZone: timeZone,
      };
      console.log('=======jwtUserInfo', jwtUserInfo);
      const accessToken = this.jwtService.sign(jwtUserInfo);
      timeZone &&
        (await this.patientRepository.update(
          { patient_id: user.patient_id },
          { time_zone: timeZone },
        ));
      user.accessToken = accessToken;
      user.permission = 'CUSTOMER';
      user.role = [CONSTANT_MSG.ROLES.PATIENT];
      return user;
    } catch (e) {
      console.log(e);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  async patientRegistration(patientDto: PatientDto): Promise<any> {
    try {
      const pat = await this.findByPhone(patientDto.phone);
      let password = '';
      if (!patientDto.password) {
        password = await this.genPassword(6);
        patientDto.password = password.toString();
      }
      if (pat) {
        if (
          pat.createdBy == CONSTANT_MSG.ROLES.DOCTOR &&
          pat.password == null
        ) {
          const update = await this.patientRegistrationUpdate(patientDto);
          return {
            update: 'updated password',
            patientId: pat.patient_id,
          };
        } else {
          return {
            statusCode: HttpStatus.BAD_REQUEST,
            message: CONSTANT_MSG.ALREADY_PRESENT,
          };
        }
      }

      if (patientDto.createdBy === CONSTANT_MSG.ROLES.PATIENT) {
        patientDto.timeZone = patientDto.timeZone;
      } else {
        var docDetails = await this.userRepository.query(queries.getDoctorID, [
          patientDto.doctorKey,
        ]);
        patientDto.timeZone = docDetails[0].time_zone;
      }
      const user = await this.patientRepository.patientRegistration(patientDto);
      // const update = await this.patientForgotPassword(patientDto);
      const jwtUserInfo: JwtPatientLoad = {
        phone: user.phone,
        patientId: user.patient_id,
        permission: 'CUSTOMER',
        role: [CONSTANT_MSG.ROLES.PATIENT],
        timeZone: patientDto.timeZone,
      };
      console.log('=======jwtUserInfo', jwtUserInfo);
      const accessToken = this.jwtService.sign(jwtUserInfo);
      user.accessToken = accessToken;
      user.permission = 'CUSTOMER';
      user.password = !password ? user.password : password;
      return user;
    } catch (e) {
      console.log(e);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  async patientRegistrationUpdate(patientDto: PatientDto): Promise<any> {
    try {
      const { name, phone, password } = patientDto;
      const salt = await bcrypt.genSalt();
      patientDto.password = await this.hashPassword(password, salt);
      patientDto.salt = salt;
      var condition = {
        phone: patientDto.phone,
      };
      var values: any = patientDto;
      var updateDoctorConfig = await this.patientRepository.update(
        condition,
        values,
      );
      if (updateDoctorConfig.affected) {
        return {
          updated: patientDto.password,
        };
      } else {
        return {
          statusCode: HttpStatus.NOT_MODIFIED,
          message: CONSTANT_MSG.UPDATE_FAILED,
        };
      }
    } catch (e) {
      console.log(e);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  private async hashPassword(password: string, salt: string): Promise<string> {
    return bcrypt.hash(password, salt);
  }

  async doctorsResetPassword(userDto: any): Promise<any> {
    const users = await this.userRepository.findOne({ email: userDto.email });
    if (users) {
      if (users.passcode == userDto.passcode) {
        const salt = await bcrypt.genSalt();
        users.salt = salt;
        users.password = await this.hashPassword(userDto.password, salt);
        users.passcode = null;
        try {
          await this.userRepository.save(users);
          return {
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.PASSWORD_CHANGED,
          };
        } catch (e) {
          console.log(e);
          return {
            statusCode: HttpStatus.NO_CONTENT,
            message: CONSTANT_MSG.DB_ERROR,
          };
        }
      } else {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: CONSTANT_MSG.PASSCODE_NOT_MATCHED,
        };
      }
    } else {
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  async doctorForgotPassword(email: string): Promise<any> {
    try {
      const users = await this.userRepository.findOne({ email: email });
      if (users) {
        const salt = !users.salt ? await bcrypt.genSalt() : users.salt;
        users.salt = salt;
        const password = await this.genPassword(6);
        console.log(password);
        users.password = await this.hashPassword(password.toString(), salt);
        let value: any = {
          password: users.password,
          salt: users.salt,
        };
        let condition = {
          id: users.id,
        };
        const updatePassword = await this.userRepository.update(
          condition,
          value,
        );
        console.log(updatePassword);
        if (updatePassword.affected) {
          return {
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.PASSWORD_UPDATION_SUCCESS,
            password: password,
            name: users.name,
          };
        } else {
          return {
            statusCode: HttpStatus.NO_CONTENT,
            message: CONSTANT_MSG.PASSWORD_UPDATION_FAILED,
          };
        }
      } else {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: CONSTANT_MSG.INVALID_REQUEST,
        };
      }
    } catch (err) {
      console.log(err);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  async doctorRegistration(doctorDto: DoctorDto): Promise<any> {
    try {
      return await this.userRepository.doctorRegistration(doctorDto);
    } catch (e) {
      console.log(e);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  async accountRegistration(account: any): Promise<any> {
    //return await this.accountRepository.findOne({account_id: accountId});
    const maxAccKey: any = await this.accountRepository.query(
      queries.getAccountKey,
    );
    let accKey = 'Acc_';
    if (maxAccKey.length) {
      let m = maxAccKey[0];
      accKey = accKey + (Number(m.maxacc) + 1);
    } else {
      accKey = 'Acc_1';
    }
    account.accountKey = accKey;
    const uid: any = await this.userRepository.query(queries.getUser);
    let id = Number(uid[0].id) + 1;
    console.log(id);
    account.id = id;
    const accreg = await this.accountRepository.createAccount(account);
    return accreg;
  }

  async doctorid(doctorKey: string): Promise<any> {
    const docId = await this.userRepository.query(queries.getDoctorID, [
      doctorKey,
    ]);
    return {
      docId,
    };
  }

  async genPassword(length: number): Promise<any> {
    try {
      var password = generator.generate({
        length: length,
        numbers: true,
      });
      return password;
    } catch (e) {
      console.log(e);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }
  async patientForgotPassword(patientDto: PatientDto): Promise<any> {
    try {
      const patient = await this.patientRepository.findOne({
        phone: patientDto.phone,
      });
      if (patient && patient.patient_id) {
        const salt = patient.salt ? patient.salt : await bcrypt.genSalt();
        const password = await this.genPassword(6);
        patient.password = await this.hashPassword(password.toString(), salt);
        const updatePassword = await this.patientRepository.update(
          { patient_id: patient.patient_id },
          { password: patient.password, salt: salt },
        );
        console.log(updatePassword);
        if (updatePassword.affected) {
          // let data = {
          //     apiKey: textLocal.APIKey,
          //     message: "Your new password is " + password,
          //     sender: textLocal.sender,
          //     number: patientDto.phone,
          // }

          // const sendSMS = await this.sms.sendSms(data);
          // if(sendSMS && sendSMS.statusCode === '200'){
          return {
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.PASSWORD_UPDATION_SUCCESS,
            password: password,
            patientId: patient.patient_id,
          };
          // }
        }
        return {
          statusCode: HttpStatus.NO_CONTENT,
          message: CONSTANT_MSG.PASSWORD_UPDATION_FAILED,
        };
      } else {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: CONSTANT_MSG.INVALID_REQUEST,
        };
      }
    } catch (e) {
      console.log(e);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  async patientResetPassword(patientDto: any): Promise<any> {
    const users = await this.patientRepository.findOne({
      phone: patientDto.phone,
    });
    if (users) {
      if (users.passcode == patientDto.passcode) {
        const salt = await bcrypt.genSalt();
        users.salt = salt;
        users.password = await this.hashPassword(patientDto.password, salt);
        users.passcode = null;
        try {
          await this.patientRepository.save(users);
          return {
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.PASSWORD_CHANGED,
          };
        } catch (e) {
          console.log(e);
          return {
            statusCode: HttpStatus.NO_CONTENT,
            message: CONSTANT_MSG.DB_ERROR,
          };
        }
      } else {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: CONSTANT_MSG.PASSCODE_NOT_MATCHED,
        };
      }
    } else {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: CONSTANT_MSG.INVALID_REQUEST,
      };
    }
  }

  async patientChangePassword(patientDto: any): Promise<any> {
    const users = await this.patientRepository.findOne({
      phone: patientDto.user.phone,
    });
    if (users && patientDto.user.patientId == users.patient_id) {
      const salt = await bcrypt.genSalt();
      const pass = await this.hashPassword(patientDto.oldPassword, users.salt);
      if (users.password == pass) {
        users.salt = salt;
        users.password = await this.hashPassword(patientDto.newPassword, salt);
        try {
          await this.patientRepository.save(users);
          return {
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.PASSWORD_CHANGED,
          };
        } catch (e) {
          console.log(e);
          return {
            statusCode: HttpStatus.NO_CONTENT,
            message: CONSTANT_MSG.DB_ERROR,
          };
        }
      } else {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: CONSTANT_MSG.INVALID_PASSWORD,
        };
      }
    } else {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: CONSTANT_MSG.Invalid_password,
      };
    }
  }

  async doctorChangePassword(patientDto: any): Promise<any> {
    const users = await this.userRepository.findOne({
      email: patientDto.user.email,
    });
    if (users && patientDto.user.email == users.email) {
      const salt = await bcrypt.genSalt();
      const pass = await this.hashPassword(patientDto.oldPassword, users.salt);
      if (users.password == pass) {
        users.salt = salt;
        users.password = await this.hashPassword(patientDto.newPassword, salt);
        try {
          await this.userRepository.save(users);
          return {
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.PASSWORD_CHANGED,
          };
        } catch (e) {
          console.log(e);
          return {
            statusCode: HttpStatus.NO_CONTENT,
            message: CONSTANT_MSG.DB_ERROR,
          };
        }
      } else {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: CONSTANT_MSG.INVALID_PASSWORD,
        };
      }
    } else {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: CONSTANT_MSG.Invalid_password,
      };
    }
  }

  async sendEmailWithTemplate(req: any): Promise<any> {
    const {
      email,
      template,
      subject,
      password,
      forgotPassTokenUrl,
      type,
      user_name,
      Details,
      AppointmentDate,tabledata,rescheduleAppointmentUrl
    } = req;

    let logo =
      'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/common/images/viruj-logo.png';
    let plus =
      'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/common/images/plus.png';
    let corner =
      'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/common/images/corner-plus.png';

    var templateBody = template;
    if (
      type === CONSTANT_MSG.MAIL.FORGOT_PASSWORD ||
      type === CONSTANT_MSG.MAIL.REGISTRATION_FOR_DOCTOR ||
      type === CONSTANT_MSG.MAIL.RESET_PASSWORD_THROUGH_LINK
    ) {
      templateBody = templateBody.replace('{password}', password);
      templateBody = templateBody.replace('{email}', email);
      templateBody = templateBody.replace(
        '{user_name}',
        user_name ? user_name : '',
      );
      templateBody = templateBody.replace('{viruj-logo}', logo);
      templateBody = templateBody.replace('{corner-plus}', corner);
      templateBody = templateBody.replace('link', forgotPassTokenUrl);
    } else if (type === CONSTANT_MSG.MAIL.APPOINTMENT_CREATED) {
      templateBody = templateBody.replace(
        '{doctorFirstName}',
        Details.doctorFirstName,
      );
      templateBody = templateBody.replace(
        '{doctorLastName}',
        Details.doctorLastName,
      );
      templateBody = templateBody.replace(
        '{patientFirstName}',
        Details.patientFirstName,
      );
      templateBody = templateBody.replace(
        '{patientLastName}',
        Details.patientLastName,
      );
      templateBody = templateBody.replace('{email}', email);
      templateBody = templateBody.replace('{hospital}', Details.hospital);
      templateBody = templateBody.replace('{startTime}', Details.startTime);
      templateBody = templateBody.replace('{endTime}', Details.endTime);
      Details.role = Details.role
        ? Details.role.toString().replace(/,([^,]*)$/, ' and ' + '$1')
        : '';
      templateBody = templateBody.replace('{role}', Details.role);
      templateBody = templateBody.replace(
        '{appointmentId}',
        Details.appointmentId,
      );
      templateBody = templateBody.replace(
        '{appointmentDate}',
        Details.appointmentDate,
      );
      templateBody = templateBody.replace('{viruj-logo}', logo);
      templateBody = templateBody.replace('{corner-plus}', corner);
      templateBody = templateBody.replace('{plus}', plus);
    } else if (type === CONSTANT_MSG.MAIL.APPOINTMENT_RESCHEDULE) {
      templateBody = templateBody.replace(
        '{doctorFirstName}',
        Details.doctorFirstName,
      );
      templateBody = templateBody.replace(
        '{patientEmail}',
        Details.patientEmail,
      );
      templateBody = templateBody.replace('{doctorEmail}', Details.email);
      templateBody = templateBody.replace(
        '{patientPhone}',
        Details.patientPhone,
      );
      templateBody = templateBody.replace(
        '{doctorLastName}',
        Details.doctorLastName,
      );
      templateBody = templateBody.replace(
        '{patientFirstName}',
        Details.patientFirstName,
      );
      templateBody = templateBody.replace(
        '{patientLastName}',
        Details.patientLastName,
      );
      templateBody = templateBody.replace(
        '{rescheduledAppointmentDate}',
        Details.rescheduledAppointmentDate,
      );
      templateBody = templateBody.replace(
        '{rescheduledStartTime}',
        Details.rescheduledStartTime,
      );
      templateBody = templateBody.replace(
        '{rescheduledEndTime}',
        Details.rescheduledEndTime,
      );
      templateBody = templateBody.replace('{hospital}', Details.hospital);
      Details.role = Details.role
        ? Details.role.indexOf('DOCTOR') != -1
          ? CONSTANT_MSG.ROLES.DOCTOR
          : Details.role.indexOf('ADMIN') != -1
          ? CONSTANT_MSG.ROLES.ADMIN
          : Details.role.indexOf('DOC_ASSISTANT') != -1
          ? CONSTANT_MSG.ROLES.DOC_ASSISTANT
          : Details.role.indexOf('PATIENT') != -1
          ? CONSTANT_MSG.ROLES.PATIENT
          : CONSTANT_MSG.ROLES.DOCTOR
        : CONSTANT_MSG.ROLES.DOCTOR;
      templateBody = templateBody.replace('{role}', Details.role);
      templateBody = templateBody.replace(
        '{appointmentId}',
        Details.appointmentId,
      );
      templateBody = templateBody.replace(
        '{appointmentDate}',
        Details.appointmentDate,
      );
      templateBody = templateBody.replace(
        '{rescheduledOn}',
        Details.rescheduledOn,
      );
      templateBody = templateBody.replace('{Header}', !Details.isAttenderExistPat ? CONSTANT_MSG.RESCHEDULE_MAIL_HEADER.NEW_ATTENDER : CONSTANT_MSG.RESCHEDULE_MAIL_HEADER.COMMON_FOR_ALL);
      templateBody = templateBody.replace('Meeting Id:', !Details.isAttenderExistPat ? 'Meeting Id:' : '');
      templateBody = templateBody.replace('{meetingId}', !Details.isAttenderExistPat ? Details.meetingId : '');
      templateBody = templateBody.replace('Passcode:', !Details.isAttenderExistPat ? 'Passcode:' : '');
      templateBody = templateBody.replace('{passcode}', !Details.isAttenderExistPat ? Details.passcode : '');
      templateBody = templateBody.replace('Session URL:', !Details.isAttenderExistPat ? 'Session URL:' : '');
      templateBody = templateBody.replace('Click here to join the session', !Details.isAttenderExistPat ? 'Click here to join the session' : '');
      templateBody = templateBody.replace('{link}', !Details.isAttenderExistPat ? Details.sessionLink : ''); 
      templateBody = templateBody.replace('{viruj-logo}', logo);
      templateBody = templateBody.replace('{corner-plus}', corner);
      templateBody = templateBody.replace('{plus}', plus);
    } else if (type === CONSTANT_MSG.MAIL.APPOINTMENT_CANCEL) {
      templateBody = templateBody.replace(
        '{doctorFirstName}',
        Details.doctorFirstName,
      );
      templateBody = templateBody.replace(
        '{doctorLastName}',
        Details.doctorLastName,
      );
      templateBody = templateBody.replace(
        '{patientFirstName}',
        Details.patientFirstName,
      );
      templateBody = templateBody.replace(
        '{patientLastName}',
        Details.patientLastName,
      );
      templateBody = templateBody.replace('{email}', email);
      templateBody = templateBody.replace('{hospital}', Details.hospital);
      templateBody = templateBody.replace('{startTime}', Details.startTime);
      templateBody = templateBody.replace('{endTime}', Details.endTime);
      Details.role = Details.role
        ? Details.role.toString().replace(/,([^,]*)$/, ' and ' + '$1')
        : '';
      templateBody = templateBody.replace('{role}', Details.role);
      templateBody = templateBody.replace(
        '{appointmentId}',
        Details.appointmentId,
      );
      templateBody = templateBody.replace(
        '{appointmentDate}',
        Details.appointmentDate,
      );
      templateBody = templateBody.replace('{cancelledOn}', Details.cancelledOn);
      templateBody = templateBody.replace('{viruj-logo}', logo);
      templateBody = templateBody.replace('{corner-plus}', corner);
      templateBody = templateBody.replace('{plus}', plus);
    } else if (type === CONSTANT_MSG.MAIL.PATIENT_REGISTRATION) {
      templateBody = templateBody.replace('{email}', email);
      templateBody = templateBody.replace('{password}', Details.password);
      templateBody = templateBody.replace(
        '{user_name}',
        user_name ? user_name : '',
      );
      templateBody = templateBody.replace('{phone}', Details.phone);
      templateBody = templateBody.replace('{viruj-logo}', logo);
      templateBody = templateBody.replace('{corner-plus}', corner);
    } else if (type === CONSTANT_MSG.MAIL.UPDATE_DOCTOR_REGISTRATION_TO_ADMIN) {
      templateBody = templateBody.replace('{email}', Details.email);
      templateBody = templateBody.replace(
        '{user_name}',
        user_name ? user_name : '',
      );
      templateBody = templateBody.replace('{phone}', Details.number);
      templateBody = templateBody.replace('{viruj-logo}', logo);
      templateBody = templateBody.replace('{corner-plus}', corner);
      templateBody = templateBody.replace('{hospital}', Details.hospitalName);
      templateBody = templateBody.replace(
        '{specialization}',
        Details.specialization || Details.speciality,
      );
      templateBody = templateBody.replace(
        '{qualification}',
        Details.qualification,
      );
      templateBody = templateBody.replace('{experience}', Details.experience);
      templateBody = templateBody.replace(
        '{registrationNumber}',
        Details.registrationNumber,
      );
      console.log(Details.registrationIdProof);
      if (Details.registrationIdProof) {
        templateBody = templateBody.replace(
          '{registrationIdProof}',
          Details.registrationIdProof,
        );
      } else {
        console.log('idproof Not found');
        templateBody = templateBody.replace('RegistrationIdProof:', ' ');
        templateBody = templateBody.replace('{registrationIdProof}', ' ');
      }
    } else if(type === CONSTANT_MSG.MAIL.DAILY_APPOINTMENT_REPORT){
      templateBody = templateBody.replace('{appointmentDate}',AppointmentDate);
      templateBody = templateBody.replace('{tabledata}', tabledata);
      templateBody = templateBody.replace('{viruj-logo}', logo);
      templateBody = templateBody.replace('{corner-plus}', corner);
      templateBody = templateBody.replace('{plus}', plus);
      if(rescheduleAppointmentUrl){
          templateBody = templateBody.replace('{rescheduleAppointment}', rescheduleAppointmentUrl);
      }
      else{
          templateBody = templateBody.replace('Reschedule Appointment:',' ');
          templateBody = templateBody.replace('{rescheduleAppointment}',' ');
      }
  } else if(type === CONSTANT_MSG.MAIL.UPDATE_APPOINTMENT_TO_ATTENDER) {
      templateBody = templateBody.replace('{attender_name}', user_name);
      templateBody = templateBody.replace('{patient_name}', Details.patientName);
      templateBody = templateBody.replace('{doctor_name}', Details.doctor_name);
      templateBody = templateBody.replace('{appointmentDate}', Details.appointment_date);
      templateBody = templateBody.replace('{appointmentStartTime}', Details.startTime);
      templateBody = templateBody.replace('{appointmentEndTime}', Details.endTime);
      templateBody = templateBody.replace('Session URL:', !Details.isAttenderExistPat ? 'Session URL:' : '');
      templateBody = templateBody.replace('{link}', !Details.isAttenderExistPat ? Details.sessionLink : '');
      templateBody = templateBody.replace('Click here to join the session', !Details.isAttenderExistPat ? 'Click here to join the session' : '');
      templateBody = templateBody.replace('Meeting Id:', !Details.isAttenderExistPat ? 'Meeting Id:' : '');
      templateBody = templateBody.replace('{meetingId}', !Details.isAttenderExistPat ? Details.meetingId : '');
      templateBody = templateBody.replace('Passcode:', !Details.isAttenderExistPat ? 'Passcode:' : '');
      templateBody = templateBody.replace('{passcode}', !Details.isAttenderExistPat ? Details.passcode : '');
      templateBody = templateBody.replace('{Header}', Details.isAttenderExistPat ? CONSTANT_MSG.UPDATE_ATTENDER_MAIL_HEADER.EXISTS_ATTENDER : CONSTANT_MSG.UPDATE_ATTENDER_MAIL_HEADER.NEW_ATTENDER);
      templateBody = templateBody.replace('{sessionJoinContent}', !Details.isAttenderExistPat ? 'Please join the session using video link else use Meeting Id for joining throuh our Virujh mobile app' : 'Please join the session using your Virujh login credentials');
      templateBody = templateBody.replace('{viruj-logo}', logo);
      templateBody = templateBody.replace('{corner-plus}', corner);
  }

    let params: any = {
        subject: subject,
        recipient: email,
        template: templateBody,
        fromEmail: emailFromConfig.email,
        fromEmailPass: emailFromConfig.pass,
        isCCAvailable: Details.isCCAvailable ? true : false,
        ccEmail: Details.patientEmail ? Details.patientEmail : ''
    };

    try {
      let email = new Email();
      const sendMail = await email.sendEmail(params);
      console.log('mail response', sendMail);
      return {
        statusCode: HttpStatus.OK,
        message: CONSTANT_MSG.MAIL_OK,
      };
    } catch (e) {
      console.log('error=> ', e);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  async getEmailTemplate(data: any): Promise<any> {
    try {
    } catch (err) {
      console.log(err);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  async OTPVerification(patientDto: PatientDto): Promise<any> {
    try {
      const patient = await this.patientRepository.findOne({
        phone: patientDto.phone,
        passcode: patientDto.passcode,
      });
      if (patient && patient.patient_id) {
        const jwtUserInfo: JwtPatientLoad = {
          phone: patient.phone,
          patientId: patient.patient_id,
          permission: 'CUSTOMER',
          role: [CONSTANT_MSG.ROLES.PATIENT],
          timeZone: patient.time_zone,
        };
        console.log('=======jwtUserInfo', jwtUserInfo);
        const accessToken = this.jwtService.sign(jwtUserInfo);
        return {
          statusCode: HttpStatus.OK,
          message: CONSTANT_MSG.OTP_VERIFICATION_SUCCESS,
          patient_id: patient.patient_id,
          accessToken: accessToken,
          permission: 'CUSTOMER',
          role: [CONSTANT_MSG.ROLES.PATIENT],
        };
      } else {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: CONSTANT_MSG.OTP_VERIFICATION_FAILED,
        };
      }
    } catch (err) {
      console.log(err);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  async patientLoginForPhone(phone: string): Promise<any> {
    const patient = await this.patientRepository.findOne({ phone: phone });
    if (patient) {
      let passcode = await this.random(4);

      //Update passcode in patient table
      let updatePasscode = await this.patientRepository.update(
        { phone: phone },
        { passcode: passcode },
      );
      if (updatePasscode.affected) {
        //  let data = {
        //     apiKey: textLocal.APIKey,
        //     message: "[VIRUJH] Your verification code is " + passcode,
        //     sender: textLocal.sender,
        //     number: phone,
        // }

        // const sendSMS = await this.sms.sendSms(data);
        // if(sendSMS && sendSMS.statusCode === '200'){
        return {
          statusCode: HttpStatus.OK,
          message: 'OTP is sent successfully',
          passcode: passcode,
          phone: phone,
        };
        // } else {
        //     return {
        //         statusCode: HttpStatus.NO_CONTENT,
        //         message: "OTP send failed"
        //     }
        // }
      }
    } else {
      return {
        statusCode: HttpStatus.NOT_FOUND,
        message: CONSTANT_MSG.INVALID_REQUEST,
      };
    }
  }

  async updateDoctorTimeZone(user: any): Promise<any> {
    const doc = await this.userRepository.query(queries.getDoctorDetailsWithAccountKey,[user.docConfigDto.doctorKey]);
    if(doc && ((user.role.indexOf('DOCTOR') != -1 && doc[0].doctor_key == user.doctor_key)||(user.role.indexOf('ADMIN') != -1 && user.account_key == doc[0].account_key )) ) {
      let updateTimeZone = await this.userRepository.update(
        { doctor_key: user.docConfigDto.doctorKey },
        { time_zone: user.docConfigDto.timeZone },
      );
      if (updateTimeZone.affected) {
        return {
          statusCode: HttpStatus.OK,
          message: CONSTANT_MSG.UPDATE_OK,
        };
      } else {
        return {
          statusCode: HttpStatus.NOT_MODIFIED,
          message: CONSTANT_MSG.UPDATE_FAILED,
        };
      }
    } else {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: CONSTANT_MSG.INVALID_REQUEST,
      };
    }
  }

  async getUserByUserId(user: any): Promise<any> {
    return await this.userRepository.getUserByUserId(user);
  }

  async getPatientByPatientId(patient: any): Promise<any> {
    return await this.patientRepository.getPatientByPatientId(patient);
  }

  async doctorsResetPasswordLink(email: string): Promise<any> {
    try {
      const users = await this.userRepository.findOne({ email: email });
      if (users) {
        const salt = !users.salt ? await bcrypt.genSalt() : users.salt;
        users.salt = salt;
        return {
          statusCode: HttpStatus.OK,
          message:
            CONSTANT_MSG.PASSWORD_RESETLINK_SENT,
        };
      } else {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: CONSTANT_MSG.USER_NOT_FOUND,
        };
      }
    } catch (err) {
      console.log(err);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  async doctorSetPasswordByLink(doctorDto: any): Promise<any> {
    const users =  await this.userRepository.findOne({email : doctorDto.email});
    if(users && doctorDto.email == users.email){
      const salt = await bcrypt.genSalt();
      users.salt = salt;
      users.password = await this.hashPassword(doctorDto.newPassword, salt);
      try {
        await this.userRepository.save(users);
        return {
          statusCode: HttpStatus.OK,
          message: CONSTANT_MSG.PASSWORD_CHANGED,
        };
      } catch (e) {
        console.log("error in doctorSetPasswordByLink function: " , e);
        return {
          statusCode: HttpStatus.NO_CONTENT,
          message: CONSTANT_MSG.DB_ERROR,
        };
      }
    } else {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: CONSTANT_MSG.UPDATE_FAILED,
      };
    }
  }

  async updatePatientPassword(patientDto: any): Promise<any> {
    const users = await this.patientRepository.findOne({
      patient_id: patientDto.patientId,
    });
    if (users && patientDto.patientId == users.patient_id) {
      const salt = await bcrypt.genSalt();
      users.salt = salt;
      users.password = await this.hashPassword(patientDto.newPassword, salt);
      try {
        await this.patientRepository.save(users);
        return {
          statusCode: HttpStatus.OK,
          message: CONSTANT_MSG.PASSWORD_CHANGED,
        };
      } catch (e) {
        console.log(e);
        return {
          statusCode: HttpStatus.NO_CONTENT,
          message: CONSTANT_MSG.DB_ERROR,
        };
      }
    } else {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: CONSTANT_MSG.INVALID_REQUEST,
      };
    }
  }

  async patientResetPasswordLink(patientDto: PatientDto): Promise<any> {
    try {
      const patient = await this.patientRepository.findOne({
        phone: patientDto.phone,
      });
      if (patient && patient.patient_id) {
        const salt = patient.salt ? patient.salt : await bcrypt.genSalt();
        return {
          statusCode: HttpStatus.OK,
          message:
            'Reset Link sent to registered mailId' /*CONSTANT_MSG.PASSWORD_RESETLINK_SENT*/,
          patientId: patient.patient_id,
        };
        // }
      } else {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: CONSTANT_MSG.INVALID_MOBILE_NO,
        };
      }
    } catch (e) {
      console.log(e);
      return {
        statusCode: HttpStatus.NO_CONTENT,
        message: CONSTANT_MSG.DB_ERROR,
      };
    }
  }

  private async random(len: number) {
    const result = Math.floor(Math.random() * Math.pow(10, len));
    return result.toString().length < len ? this.random(len) : result;
  }
}
