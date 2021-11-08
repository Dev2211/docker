import {HttpStatus, Injectable, Logger, InternalServerErrorException} from '@nestjs/common';
import {AppointmentRepository} from './appointment.repository';
import {InjectRepository} from '@nestjs/typeorm';
import {CONSTANT_MSG, DocConfigDto, DoctorDto, Email, HospitalDto, PatientDto, queries, Sms} from 'common-dto';
import {Doctor} from './doctor/doctor.entity';
import {DoctorRepository} from './doctor/doctor.repository';
import {AccountDetailsRepository} from './account/account.repository';
import {PrescriptionRepository} from './prescription.repository';
import {PatientReportRepository} from './patientReport.repository'
import {AccountDetails} from './account/account_details.entity';
import {DoctorConfigPreConsultationRepository} from './doctorConfigPreConsultancy/doctor_config_preconsultation.repository';
import {DoctorConfigCanReschRepository} from './docConfigReschedule/doc_config_can_resch.repository';
import {docConfigRepository} from "./doc_config/docConfig.repository";
//import {queries} from "../config/query";
import {DocConfigScheduleDayRepository} from "./docConfigScheduleDay/docConfigScheduleDay.repository";
import {DocConfigScheduleIntervalRepository} from "./docConfigScheduleInterval/docConfigScheduleInterval.repository";
import {WorkScheduleDayRepository} from "./workSchedule/workScheduleDay.repository";
import {WorkScheduleIntervalRepository} from "./workSchedule/workScheduleInterval.repository";
import {PatientDetailsRepository} from "./patientDetails/patientDetails.repository";
import {PaymentDetailsRepository} from "./paymentDetails/paymentDetails.repository";
import {AppointmentCancelRescheduleRepository} from "./appointmentCancelReschedule/appointmentCancelReschedule.repository";
import {Helper} from "../utility/helper";
import {AppointmentDocConfigRepository} from "./appointmentDocConfig/appointmentDocConfig.repository";
import {MedicineRepository} from './medicine.repository';
import { VersionRepository } from './mobile_version/mobile_version.repository';
import { AppointmentSessionDetailsRepository } from "./appointmentSessionDetails/appointmentSessionDetails.repository"
import * as bcrypt from 'bcrypt';

var async = require('async');
var moment = require('moment');
var fs = require('fs');
var pdf = require('html-pdf');
var moment = require('moment');

@Injectable()
export class AppointmentService {
    mail:any
    parameter:any
    email : Email;
    sms: Sms;
    private logger = new Logger('AppointmentService');
    constructor(
        @InjectRepository(AppointmentRepository) private appointmentRepository: AppointmentRepository,
        private accountDetailsRepository: AccountDetailsRepository, private doctorRepository: DoctorRepository,
        private doctorConfigPreConsultationRepository: DoctorConfigPreConsultationRepository,
        private doctorConfigCanReschRepository: DoctorConfigCanReschRepository,
        private doctorConfigRepository: docConfigRepository,
        private docConfigScheduleDayRepository: DocConfigScheduleDayRepository,
        private docConfigScheduleIntervalRepository: DocConfigScheduleIntervalRepository,
        private workScheduleDayRepository: WorkScheduleDayRepository,
        private workScheduleIntervalRepository: WorkScheduleIntervalRepository,
        private patientDetailsRepository: PatientDetailsRepository,
        private prescriptionRepository: PrescriptionRepository,
        private patientReportRepository : PatientReportRepository,
        private medicineRepository: MedicineRepository,
        private paymentDetailsRepository: PaymentDetailsRepository,
        private appointmentCancelRescheduleRepository: AppointmentCancelRescheduleRepository,
        private appointmentDocConfigRepository: AppointmentDocConfigRepository,
        private versionRepository: VersionRepository,
        private appointmentSessionDetailsRepository : AppointmentSessionDetailsRepository,
    ) {
        this.email = new Email();
        this.sms = new Sms();
        // const mail= config.get('mail')
        // const dparams={
        //     smtpUser:this.mail.smtpUser,
        //     smtpPass:this.mail.smtpPass,
        //     smtpHost:this.mail.smtpHost,
        //     smtpPort:this.mail.smtpPort
        // }
        // this.parameter = new Email(dparams);
    }

    async convertTime12to24(time12h) {
        const [time, modifier] = time12h.includes('PM') ? time12h.split('PM') : time12h.split('AM');
      
        let [hours, minutes] = time.split(':');
      
        if (hours === '12') {
          hours = '00';
        }
      
        if (time12h.includes('PM')) {
  
          hours = parseInt(hours, 10) + 12;
        }
      
        return `${hours}:${minutes}:00`;
      }

    async convertStartAndEndUserTimeToUTCTimeZone(startTime, endTime, timeZone) {
        let isAdd = true;
        let startTimeInUtc, endTimeInUtc, userTimeZone;
        try {
            let newStartTime = (startTime.includes('AM') || startTime.includes('PM')) ? await this.convertTime12to24(startTime) : startTime;
            let newEndTime = (endTime.includes('AM') || endTime.includes('PM')) ? await this.convertTime12to24(endTime) : endTime;
            timeZone = timeZone ? timeZone : '+05:30';
            if (timeZone.includes('-')) {
                isAdd = false;
                userTimeZone = timeZone.split('-')[1];
            } else {
                userTimeZone = timeZone.split('+')[1];
            }
            if (!isAdd) {
                startTimeInUtc = moment(newStartTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
                endTimeInUtc = moment(newEndTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
            } else {
                startTimeInUtc = moment(newStartTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
                endTimeInUtc = moment(newEndTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
            }
            console.log({ startTimeInUtc, endTimeInUtc })
            return { startTimeInUtc, endTimeInUtc }
        } catch (err) {
            console.log("Error in convertStartAndEndUserTimeToUTCTimeZone function :", err);
            startTimeInUtc = startTime;
            endTimeInUtc = endTime;
            return { startTimeInUtc, endTimeInUtc }
        }
    }

    async convertAppointmentDtoToUTCTimeZone(appoinmentDto, timeZone) {
        try {
            let userTimeZone;
            timeZone = timeZone ? timeZone : '+05:30';
            if (timeZone.includes('-')) {
               
                userTimeZone = timeZone.split('-')[1];
                    appoinmentDto.appointmentDate = moment(appoinmentDto.appointmentDate).add(appoinmentDto.startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
                    appoinmentDto.startTime = moment(appoinmentDto.startTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
                    appoinmentDto.endTime = moment(appoinmentDto.endTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
                    appoinmentDto.appointmentDate = moment(new Date(appoinmentDto.appointmentDate)).utcOffset('+'+userTimeZone).format("YYYY-MM-DD");
                    appoinmentDto.appointmentDate = new Date(appoinmentDto.appointmentDate);
                
                return appoinmentDto;
            } else {
                
                userTimeZone = timeZone.split('+')[1];
                    appoinmentDto.appointmentDate = moment(appoinmentDto.appointmentDate).add(appoinmentDto.startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
                    appoinmentDto.startTime = moment(appoinmentDto.startTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
                    appoinmentDto.endTime = moment(appoinmentDto.endTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
                    appoinmentDto.appointmentDate = moment(new Date(appoinmentDto.appointmentDate)).utcOffset('-'+userTimeZone).format("YYYY-MM-DD");
                    appoinmentDto.appointmentDate = new Date(appoinmentDto.appointmentDate);
                
                return appoinmentDto;
            }
        } catch(err) {
            console.log("Error in convertAppointmentDtoToUTCTimeZone function: ", err);
            return appoinmentDto;
        }
    }

    async convertStartAndEndTimeUtcToUserTimeZone(startTime, endTime, timeZone) {
        let startTimeInUserTimeZone, endTimeInUserTimeZone, userTimeZone;
        try {
            let isAdd = true;
            timeZone = timeZone ? timeZone : '+05:30';
                if (timeZone.includes('-')) {
                    isAdd = false;
                    userTimeZone = timeZone.split('-')[1];
                } else {
                    userTimeZone = timeZone.split('+')[1];
                }
            if (isAdd) {
                startTimeInUserTimeZone = moment(startTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
                endTimeInUserTimeZone = moment(endTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
            } else {
                startTimeInUserTimeZone = moment(startTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
                endTimeInUserTimeZone = moment(endTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
            }
            return { startTimeInUserTimeZone, endTimeInUserTimeZone }
        } catch (err) {
            console.log("Error in convertStartAndEndTimeUtcToUserTimeZone function : ", err);
            startTimeInUserTimeZone = startTime;
            endTimeInUserTimeZone = endTime;
            return { startTimeInUserTimeZone, endTimeInUserTimeZone }
        }
    }

    async convertAppointmentReportUTCToUser(appReports, timeZone) {
        try {
            let userTimeZone;
            timeZone = timeZone ? timeZone : '+05:30';
            if (timeZone.includes('+')) {
               
                userTimeZone = timeZone.split('+')[1];
                for(let app of appReports) {
                    app.appointment_date = moment(app.appointment_date).add(app.startTime).format('YYYY-MM-DDTHH:mm:ss');
                    app.startTime = moment(app.startTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
                    // app.endTime = moment(app.endTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
                    app.appointment_date = moment(new Date(app.appointment_date)).utcOffset('+'+userTimeZone).format("YYYY-MM-DD");
                    app.appointment_date = new Date(app.appointment_date);
                }
                return appReports;
            } else {
                
                userTimeZone = timeZone.split('-')[1];
                for(let app of appReports) {
                    app.appointment_date = moment(app.appointment_date).add(app.startTime).format('YYYY-MM-DDTHH:mm:ss');
                    app.startTime = moment(app.startTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
                    // app.endTime = moment(appReports.endTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
                    app.appointment_date = moment(new Date(app.appointment_date)).utcOffset('-'+userTimeZone).format("YYYY-MM-DD");
                    app.appointment_date = new Date(app.appointment_date);
                }
                return appReports;
            }
        } catch(err) {
            console.log("Error in convertAppointmentReportUTCToUser function : ", err);
            return appReports;
        }
    }
    
    async createAppointment(appointmentDto: any): Promise<any> {
        try {
            const app = await this.appointmentRepository.query(queries.getAppointmentForDoctor, [appointmentDto.appointmentDate, appointmentDto.doctorId]);
            if (app) {
                // // validate with previous data

            // let { startTimeInUtc, endTimeInUtc } = await this.convertStartAndEndTimeToUTCTimeZone(appointmentDto.startTime, appointmentDto.endTime, appointmentDto.timeZone);
            // appointmentDto.startTime = startTimeInUtc;
            // appointmentDto.endTime = endTimeInUtc;
            appointmentDto = await this.convertAppointmentDtoToUTCTimeZone(appointmentDto, appointmentDto.timeZone);
                let isOverLapping = await this.findTimeOverlapingForAppointments(app, appointmentDto);
                if (isOverLapping) {
                    //return error message
                    return {
                        statusCode: HttpStatus.NOT_FOUND,
                        message: CONSTANT_MSG.TIME_OVERLAP
                    }
                } else {
                    let endValue = appointmentDto.endTime === '00:00' ? '24:00' : appointmentDto.endTime;
                    let end = Helper.getTimeInMilliSeconds(endValue);
                    let start = Helper.getTimeInMilliSeconds(appointmentDto.startTime);
                    let config = Helper.getMinInMilliSeconds(appointmentDto.config.consultationSessionTimings);
                    let endTime = start + config;
                    if (start > end) {
                        return {
                            statusCode: HttpStatus.BAD_REQUEST,
                            message: CONSTANT_MSG.INVALID_TIMINGS
                        }
                    }
                    if (endTime !== end) {
                        return {
                            statusCode: HttpStatus.BAD_GATEWAY,
                            message: CONSTANT_MSG.END_TIME_MISMATCHING
                        }
                    }
                    const exist = await this.appointmentRepository.query(queries.getExistAppointment, [appointmentDto.doctorId, appointmentDto.patientId, appointmentDto.appointmentDate])
                    if (exist.length && !appointmentDto.confirmation) {
                        return {
                            statusCode: HttpStatus.EXPECTATION_FAILED,
                            message: CONSTANT_MSG.APPOINT_ALREADY_PRESENT
                        }
                    } else {
                        // create appointment on existing date old records                   
                        const appoint = await this.appointmentRepository.createAppointment(appointmentDto);
                        if (!appoint.message) {
                            const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);
                            console.log(appDocConfig);
                            return {
                                appointment: appoint,
                                appointmentDocConfig: appDocConfig
                            }
                        } else {
                            return appoint;
                        }

                    }
                }
            }else{
                appointmentDto = await this.convertAppointmentDtoToUTCTimeZone(appointmentDto, appointmentDto.timeZone);
                const appoint = await this.appointmentRepository.createAppointment(appointmentDto);
                if (!appoint.message) {
                    const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);
                    console.log(appDocConfig);
                    return {
                        appointment: appoint,
                        appointmentDocConfig: appDocConfig
                    }
                } else {
                    return appoint;
                }
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async doctorDetails(doctorKey): Promise<any> {
        return await this.doctorRepository.findOne({doctorKey: doctorKey});
    }

    async doctorListDetails(doctorKey): Promise<any> {
        let docConfig = await this.docConfigScheduleDayRepository.query(queries.getDocDetails, [doctorKey]);
        return docConfig;
    }

    async doctorReportRemainder(reportRemainderId): Promise<any> {
        const doctorReportRemainder = await this.doctorRepository.query(queries.getDocReportRemainderId,[reportRemainderId]);
        return doctorReportRemainder?doctorReportRemainder[0].mail_remainder:"";
    }
    async doctorReportRemainderId(reportRemainder): Promise<any> {
        const doctorReportRemainder = await this.doctorRepository.query(queries.getDocReportRemainder,[reportRemainder]);
        return doctorReportRemainder ? doctorReportRemainder[0].id : 1;
    }

    async accountDetails(accountKey): Promise<any> {
        return await this.accountDetailsRepository.findOne({accountKey: accountKey});
    }

    async doctor_Details(doctorId): Promise<any> {
        return await this.doctorRepository.findOne({doctorId: doctorId});
    }

    async doctor_lists(accountKey): Promise<any> {
        try {
            const doctorList = await this.doctorRepository.query(queries.getDocListDetails, [accountKey]);
            let ids = [];
            doctorList.forEach(a => {
                let flag = false;
                ids.forEach(i => {
                    if (i.doctorId == a.doctorId)
                        flag = true;
                });
                if (flag == false) {
                    ids.push(a)
                }
            });
            let res = [];
            for (let list of ids) {
                var doc = {
                    doctorId: list.doctorId,
                    accountkey: list.account_key,
                    doctorKey: list.doctor_key,
                    speciality: list.speciality,
                    photo: list.photo,
                    signature: list.signature,
                    number: list.number,
                    firstName: list.first_name,
                    lastName: list.last_name,
                    registrationNumber: list.registration_number,
                    fee: list.consultation_cost,
                    location: list.city
                }
                res.push(doc);
            }
            if (doctorList.length) {
                return res;
            } else {
                return []
            }
        } catch (e) {
            return []
        }
    }


    async doctor_List(user): Promise<any> {
        try {
            const doctorList = await this.appointmentRepository.query(queries.getDocListForPatient, [user.patientId]);
            let ids = [];
            doctorList.forEach(a => {
                let flag = false;
                ids.forEach(i => {
                    if (i.doctorId == a.doctorId)
                        flag = true;
                });
                if (flag == false) {
                    ids.push(a)
                }
            });
            let res = [];
            for (let list of ids) {
                var doc = {
                    doctorId: list.doctorId,
                    accountkey: list.account_key,
                    doctorKey: list.doctor_key,
                    speciality: list.speciality,
                    photo: list.photo,
                    signature: list.signature,
                    number: list.number,
                    firstName: list.first_name,
                    lastName: list.last_name,
                    registrationNumber: list.registration_number,
                    fee: list.consultation_cost,
                    street: list.street1 ? list.street1 : "",
                    city: list.city ? list.city : "",
                    state:list.state ? list.state : "",
                    pincode:list.pincode ? list.pincode : "",
                    country:list.country ? list.country : "",
                    hospitalName: list.hospital_name,
                    experience:list.experience
                }
                res.push(doc);
            }
            if (doctorList.length) {
                res.sort((a, b)=>{
                    if(a.firstName < b.firstName) { return -1; }
                    if(a.firstName > b.firstName) { return 1; }
                    return 0;
                })
                return res;
            } else {
                return [];
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async doctorListAccount(accountKey): Promise<any> {
        let docConfig = await this.docConfigScheduleDayRepository.query(queries.getDocListDetails, [accountKey]);
        return docConfig;
    }

    async doctorCanReschView(doctorKey): Promise<any> {
        return await this.doctorConfigCanReschRepository.findOne({doctorKey: doctorKey});
    }

    // get details from docConfig table
    async getDoctorConfigDetails(doctorKey): Promise<any> {
        return await this.doctorConfigRepository.findOne({doctorKey: doctorKey});
    }

    async todayAppointments(doctorId, date): Promise<any> {
        const appointments = await this.appointmentRepository.query(queries.getAppointmentForDoctor, [date, doctorId]);
        let apps: any = appointments;
        apps = apps.sort((val1, val2) => {
            let val1IntervalStartTime = val1.startTime;
            let val2IntervalStartTime = val2.startTime;
            val1IntervalStartTime = Helper.getTimeInMilliSeconds(val1IntervalStartTime);
            val2IntervalStartTime = Helper.getTimeInMilliSeconds(val2IntervalStartTime);
            if (val1IntervalStartTime < val2IntervalStartTime) {
                return -1;
            } else if (val1IntervalStartTime > val2IntervalStartTime) {
                return 1;
            } else {
                return 0;
            }
        })
        return apps;
    }

    async todayAppointmentsForDoctor(doctorId, data): Promise<any> { 
        let  userCurrentDate = moment(new Date()).utcOffset(data.timeZone).format("YYYY-MM-DD");
        let formattedDate = Helper.getDayMonthYearFromDate(userCurrentDate);
        var currentDate = Helper.getDayMonthYearFromDate(new Date());
        var date: any = new Date();
        var minutes = date.getMinutes();
        var hour = date.getHours();
        var time = hour + ':' + minutes + ':' + '00';
        let appointments;
        var beforeADay = moment(new Date().setDate(new Date().getDate() - 1)).format("YYYY-MM-DD");
        if(formattedDate == currentDate) {
            appointments = await this.appointmentRepository.query(queries.getAppointmentForDoctorAlongWithPatientForDiffDate, [userCurrentDate, doctorId, 'notCompleted', 'paused', 'online', beforeADay, time]);
        } else {
            currentDate = moment(new Date()).format("YYYY-MM-DD");
            appointments = await this.appointmentRepository.query(queries.getAppointmentForDoctorAlongWithPatientForSameDate, [userCurrentDate, doctorId, 'notCompleted', 'paused', 'online', currentDate, time, beforeADay, time]);
        }
        // currentDate = moment(new Date()).format("YYYY-MM-DD");
        // var beforeADay = moment(new Date().setDate(new Date().getDate() - 1)).format("YYYY-MM-DD");
        // // appointments = await this.appointmentRepository.query(queries.getAppointmentForDoctorAlongWithPatient, [userCurrentDate, doctorId, 'notCompleted', 'paused', 'online', currentDate, time]);
        // appointments = await this.appointmentRepository.query(queries.getAppointmentForDoctorAlongWithPatient, [userCurrentDate, doctorId, 'notCompleted', 'paused', 'online', currentDate, time, beforeADay, time]);
  
          let apps: any = appointments;
          apps = apps.sort((val1, val2) => {
              let val1IntervalStartTime = val1.startTime;
              let val2IntervalStartTime = val2.startTime;
              val1IntervalStartTime = Helper.getTimeInMilliSeconds(val1IntervalStartTime);
              val2IntervalStartTime = Helper.getTimeInMilliSeconds(val2IntervalStartTime);
              if (val1IntervalStartTime < val2IntervalStartTime) {
                  return -1;
              } else if (val1IntervalStartTime > val2IntervalStartTime) {
                  return 1;
              } else {
                  return 0;
              }
          })
          return apps;
      }

    async doctorConfigUpdate(doctorConfigDto: DocConfigDto): Promise<any> {
        try {
            // update the doctorConfig details
            if (!doctorConfigDto.doctorKey) {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
            var condition = {
                doctorKey: doctorConfigDto.doctorKey
            }
            var values: any = doctorConfigDto;
            var updateDoctorConfig = await this.doctorConfigRepository.update(condition, values);
            if (updateDoctorConfig.affected) {
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.UPDATE_OK
                }
            } else {
                return {
                    statusCode: HttpStatus.NOT_MODIFIED,
                    message: CONSTANT_MSG.UPDATE_FAILED
                }
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async workScheduleView(doctorId: number, docKey: string, timeZone: any): Promise<any> {
        try {
            let docConfig = await this.docConfigScheduleDayRepository.query(queries.getWorkSchedule, [doctorId]);
            if (docConfig) {
                let monday = [], tuesday = [], wednesday = [], thursday = [], friday = [], saturday = [], sunday = [];
                // format the response
                docConfig.forEach(async v => {
                    if(v.startTime && v.endTime) {
                    let { startTimeInUserTimeZone, endTimeInUserTimeZone } = await this.convertStartAndEndTimeUtcToUserTimeZone(v.startTime, v.endTime, timeZone);
                    v.startTime = startTimeInUserTimeZone;
                    v.endTime = endTimeInUserTimeZone;
                    }
                    if (v.dayOfWeek === 'Monday') {
                        monday.push(v);
                    } else if (v.dayOfWeek === 'Tuesday') {
                        tuesday.push(v);
                    } else if (v.dayOfWeek === 'Wednesday') {
                        wednesday.push(v);
                    } else if (v.dayOfWeek === 'Thursday') {
                        thursday.push(v);
                    } else if (v.dayOfWeek === 'Friday') {
                        friday.push(v);
                    } else if (v.dayOfWeek === 'Saturday') {
                        saturday.push(v);
                    } else if (v.dayOfWeek === 'Sunday') {
                        sunday.push(v);
                    }
                })
                let days =[monday,tuesday,wednesday,thursday,friday,saturday,sunday];
                days.forEach(e => {
                    e = e.sort((val1, val2) => {
                        let val1IntervalStartTime = val1.startTime;
                        let val2IntervalStartTime = val2.startTime;
                        val1IntervalStartTime = Helper.getTimeInMilliSeconds(val1IntervalStartTime);
                        val2IntervalStartTime = Helper.getTimeInMilliSeconds(val2IntervalStartTime);
                        if (val1IntervalStartTime < val2IntervalStartTime) {
                            return -1;
                        } else if (val1IntervalStartTime > val2IntervalStartTime) {
                            return 1;
                        } else {
                            return 0;
                        }
                    })
                });
                const config = await this.doctorConfigRepository.query(queries.getConfig, [docKey]);
                let config1 = config[0];
                let responseData = {
                    monday: monday,
                    tuesday: tuesday,
                    wednesday: wednesday,
                    thursday: thursday,
                    friday: friday,
                    saturday: saturday,
                    sunday: sunday,
                    configDetails: config1
                }
                return responseData;
            } else {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.INVALID_REQUEST
                }
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }


    async workScheduleEdit(workScheduleDto: any): Promise<any> {
        if (workScheduleDto.workScheduleConfig) {
            // update on workScheduleConfig
            var condition = {
                doctorKey: workScheduleDto.doctorKey
            }
            var values: any = workScheduleDto.workScheduleConfig;
            await this.doctorConfigRepository.update(condition, values);
        }
        // update for sheduleTime Intervals
        let scheduleTimeIntervals = workScheduleDto.updateWorkSchedule;
        if (scheduleTimeIntervals && scheduleTimeIntervals.length) {
            let sortArrayForDelete = [];
            let sortArrayForNotDelete = [];
            // this sort array to push isDelete in top order and notIsDelete in lower order
            scheduleTimeIntervals.map(v=>{
                v.isDelete ? sortArrayForDelete.push(v) : sortArrayForNotDelete.push(v);
            })
            scheduleTimeIntervals = [...sortArrayForDelete,...sortArrayForNotDelete ]
            for (let scheduleTimeInterval of scheduleTimeIntervals) {
                if(!scheduleTimeInterval.isDelete) {
                    const { startTimeInUtc, endTimeInUtc } = await this.convertStartAndEndUserTimeToUTCTimeZone(scheduleTimeInterval.startTime, scheduleTimeInterval.endTime, workScheduleDto.timeZone);
                    scheduleTimeInterval.startTime = startTimeInUtc;
                    scheduleTimeInterval.endTime = endTimeInUtc;
                }
                
                if (scheduleTimeInterval.scheduletimeid) {
                    if (scheduleTimeInterval.isDelete) {
                        // if delete, then delete the record
                        let scheduleTimeId = scheduleTimeInterval.scheduletimeid;
                        let scheduleDayId = scheduleTimeInterval.scheduledayid;
                        await this.deleteDoctorConfigScheduleInterval(scheduleTimeId, scheduleDayId);
                    } else {
                        // if scheduletimeid is there then need to update
                        let doctorKey = workScheduleDto.user.doctor_key;
                        let scheduleDayId = scheduleTimeInterval.scheduledayid;
                        let doctorConfigScheduleIntervalId = scheduleTimeInterval.scheduletimeid;
                        let doctorScheduledDays = await this.getDoctorConfigSchedule(doctorKey, scheduleDayId, doctorConfigScheduleIntervalId);
                        let starTime = scheduleTimeInterval.startTime;
                        let endTime = scheduleTimeInterval.endTime;
                        if (doctorScheduledDays && doctorScheduledDays.length) {
                            // // validate with previous data
                            let isOverLapping = await this.findTimeOverlaping(doctorScheduledDays, scheduleTimeInterval);
                            if (isOverLapping) {
                                //return error message
                                return {
                                    statusCode: HttpStatus.NOT_FOUND,
                                    message: CONSTANT_MSG.TIME_OVERLAP
                                }
                            } else {
                                // update old records
                                await this.updateIntoDocConfigScheduleInterval(starTime, endTime, doctorConfigScheduleIntervalId);
                            }
                        } else {
                            // only one record present in table update existing records
                            await this.updateIntoDocConfigScheduleInterval(starTime, endTime, doctorConfigScheduleIntervalId);
                        }
                    }
                } else {
                    // if scheduletimeid is not there  then new insert new records then
                    // get the previous interval timing from db
                    let doctorKey = workScheduleDto.user.doctor_key;
                    let scheduleDayId = scheduleTimeInterval.scheduledayid;
                    // for inserting new schedule interval, for checking previous interval, passing as zero, as to work the query
                    let doctorScheduledDays = await this.getDoctorConfigSchedule(doctorKey, scheduleDayId, 0);
                    if (doctorScheduledDays && doctorScheduledDays.length) {
                        // validate with previous data
                        let starTime = scheduleTimeInterval.startTime;
                        let endTime = scheduleTimeInterval.endTime;
                        let doctorConfigScheduleDayId = scheduleTimeInterval.scheduledayid;
                        let isOverLapping = await this.findTimeOverlaping(doctorScheduledDays, scheduleTimeInterval);
                        if (isOverLapping) {
                            //return error message
                            return {
                                statusCode: HttpStatus.NOT_FOUND,
                                message: CONSTANT_MSG.TIME_OVERLAP
                            }
                        } else {
                            // insert new records
                            await this.insertIntoDocConfigScheduleInterval(starTime, endTime, doctorConfigScheduleDayId);
                        }
                    } else {
                        // no previous datas are there just insert
                        let starTime = scheduleTimeInterval.startTime;
                        let endTime = scheduleTimeInterval.endTime;
                        let doctorConfigScheduleDayId = scheduleTimeInterval.scheduledayid;
                        await this.insertIntoDocConfigScheduleInterval(starTime, endTime, doctorConfigScheduleDayId);
                    }
                }
            }
            return {
                statusCode: HttpStatus.OK,
                message: CONSTANT_MSG.UPDATE_OK
            }
        }
        return {
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.UPDATE_OK
        }
    }


    async getDoctorConfigSchedule(doctorKey: string, scheduleDayId: number, scheduleIntervalId: number): Promise<any> {
        return await this.docConfigScheduleDayRepository.query(queries.getDoctorScheduleInterval, [doctorKey, scheduleDayId, scheduleIntervalId]);
    }

    async deleteDoctorConfigScheduleInterval(scheduletimeid: number, scheduleDayId: number): Promise<any> {
        return await this.docConfigScheduleDayRepository.query(queries.deleteDocConfigScheduleInterval, [scheduletimeid, scheduleDayId]);
    }


    async insertIntoDocConfigScheduleInterval(startTime, endTime, doctorConfigScheduleDayId): Promise<any> {
        return await this.docConfigScheduleDayRepository.query(queries.insertIntoDocConfigScheduleInterval, [startTime, endTime, doctorConfigScheduleDayId])
    }

    async updateIntoDocConfigScheduleInterval(startTime, endTime, doctorConfigScheduleDayId): Promise<any> {
        return await this.docConfigScheduleDayRepository.query(queries.updateIntoDocConfigScheduleInterval, [startTime, endTime, doctorConfigScheduleDayId]);
    }


    async changeUtcToUserTimeZone(appointments, userTimeZone, isAdd, consultationSessionTimingInMilliSeconds) {
        if(isAdd) {
            for(let app of appointments){
                app.appointment_date = moment(app.appointment_date).add(app.startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
                app.startTime = moment(app.startTime, 'HH:mm:ss').add( moment.duration(userTimeZone)).format("HH:mm:ss");
                let slotEndTimeCalculate = Helper.getTimeInMilliSeconds(app.startTime);
                slotEndTimeCalculate += consultationSessionTimingInMilliSeconds; // adding slot startime + consultationSessionTiming, ex: 30 minutes
                app.endTime = Helper.getTimeinHrsMins(slotEndTimeCalculate);
                app.appointment_date = moment(new Date(app.appointment_date)).utcOffset('+'+userTimeZone).format("YYYY-MM-DD");
                app.appointment_date = new Date(app.appointment_date);
            }
            return appointments;
            // app.endTime = moment(app.endTime, 'HH:mm:ss').add( moment.duration(userTimeZone)).format("HH:mm:ss");
        } else {
            for(let app of appointments){
                app.appointment_date = moment(app.appointment_date).add(app.startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
                app.startTime = moment(app.startTime, 'HH:mm:ss').subtract( moment.duration(userTimeZone)).format("HH:mm:ss");
                let slotEndTimeCalculate = Helper.getTimeInMilliSeconds(app.startTime);
                slotEndTimeCalculate += consultationSessionTimingInMilliSeconds; // adding slot startime + consultationSessionTiming, ex: 30 minutes
                app.endTime = Helper.getTimeinHrsMins(slotEndTimeCalculate);
                app.appointment_date = moment(new Date(app.appointment_date)).utcOffset('+'+userTimeZone).format("YYYY-MM-DD");
                app.appointment_date = new Date(app.appointment_date);
            }
            return appointments;
            // app.endTime = moment(app.endTime, 'HH:mm:ss').subtract( moment.duration(userTimeZone)).format("HH:mm:ss");
        }

    }

    async changeDoctorWorkScheduleUtcToUserTimeZone(doctorWorkSchedules, doctorTimeZone) {
        doctorWorkSchedules.forEach(v => {
            v.startTime = moment(v.startTime, 'HH:mm:ss').add( moment.duration('05:30')).format("HH:mm:ss");
            v.endTime = moment(v.endTime, 'HH:mm:ss').add( moment.duration('05:30')).format("HH:mm:ss");
        })
        return doctorWorkSchedules;
    }

    async appointmentSlotsView(user: any, type): Promise<any> {
        try {
            const doc = await this.doctorDetails(user.doctorKey);
            let docId = doc.doctorId;
            let page: number = user.paginationNumber;
            //var date = moment().format('YYYY-MM-DD'); 
            var date: any;
            if(type && type === 'userGivenDate') {
                date = new Date(user.appointmentDate);
            } else {
                date = new Date();
            }
            // date = new Date(moment(new Date(date)).utcOffset("+05:30").format("YYYY-MM-DDTHH:mm:ss.SSSS"));
            var startDate: any = date;
            // var date1: any = new Date();
            let userTimeZone = '05:30';
            // var a =  moment('01:00:00', 'HH:mm:ss').add( moment.duration('05:30')).format("HH:mm:ss");
            // var b = moment('06:00:00', 'HH:mm:ss').subtract( moment.duration('05:30')).format("HH:mm:ss");
            let isAdd = true;
            if(user && user.timeZone && user.timeZone.includes('-')) {
                isAdd = false;
                userTimeZone = user.timeZone.split('-')[1];
            } else {
                userTimeZone = user.timeZone.split('+')[1];
            }
            
            //YYYY-MM-DD hh:mm:ss A Z //
            //  var startDate = new Date(Date.now() + (page * 7 * 24 * 60 * 60 * 1000));  moment(new Date({your_date})).zone("+08:00")
            var possibleNextAppointments = await this.appointmentRepository.query(queries.getAppointByDocId, [docId, startDate]);
            let doctorWorkSchedule = await this.docConfigScheduleDayRepository.query(queries.getDoctorScheduleIntervalAndDay, [user.doctorKey]);
            // doctorWorkSchedule = await this.changeDoctorWorkScheduleUtcToUserTimeZone(doctorWorkSchedule, user.timeZone);
            if (doctorWorkSchedule && doctorWorkSchedule.length) {
                let doctorWorkScheduleObj = {
                    monday: [],
                    tuesday: [],
                    wednesday: [],
                    thursday: [],
                    friday: [],
                    saturday: [],
                    sunday: []
                }
                doctorWorkSchedule.forEach(v => { 
                    
                    if(v.endTime && v.startTime && isAdd) {
                        v.startTime = moment(v.startTime, 'HH:mm:ss').add( moment.duration(userTimeZone)).format("HH:mm:ss");
                        v.endTime = moment(v.endTime, 'HH:mm:ss').add( moment.duration(userTimeZone)).format("HH:mm:ss");
                    } else if(v.endTime && v.startTime && !isAdd){
                        v.startTime = moment(v.startTime, 'HH:mm:ss').subtract( moment.duration(userTimeZone)).format("HH:mm:ss");
                        v.endTime = moment(v.endTime, 'HH:mm:ss').subtract( moment.duration(userTimeZone)).format("HH:mm:ss");
                    }
                    if( v.endTime && v.startTime && ( parseInt(v.endTime.split(':')[0]) < parseInt(v.startTime.split(':')[0]) || v.endTime === '00:00:00' ) )
                    v.endTime = '24:00:00'; 
                    if (v.dayOfWeek === 'Monday') {
                        doctorWorkScheduleObj.monday.push(v);
                    } else if (v.dayOfWeek === 'Tuesday') {
                        doctorWorkScheduleObj.tuesday.push(v);
                    } else if (v.dayOfWeek === 'Wednesday') {
                        doctorWorkScheduleObj.wednesday.push(v);
                    } else if (v.dayOfWeek === 'Thursday') {
                        doctorWorkScheduleObj.thursday.push(v);
                    } else if (v.dayOfWeek === 'Friday') {
                        doctorWorkScheduleObj.friday.push(v);
                    } else if (v.dayOfWeek === 'Saturday') {
                        doctorWorkScheduleObj.saturday.push(v);
                    } else if (v.dayOfWeek === 'Sunday') {
                        doctorWorkScheduleObj.sunday.push(v);
                    }
                })
                const doctorConfigDetails = await this.doctorConfigRepository.findOne({doctorKey: doc.doctorKey});
                let preconsultationHours = doctorConfigDetails.preconsultationHours;
                let preconsultationMins = doctorConfigDetails.preconsultationMins;
                let consultationSessionTiming = doctorConfigDetails.consultationSessionTimings ? doctorConfigDetails.consultationSessionTimings : 10;
                let consultationSessionTimingInMilliSeconds = Helper.getMinInMilliSeconds(doctorConfigDetails.consultationSessionTimings ? doctorConfigDetails.consultationSessionTimings : 10);
                possibleNextAppointments = await this.changeUtcToUserTimeZone(possibleNextAppointments, userTimeZone, isAdd, consultationSessionTimingInMilliSeconds); 
                let appointmentSlots = [];
                let dayOfWeekCount = 0;
                let breaktheloop = 0;
                // var date1: any = new Date();
                // date = new Date(moment(new Date(date1)).utcOffset("+05:30").format("YYYY-MM-DDTHH:mm:ss.SSSS"));
                // var startDate1: any = date1;
                // if(!type && type === 'userGivenDate') {   //future date no need to compare with user time zone
                    date = new Date(moment(new Date(date)).utcOffset(user.timeZone).format("YYYY-MM-DDTHH:mm:ss.SSSS"));
                    startDate = date;
                // }
                var seconds = date.getSeconds();
                        var minutes = date.getMinutes();
                        var hour = date.getHours();
                        var time = hour + ":" + minutes;
                console.log("startDate :", startDate, " : time : ", time);
                while (appointmentSlots.length <= page * 7 + 7) {
                    breaktheloop++;
                    // if(breaktheloop > page * 7 + 7) break;
                    if ((page === 0 && appointmentSlots.length > 7) || (page !== 0 && appointmentSlots.length > page*7+7)) break;
                    if (breaktheloop > 100) break;
                    // run while loop to get minimum 7  days of appointment slots
                    let day = new Date(startDate.getTime() + (dayOfWeekCount * 24 * 60 * 60 * 1000)); // increase the day one by one in loop
                    //let day = moment(startDate,'YYYY-MM-DD').add(dayOfWeekCount, 'days').format()
                    //let day = new Date(startDate.valueOf() + (dayOfWeekCount * 24 * 60 * 60 * 1000));
                    //let dayOfWeek = moment(day).day();
                    let dayOfWeek = day.getDay();
                    let workScheduleDayPresentOrNot = false;
                    let dayOfWeekInWords;
                    if (dayOfWeek === 0) {
                        dayOfWeekInWords = 'sunday';
                    } else if (dayOfWeek === 1) {
                        dayOfWeekInWords = 'monday';
                    } else if (dayOfWeek === 2) {
                        dayOfWeekInWords = 'tuesday';
                    } else if (dayOfWeek === 3) {
                        dayOfWeekInWords = 'wednesday';
                    } else if (dayOfWeek === 4) {
                        dayOfWeekInWords = 'thursday';
                    } else if (dayOfWeek === 5) {
                        dayOfWeekInWords = 'friday';
                    } else if (dayOfWeek === 6) {
                        dayOfWeekInWords = 'saturday';
                    }
                    workScheduleDayPresentOrNot = await this.isWorkScheduleAvailable(dayOfWeekInWords, doctorWorkScheduleObj); // check workSchedule interval present on this day or not
                    if (workScheduleDayPresentOrNot) {  // if workschedule present on this day, then push into appointment slots array
                        let slotObject: any = {};
                        slotObject.dayOfWeek = dayOfWeekInWords;
                        // slotObject.day = day;
                        slotObject.day = moment(day).format("YYYY-MM-DDTHH:mm:ss");
                        slotObject.slots = [];
                        // sort the workSchedule interval timing,ex: in db workSchedule will start 15:00 to 18:00 and second interval will be 10:00 to 12:00
                        // so to order the appointment slots based on startime, we'll sort the scheduleInterval bases on startime in below
                        let sortedWorkScheduleTimeInterval: any = doctorWorkScheduleObj[dayOfWeekInWords];
                        sortedWorkScheduleTimeInterval = sortedWorkScheduleTimeInterval.sort((val1, val2) => {
                            let val1IntervalStartTime = val1.startTime;
                            let val2IntervalStartTime = val2.startTime;
                            val1IntervalStartTime = Helper.getTimeInMilliSeconds(val1IntervalStartTime);
                            val2IntervalStartTime = Helper.getTimeInMilliSeconds(val2IntervalStartTime);
                            if (val1IntervalStartTime < val2IntervalStartTime) {
                                return -1;
                            } else if (val1IntervalStartTime > val2IntervalStartTime) {
                                return 1;
                            }
                            return 0;
                        })
                        
                        //var time = moment().format("HH:mm:ss");
                        var timeMilli = Helper.getTimeInMilliSeconds(time);
                        // In below code => an doctor can have  many intervals on particular day, so run in loop the interval
                        //sortedWorkScheduleTimeInterval.forEach(v => {
                        for (let v of sortedWorkScheduleTimeInterval) {
                            let intervalEndTime = v.endTime;
                            let intervalEnd = false;
                            let slotStartTime = v.startTime;
                            let breaktheloop2 = 0;
                            console.log("slotStartTime: ", slotStartTime, " : intervalEndTime ", intervalEndTime, " : ", slotStartTime)
                            let slotStartTimeInMilliSec = Helper.getTimeInMilliSeconds(slotStartTime);
                            while (!intervalEnd) {  // until the interval endTime comes run the while loop
                                breaktheloop2++;
                               // if (breaktheloop2 > 10) break;
                                let slotEndTimeCalculate = Helper.getTimeInMilliSeconds(slotStartTime);
                                slotEndTimeCalculate += consultationSessionTimingInMilliSeconds; // adding slot startime + consultationSessionTiming, ex: 30 minutes
                                let slotEndTime = Helper.getTimeinHrsMins(slotEndTimeCalculate);
                                // check condition if endtime is less than schedule interval time then break the loop
                                let intervalEndTimeInMilliSeconds = Helper.getTimeInMilliSeconds(intervalEndTime);
                                if (slotEndTimeCalculate > intervalEndTimeInMilliSeconds) { // if slot endTime greater than Interval End time, then break the loop
                                    intervalEnd = true;
                                    continue;
                                }
                                let appointmentPresentOnThisDate = possibleNextAppointments.filter(v => { // check any appointment present on this date
                                    let appDate = Helper.getDayMonthYearFromDate(v.appointment_date);
                                    //let appDate = moment(v.appointment_date).format('YYYY-MM-DD');
                                    let compareDate = Helper.getDayMonthYearFromDate(day);
                                    //let compareDate = moment(day).format('YYYY-MM-DD');
                                    return appDate === compareDate;
                                })
                                let slotPresentOrNot = appointmentPresentOnThisDate.filter(v => {
                                    let startTimeInMilliSec = Helper.getTimeInMilliSeconds(v.startTime);
                                    let endTimeInMilliSec = Helper.getTimeInMilliSeconds(v.endTime);
                                    let slotEndTimeInMilliSec = Helper.getTimeInMilliSeconds(slotEndTime);
                                    // if((slotStartTimeInMilliSec<startTimeInMilliSec && endTimeInMilliSec<=slotEndTimeInMilliSec)||(slotStartTimeInMilliSec >= startTimeInMilliSec && slotStartTimeInMilliSec < endTimeInMilliSec)||(slotEndTimeInMilliSec <= endTimeInMilliSec && slotEndTimeInMilliSec > startTimeInMilliSec)||(slotStartTimeInMilliSec === startTimeInMilliSec && slotEndTimeInMilliSec === endTimeInMilliSec)&& (!v.is_cancel)) {
                                    if (((startTimeInMilliSec >= slotStartTimeInMilliSec && endTimeInMilliSec <= slotEndTimeInMilliSec && slotEndTimeInMilliSec > startTimeInMilliSec) || (slotStartTimeInMilliSec <= startTimeInMilliSec && slotEndTimeInMilliSec >= endTimeInMilliSec && startTimeInMilliSec <= slotEndTimeInMilliSec && slotStartTimeInMilliSec < endTimeInMilliSec) || (startTimeInMilliSec <= slotStartTimeInMilliSec && slotEndTimeInMilliSec <= endTimeInMilliSec) || (slotStartTimeInMilliSec >= startTimeInMilliSec && slotEndTimeInMilliSec <= endTimeInMilliSec)) && (!v.is_cancel)) {
                                        // if ((startTimeInMilliSec === slotStartTimeInMilliSec) && (!v.is_cancel)) {  // if any appointment present then push the booked appointment slots
                                        //let daydate = moment(v.appointment_date).format('YYYY-MM-DD');
                                        let daydate = Helper.getDayMonthYearFromDate(v.appointment_date);
                                        //let datedate = moment(date).format('YYYY-MM-DD');
                                        let datedate = Helper.getDayMonthYearFromDate(date); //todo check date
                                        if (daydate == datedate) {
                                            // if(v.appointmentDate == date){
                                            // var newTime = Helper.getTimeInMilliSeconds(slotStartTime);
                                            if (timeMilli < startTimeInMilliSec /*&& timeMilli < slotStartTimeInMilliSec*/) {
                                                v.slotType = 'Booked';
                                                v.preconsultationHours = preconsultationHours;
                                                v.preconsultationMins = preconsultationMins;
                                                // v.slotTiming = consultationSessionTiming;
                                                let flag = false;
                                                for (let i of slotObject.slots) {
                                                    if (i.id == v.id) {
                                                        flag = true;
                                                    }
                                                }
                                                if (flag == false) {
                                                    slotObject.slots.push(v)
                                                    return true;
                                                }

                                            } else {
                                                return false;
                                            }

                                        } else {
                                            v.slotType = 'Booked';
                                            v.preconsultationHours = preconsultationHours;
                                            v.preconsultationMins = preconsultationMins;
                                            // v.slotTiming = consultationSessionTiming;
                                            let flag = false;
                                            for (let i of slotObject.slots) {
                                                if (i.id == v.id) {
                                                    flag = true;
                                                }
                                            }
                                            if (flag == false) {
                                                slotObject.slots.push(v)
                                                return true;
                                            }

                                        }
                                    } else {
                                        return false;
                                    }
                                })
                                if (!slotPresentOrNot.length) { // if no appointment present on the slot timing, then push the free slots
                                    let dto = {
                                        startTime: slotStartTime,
                                        endTime: slotEndTime,
                                    }
                                    let isOverLapping = await this.findTimeOverlapingForAppointments(appointmentPresentOnThisDate, dto);
                                    var time = date.getHours() + ":" + date.getMinutes();
                                    //var time = moment().format("HH:mm:ss");
                                    var timeInMS = Helper.getTimeInMilliSeconds(time);
                                    var slotEnd = Helper.getTimeInMilliSeconds(slotEndTime);
                                    var insideSlotStartTime = Helper.getTimeInMilliSeconds(slotStartTime);
                                    if (!isOverLapping) {
                                        //let daydate = moment(day).format('YYYY-MM-DD');
                                        let daydate = Helper.getDayMonthYearFromDate(day);
                                        //let datedate = moment(date).format('YYYY-MM-DD');
                                        let datedate = Helper.getDayMonthYearFromDate(date);
                                        if (daydate === datedate) {
                                            if (timeMilli < slotEnd && timeMilli < insideSlotStartTime) {
                                                slotObject.slots.push({ // push free slot obj
                                                    startTime: slotStartTime,
                                                    endTime: slotEndTime,
                                                    slotType: 'Free',
                                                    slotTiming: consultationSessionTiming,
                                                    preconsultationHours: preconsultationHours,
                                                    preconsultationMins: preconsultationMins
                                                })
                                            }
                                            //  else if(slotStartTimeInMilliSec > timeMilli) {
                                            //     continue;
                                            // }
                                             else{
                                                slotStartTime = slotEndTime;
                                                continue
                                            }
                                        } else {
                                            slotObject.slots.push({ // push free slot obj
                                                startTime: slotStartTime,
                                                endTime: slotEndTime,
                                                slotType: 'Free',
                                                slotTiming: consultationSessionTiming,
                                                preconsultationHours: preconsultationHours,
                                                preconsultationMins: preconsultationMins
                                            })
                                        }

                                    }

                                } else {
                                    let dto = {
                                        startTime: slotStartTime,
                                        endTime: slotEndTime,
                                    }
                                    let isOverLapping = await this.findTimeOverlapingForAppointments(appointmentPresentOnThisDate, dto);
                                    if (!isOverLapping) {
                                        slotObject.slots.push({ // push free slot obj
                                            startTime: slotStartTime,
                                            endTime: slotEndTime,
                                            slotType: 'Free',
                                            slotTiming: consultationSessionTiming,
                                            preconsultationHours: preconsultationHours,
                                            preconsultationMins: preconsultationMins
                                        })
                                    }
                                }

                                slotObject.slots = slotObject.slots.sort((val1, val2) => {
                                    let val1IntervalStartTime = val1.startTime;
                                    let val2IntervalStartTime = val2.startTime;
                                    val1IntervalStartTime = Helper.getTimeInMilliSeconds(val1IntervalStartTime);
                                    val2IntervalStartTime = Helper.getTimeInMilliSeconds(val2IntervalStartTime);
                                    if (val1IntervalStartTime < val2IntervalStartTime) {
                                        return -1;
                                    } else if (val1IntervalStartTime > val2IntervalStartTime) {
                                        return 1;
                                    } else {
                                        return 0;
                                    }
                                })
                                slotStartTime = slotEndTime; // update the next slot start time
                                // breaktheloop2++;
                                // if(breaktheloop2 > 10) break;
                                if(slotEndTime >= intervalEndTime) break;
                            }
                            //    })
                        }
                        if (slotObject.slots && slotObject.slots.length) {
                            appointmentSlots.push(slotObject);
                        }
                        
                    }
                    dayOfWeekCount++; // increase to next  Day
                    // breaktheloop++;
                    //if(breaktheloop > 20) break;
                    if(appointmentSlots.length > page*7+7) break;
                }
                var res = [];
                var count = 0;
                appointmentSlots.forEach((e, iterationNumber) => {
                    if (page * 7 <= iterationNumber && count < 7) {
                        res.push(e);
                        count++;
                    }
                });
                return res;
                //return appointmentSlots;
            } else {
                if (type === 'todaysAvailabilitySeats') {
                    return [];
                } else {
                    return {
                        statusCode: HttpStatus.NO_CONTENT,
                        message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                    }
                }
            }
        } catch (e) {
            console.log("Error in appointmentSlotsView api 2", e)
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }


    async appointmentReschedule(appointmentDto: any): Promise<any> {
        try {

            const app = await this.appointmentRepository.query(queries.getAppointmentForDoctor, [appointmentDto.appointmentDate, appointmentDto.doctorId]);
            const currentAppointment = await this.appointmentRepository.findOne(appointmentDto.appointmentId)

            if (app.length) {
                // // validate with previous data
            // let { startTimeInUtc, endTimeInUtc } = await this.convertStartAndEndTimeToUTCTimeZone(appointmentDto.startTime, appointmentDto.endTime, appointmentDto.timeZone);
            // appointmentDto.startTime = startTimeInUtc;
            // appointmentDto.endTime = endTimeInUtc;
            appointmentDto = await this.convertAppointmentDtoToUTCTimeZone(appointmentDto, appointmentDto.timeZone);
                let isOverLapping = await this.findTimeOverlapingForAppointments(app, appointmentDto);
                if (isOverLapping) {
                    //return error message
                    return {
                        statusCode: HttpStatus.NOT_FOUND,
                        message: CONSTANT_MSG.TIME_OVERLAP
                    }
                } else {
                    let end = Helper.getTimeInMilliSeconds(appointmentDto.endTime);
                    let start = Helper.getTimeInMilliSeconds(appointmentDto.startTime);
                    let config = Helper.getMinInMilliSeconds(appointmentDto.config.consultationSessionTimings);
                    let endTime = start + config;
                    if (start > end) {
                        return {
                            statusCode: HttpStatus.BAD_REQUEST,
                            message: CONSTANT_MSG.INVALID_TIMINGS
                        }
                    }
                    if (endTime !== end) {
                        return {
                            statusCode: HttpStatus.BAD_GATEWAY,
                            message: CONSTANT_MSG.END_TIME_MISMATCHING
                        }
                    }
                    //cancelling current appointment
                    var isCancel = await this.appointmentCancel(appointmentDto);
                    if (isCancel.statusCode != HttpStatus.OK) {
                        return isCancel;
                    } else {
                        // create appointment on existing date old records
                        const appoint = await this.appointmentRepository.createAppointment(appointmentDto);
                        if (!appoint.message) {
                            const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);
                            return {
                                appointment: appoint,
                                appointmentDocConfig: appDocConfig
                            }
                        } else {
                            return appoint;
                        }
                    }

                }

            }
            //cancelling current appointment
            var isCancel = await this.appointmentCancel(appointmentDto);
            if (isCancel.statusCode != HttpStatus.OK) {
                return isCancel;
            } else {
                appointmentDto = {...appointmentDto, reportid: currentAppointment?.reportid || null}
                appointmentDto = await this.convertAppointmentDtoToUTCTimeZone(appointmentDto, appointmentDto.timeZone);
                const appoint = await this.appointmentRepository.createAppointment(appointmentDto);
                if (!appoint.message) {
                    const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);

                    return {
                        appointment: appoint,
                        appointmentDocConfig: appDocConfig
                    }
                } else {
                    return appoint;
                }
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }

    async getprescriptionUrl(id: any) : Promise<any> {
        try {
            const prescriptionDetails = await this.prescriptionRepository.find({appointmentId: id});
            let prescriptionUrl = [];
            if (prescriptionDetails && prescriptionDetails.length) {

                for(let i = 0; i < prescriptionDetails.length; i++) {
                    prescriptionUrl.push(prescriptionDetails[i].prescriptionUrl);
                }
            }

            return prescriptionUrl;
        }

        catch(e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }
    async appointmentDetails(id: any): Promise<any> {
        try {
            const appointmentDetails = await this.appointmentRepository.findOne({ id: id });
            const pat = await this.patientDetailsRepository.findOne({ patientId: appointmentDetails.patientId });
            const docId = await this.doctorRepository.findOne({ doctorId: appointmentDetails.doctorId }) 
            const pay = await this.paymentDetailsRepository.findOne({ appointmentId: id });
            // get patient report


            
            const reports=[];
             if(appointmentDetails.reportid){   
                const reportIds=appointmentDetails.reportid.split(',');
            reportIds.map(async id=>{
                const report = await this.patientReportRepository.findOne({
                    
                    where: {
                        id: parseInt(id),
                        active:true
                    }
                    });
                    if(report)
                        reports.push(report);

            })
            
        }
            
            
            let patient = {
                id: pat.id,
                firstName: pat.firstName,
                lastName: pat.lastName,
                phone: pat.phone,
                email: pat.email
            }
            let doctorId = {
                doctorKey: docId.doctorKey,
                accountKey: docId.accountKey,
                email: docId.email,
                doctorLiveStatus: docId.liveStatus,
                firstName: docId.firstName,
                lastName: docId.lastName,
                photo: docId.photo,
                speciality: docId.speciality,
                doctorId: docId.doctorId,

            }
            let res = {
                appointmentDetails: appointmentDetails,
                patientDetails: patient,
                paymentDetails: pay,
                reportDetails: reports,
                DoctorDetails: doctorId,

            }
            return res;
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async appointmentCancel(appointmentDto: any): Promise<any> {
        try {
            if (!appointmentDto.appointmentId) {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
            var appoint = await this.appointmentRepository.findOne({id: appointmentDto.appointmentId});
            if (appoint.createdBy === CONSTANT_MSG.ROLES.DOCTOR && appoint.paymentOption === 'directPayment') {
                if (!appointmentDto.confirmation) {
                    return {
                        statusCode: HttpStatus.BAD_REQUEST,
                        message: CONSTANT_MSG.CONFIRMATION_REQUIRED
                    }
                }
            }
            if (appoint.isCancel == true) {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.APPOINT_ALREADY_CANCELLED
                }
            }
            var condition = {
                id: appointmentDto.appointmentId
            }
            var values: any = {
                isActive: false,
                isCancel: true,
                cancelledBy: appointmentDto.user.role.indexOf('DOCTOR') != -1 ? CONSTANT_MSG.ROLES.DOCTOR : appointmentDto.user.role.indexOf('ADMIN') != -1 ? CONSTANT_MSG.ROLES.ADMIN : appointmentDto.user.role.indexOf('DOC_ASSISTANT') != -1 ? CONSTANT_MSG.ROLES.DOC_ASSISTANT : appointmentDto.user.role.indexOf('PATIENT') != -1 ? CONSTANT_MSG.ROLES.PATIENT : CONSTANT_MSG.ROLES.PATIENT,
                cancelledId: appointmentDto.user.userId
            }
            var pastAppointment = await this.appointmentRepository.update(condition, values);
            if (pastAppointment.affected) {
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.APPOINT_CANCELED
                }
            } else {
                return {
                    statusCode: HttpStatus.NOT_MODIFIED,
                    message: CONSTANT_MSG.UPDATE_FAILED
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NOT_MODIFIED,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }


    async patientSearch(patientDto: any): Promise<any> {
        try {
            if (patientDto.phone) {
                // const patientDetails = await this.patientDetailsRepository.find({phone: patientDto.phone});
                const patientDetails = await this.patientDetailsRepository.query(queries.getPatient, [patientDto.phone + '%'])
                if (patientDetails) {
                    return patientDetails;
                } else {
                    return {
                        statusCode: HttpStatus.NO_CONTENT,
                        message: CONSTANT_MSG.INVALID_MOBILE_NO
                    }
                }
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.INVALID_MOBILE_NO
                }
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }

    }

    async patientRegistration(patientDto: PatientDto): Promise<any> {
        const patient = await this.patientDetailsRepository.patientRegistration(patientDto);
        return patient;
        // return await this.patientDetailsRepository.patientRegistration(patientDto);
    }


    async findDoctorByCodeOrName(codeOrName: any): Promise<any> {
        try {
            //  const name = await this.doctorRepository.findOne({doctorName: codeOrName});
            let codeOrNameTime = codeOrName ? codeOrName.trim() : codeOrName;
            const name = await this.doctorRepository.query(queries.getDoctorByName, ['%'+codeOrNameTime+'%'])
            const hospital = await this.accountDetailsRepository.query(queries.getHospitalByName, [codeOrName])

            name.sort((a, b)=>{
                if(a.firstName < b.firstName) { return -1; }
                if(a.firstName > b.firstName) { return 1; }
                return 0;
            })
            return {
                doctors: name,
                hospitals: hospital
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }

    }

    async patientDetailsEdit(patientDto: any): Promise<any> {
        try {
            const patient = await this.patientDetailsRepository.findOne({patientId: patientDto.patientId});
            if (patientDto.phone) {
                let isPhone = await this.isPhoneExists(patientDto.phone);
                if (isPhone.isPhone) {
                    if (isPhone.patientDetails.patientId == patientDto.patientId) {
                        if (!patient) {
                            return {
                                statusCode: HttpStatus.NO_CONTENT,
                                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                            }
                        } else {
                            var condition = {
                                patientId: patientDto.patientId
                            }
                            var values: any = patientDto;
                            var updatePatientDetails = await this.patientDetailsRepository.update(condition, values);
                            if (updatePatientDetails.affected) {
                                return {
                                    statusCode: HttpStatus.OK,
                                    message: CONSTANT_MSG.UPDATE_OK
                                }
                            } else {
                                return {
                                    statusCode: HttpStatus.NOT_MODIFIED,
                                    message: CONSTANT_MSG.UPDATE_FAILED
                                }
                            }
                        }
                    } else {
                        //return error message
                        return {
                            statusCode: HttpStatus.NOT_FOUND,
                            message: CONSTANT_MSG.PHONE_EXISTS
                        }
                    }

                }
            }
            if (!patient) {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            } else {
                var condition1 = {
                    patientId: patientDto.patientId
                }
                var values: any = patientDto;
                var updatePatientDetails = await this.patientDetailsRepository.update(condition1, values);
                if (updatePatientDetails.affected) {
                    return {
                        statusCode: HttpStatus.OK,
                        message: CONSTANT_MSG.UPDATE_OK
                    }
                } else {
                    return {
                        statusCode: HttpStatus.NOT_MODIFIED,
                        message: CONSTANT_MSG.UPDATE_FAILED
                    }
                }
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }

    }

    async viewAppointmentSlotsForPatient(doctor: any): Promise<any> {
        try {
            const doc = await this.doctorDetails(doctor.doctorKey);
            var docId = doc.doctor_id;
            // const app = await this.appointmentRepository.find({doctorId:docId});
            const app = await this.appointmentRepository.query(queries.getAppointmentOnDate, [doctor.appointmentDate]);
            if (app.length) {
                var appointment: any = app;
                for (var i = 0; i < appointment.length; i++) {
                    if (!appointment[i].is_cancel && appointment[i].is_active) {
                        const patId = appointment[i].patient_id;
                        const pat = await this.patientDetailsRepository.findOne({id: patId});
                        appointment[i].patientDetails = pat;
                        const pay = await this.paymentDetailsRepository.findOne({appointmentId: appointment[i].id});
                        appointment[i].paymentDetails = pay;
                    }
                }
                return appointment;
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }

    async patientPastAppointments(user: any): Promise<any> {
        try {
            let d = new Date();
            //var date = moment().format('YYYY-MM-DD');
            var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
            let offset = (user.paginationNumber) * (user.limit);
            var minutes = d.getMinutes();
            var hour = d.getHours();
            var time = hour + ':' + minutes + ':' + '00';
            var beforeADay = moment(new Date().setDate(new Date().getDate() - 1)).format("YYYY-MM-DD");
            let app = await this.appointmentRepository.query(queries.getPastAppointmentsWithPagination, [user.patientId, date, offset, user.limit, 'completed', 'notCompleted', beforeADay, time,'paused']);
            if (!app.length) {
                return [];
            }
            const appNum = await this.appointmentRepository.query(queries.getPastAppointments, [user.patientId, date,'completed','notCompleted', beforeADay, time ,'paused']);
            let appNumber = appNum.length;
            if (app.length) {
                var appList: any = [];
                app = await this.convertAppointmentsUtctoUserTimeZone(app, user.timeZone);
                for (let appointmentList of app) {
                    if (appointmentList.appointment_date == date) {
                        if (appointmentList.is_active == false) {
                            let doctor = await this.doctor_Details(appointmentList.doctorId);
                            let account = await this.accountDetails(doctor.accountKey);
                            let res = {
                                appointmentDate: appointmentList.appointment_date,
                                appointmentId: appointmentList.id,
                                startTime: appointmentList.startTime,
                                endTime: appointmentList.endTime,
                                doctorFirstName: doctor.firstName,
                                doctorLastName: doctor.lastName,
                                hospitalName: account.hospitalName,
                                doctorKey: doctor.doctorKey
                            }
                            appList.push(res);
                        }
                    } else {
                        let doctor = await this.doctor_Details(appointmentList.doctorId);
                        let account = await this.accountDetails(doctor.accountKey);
                        let res = {
                            appointmentDate: appointmentList.appointment_date,
                            appointmentId: appointmentList.id,
                            startTime: appointmentList.startTime,
                            endTime: appointmentList.endTime,
                            doctorFirstName: doctor.firstName,
                            doctorLastName: doctor.lastName,
                            hospitalName: account.hospitalName,
                            doctorKey: doctor.doctorKey
                        }
                        appList.push(res);
                    }
                }
                let result = {
                    totalAppointments: appNumber,
                    appointments: appList
                }
                return result;
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }

    async patientUpcomingAppointments(user: any): Promise<any> {
        try {
            let d = new Date();
            // let d = new Date(moment(new Date()).utcOffset(user.timeZone));
            var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();  // getting only today's date, so next day ipcoming data failed to result
            // var time = (d.getHours()+ 1) + ':' + d.getMinutes() + ':' + d.getSeconds();
            //var date = moment().format('YYYY-MM-DD');
            let offset = (user.paginationNumber) * (user.limit);
            let  userCurrentDate = moment(new Date()).utcOffset(user.timeZone).format("YYYY-MM-DD");
            let currentDate = Helper.getDayMonthYearFromDate(new Date());
            let app;        
            this.logger.log("patientUpcomingAppointments Query >>> " + date + ", offset:"+offset);
            var minutes = d.getMinutes();
            var hour = d.getHours();
            var time = hour + ':' + minutes + ':' + '00';
            var beforeADay = moment(new Date().setDate(new Date().getDate() - 1)).format("YYYY-MM-DD");
            let appNum = [];
            if (user.limit) {
                this.logger.log("patientUpcomingAppointments Query 1 >>> " + queries.getUpcomingAppointmentsWithPagination);
                if(currentDate === userCurrentDate) {
                    app = await this.appointmentRepository.query(queries.getUpcomingAppointmentsWithPagination, [user.patientId, date, offset, user.limit, 'notCompleted', 'paused',beforeADay,time]);
                    appNum = await this.appointmentRepository.query(queries.getUpcomingAppointmentsCounts, [user.patientId, date, 'notCompleted', 'paused',beforeADay, time]);
                } else {
                const currentTimeInArray = moment(new Date()).format("HH:mm:ss").split(':');
                const currentTimeFormat = currentTimeInArray[0] + ':' + currentTimeInArray[1] + ':' + currentTimeInArray[2];
                app = await this.appointmentRepository.query(queries.getUpcomingAppointmentsWithTimeWithPagination, [user.patientId, date, offset, user.limit, 'notCompleted', 'paused', userCurrentDate, currentTimeFormat , beforeADay, time ]);                    
                appNum = await this.appointmentRepository.query(queries.getUpcomingAppointmentsWithTimeCounts, [user.patientId, date, 'notCompleted', 'paused', userCurrentDate, currentTimeFormat, beforeADay, time ]);
                }
                if (!app.length) {
                    return [];
                }
            } else {
                this.logger.log("patientUpcomingAppointments Query 2 >>> " + queries.getTodayAppointments);
                app = await this.appointmentRepository.query(queries.getTodayAppointments, [user.patientId, date, 'notCompleted', 'paused',beforeADay,time]);
                appNum = await this.appointmentRepository.query(queries.getUpcomingAppointmentsCounts, [user.patientId, date, 'notCompleted', 'paused',beforeADay,time]);
                if (!app.length) {
                    return [];
                }
            }
            this.logger.log("patientUpcomingAppointments Query 3 >>> " + queries.getUpcomingAppointmentsCounts);
            // const appNum = await this.appointmentRepository.query(queries.getUpcomingAppointmentsCounts, [user.patientId, date, 'notCompleted', 'paused']);
            let appNumber = appNum.length;
            // app.appointment_date = moment(app.appointment_date).add(app.startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
            // // var a = new Date(moment(app.appointment_date).add(app.startTime));
            // app.appointment_date = moment(new Date(app.appointment_date)).utcOffset("+05:30").format("YYYY-MM-DDTHH:mm:ss.SSSS");
            if (app.length) {
                var appList: any = [];
                app = await this.convertAppointmentsUtctoUserTimeZone(app, user.timeZone);
                for (let appointmentList of app) {
                    if (appointmentList.appointment_date == date) {
                        if (appointmentList.is_active == true) {
                            let doctor = await this.doctor_Details(appointmentList.doctorId);
                            let account = await this.accountDetails(doctor.accountKey);
                            let config = await this.getAppDoctorConfigDetails(appointmentList.id);
                            var preConsultationHours = null;
                            var preConsultationMins = null;
                            if (config.isPreconsultationAllowed) {
                                preConsultationHours = config.preconsultationHours;
                                preConsultationMins = config.preconsultationMins;
                            }

                            let res = {
                                appointmentDate: appointmentList.appointment_date,
                                appointmentId: appointmentList.id,
                                startTime: appointmentList.startTime,
                                endTime: appointmentList.endTime,
                                doctorFirstName: doctor.firstName,
                                doctorLastName: doctor.lastName,
                                hospitalName: account.hospitalName,
                                preConsultationHours: preConsultationHours,
                                preConsultationMins: preConsultationMins,
                                doctorId: appointmentList.doctorId,
                                doctorKey: doctor.doctorKey,
                                liveStatus : doctor.liveStatus,
                                email: doctor.email,
                                isAttenderApp: appointmentList.isAttenderApp ,
                            }
                            appList.push(res);
                        }
                    } else {
                        let doctor = await this.doctor_Details(appointmentList.doctorId);
                        let account = await this.accountDetails(doctor.accountKey);
                        let config = await this.getAppDoctorConfigDetails(appointmentList.id);
                        var preConsultationHours = null;
                        var preConsultationMins = null;
                        if (config && config.isPatientPreconsultationAllowed) {
                            preConsultationHours = config.preconsultationHours;
                            preConsultationMins = config.preconsultationMinutes;
                        }

                        let res = {
                            appointmentDate: appointmentList.appointment_date,
                            appointmentId: appointmentList.id,
                            startTime: appointmentList.startTime,
                            endTime: appointmentList.endTime,
                            doctorFirstName: doctor.firstName,
                            doctorLastName: doctor.lastName,
                            hospitalName: account.hospitalName,
                            preConsultationHours: preConsultationHours,
                            preConsultationMins: preConsultationMins,
                            doctorId: appointmentList.doctorId,
                            doctorKey: doctor.doctorKey,
                            liveStatus : doctor.liveStatus,
                            email: doctor.email,
                            isAttenderApp: appointmentList.isAttenderApp ,
                        }
                        appList.push(res);
                    }
                }
                let result = {
                    totalAppointments: appNumber,
                    appointments: appList
                }
                return result;
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }
    async mobileVersion(): Promise<any> {
        const version = await this.versionRepository.find();
        if(version){
            return{
                statusCode: HttpStatus.OK,
                versionDetails: {
                    androidMinSupportedVersion: version[0].android_version ,
                    iOSMinSupportedVersion: version[0].ios_version
                    }
               };
        }
        else{          
            return{
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
    }

    async meetingIdValidation(meetingId:any): Promise<any> {        
        let d = new Date();
        var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
        var beforeADay = moment(new Date().setDate(new Date().getDate() - 1)).format("YYYY-MM-DD");
        const meetingIdValidation = await this.appointmentRepository.query(queries.getMeetingIdForValidation, [meetingId,date,beforeADay]);
        const timeZone='';
        if(meetingIdValidation && meetingIdValidation.length){
            const meetingDetails = {
                appointmentId:meetingIdValidation[0].id,
                appointmentDate:meetingIdValidation[0].appointmentdate,
                startTime:meetingIdValidation[0].startTime,
                endTime:meetingIdValidation[0].endTime,
                patientId:meetingIdValidation[0].patient_id,
                patientName:meetingIdValidation[0].name,
                doctorId:meetingIdValidation[0].doctorId,
                doctorName:meetingIdValidation[0].doctor_name,
                doctorKey:meetingIdValidation[0].doctor_key,  
            }
            meetingIdValidation.appointmentDetails = await this.convertMyAppUtcToUser(meetingDetails,timeZone);
            return{
                statusCode: HttpStatus.OK,
                message: "Id Validation successfull",
                Details: meetingIdValidation.appointmentDetails
               };
        }
        else{          
            return{
                statusCode: HttpStatus.BAD_REQUEST,
                message: "Invalid meeting id"
            }
        }
    }
    
    
    
    async appointmentAlert(date:any): Promise<any> {
        const appointmentDetails = await this.appointmentRepository.query(queries.getAppointmentDetailsByDate, [date]);
        return appointmentDetails;      
    }

    async patientList(doctorId: any,paginationNumber:any): Promise<any> {
        const app = await this.appointmentRepository.query(queries.getAppList, [doctorId]);
        let ids = [];
        app.forEach(a => {
            let flag = false;
            ids.forEach(i => {
                if (i == a.patient_id)
                    flag = true;
            });
            if (flag == false) {
                ids.push(a.patient_id)
            }
        });
        let patientList = [];
        let pag:number = paginationNumber;
        let m:number = pag*15;
        var n:number =  (pag*15)+15;
        var pats =[];
        for (var i = m; i < n; i++){
            pats.push(ids[i]);
        }
        // for (let x of ids) {
        //     const patient = await this.patientDetailsRepository.query(queries.getPatientDetails, [x]);
        //     if(patient[0]){
        //         patientList.push(patient[0]);
        //     }
        // }
        for (let x of pats) {
            const patient = await this.patientDetailsRepository.query(queries.getPatientDetails, [x]);
            if(patient[0]){
                patientList.push(patient[0]);
            }
        }
        return {totalPatients:ids.length,
            patientsList:patientList};
    }

    async doctorPersonalSettingsEdit(doctorDto: DoctorDto): Promise<any> {
        try {
            var condition = {
                doctorKey: doctorDto.doctorKey
            }
            if(doctorDto.reportRemainder){
                const reportRemainder = (doctorDto.reportRemainder === CONSTANT_MSG.REPORT_REMAINDER_STRING.ON_EVERY_APPOINTMENT) ? CONSTANT_MSG.REPORT_REMAINDER.ON_EVERY_APPOINTMENT : (doctorDto.reportRemainder === CONSTANT_MSG.REPORT_REMAINDER_STRING.ONCE_A_DAY) ? CONSTANT_MSG.REPORT_REMAINDER.ONCE_A_DAY : CONSTANT_MSG.REPORT_REMAINDER.NEVER;             
                doctorDto.reportRemainderId=await this.doctorReportRemainderId(reportRemainder);
                delete doctorDto.reportRemainder;
            }
            var values: any = doctorDto;
            var updateDoctorConfig = await this.doctorRepository.update(condition, values);
            if (updateDoctorConfig.affected) {
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.UPDATE_OK
                }
            } else {
                return {
                    statusCode: HttpStatus.NOT_MODIFIED,
                    message: CONSTANT_MSG.UPDATE_FAILED
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }

    }

    async hospitaldetailsEdit(hospitalDto: HospitalDto): Promise<any> {
        try {
            // update the doctorConfig details
            var condition = {
                accountKey: hospitalDto.accountKey
            }
            var values: any = hospitalDto;
            var updateHospital = await this.accountDetailsRepository.update(condition, values);
            if (updateHospital.affected) {
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.UPDATE_OK
                }
            } else {
                return {
                    statusCode: HttpStatus.NOT_MODIFIED,
                    message: CONSTANT_MSG.UPDATE_FAILED
                }
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async viewDoctorDetails(details: any): Promise<any> {

        const app = await this.appointmentDetails(details.appointmentId);
        const doctor = app.DoctorDetails;
        const d1 = await this.doctorDetails(doctor.doctorKey);
        const account = await this.accountDetails(doctor.accountKey);
        const config = await this.getAppDoctorConfigDetails(details.appointmentId);
        const patient = await this.getPatientDetails(app.appointmentDetails.patientId);
        const prescriptionUrl = await this.getprescriptionUrl(details.appointmentId);

        let preHours = null;
        let preMins = null;
        let canDays = null;
        let canHours = null;
        let canMins = null;
        let reschDays = null;
        let reschHours = null;
        let reschMins = null;
        if (config.isPatientPreconsultationAllowed) {
            preHours = config.preconsultationHours;
            preMins = config.preconsultationMinutes;
        }
        if (config.isPatientCancellationAllowed) {
            canDays = config.cancellationDays;
            canHours = config.cancellationHours;
            canMins = config.cancellationMinutes;
        }
        if (config.isPatientRescheduleAllowed) {
            reschDays = config.rescheduleDays;
            reschHours = config.rescheduleHours;
            reschMins = config.rescheduleMinutes;
        }
        // let {  startTimeInUserTimeZone, endTimeInUserTimeZone  } = await this.convertStartAndEndTimeUtcToUserTimeZone(app.appointmentDetails.startTime, app.appointmentDetails.endTime, details.timeZone); 
        app.appointmentDetails = await this.convertMyAppUtcToUser(app.appointmentDetails, details.timeZone);
        var res = {
            appointmentId: details.appointmentId,
            doctorKey: details.doctorKey,
            reportDetail: app.reportDetails,
            email: doctor.email,
            doctorPhoto:doctor.photo,
            speciality:doctor.speciality,
            consultationTimeSlot: app.appointmentDetails.slotTiming,
            mobileNo: doctor.number,
            hospitalName: account.hospitalName,
            street:account.street1 ? account.street1 : '',
            city: account.city ? account.city : '',
            state:account.state ? account.state : '',
            pincode:account.pincode,
            country:account.country ? account.country : '',
            appointmentDate: app.appointmentDetails.appointmentDate,
            startTime: app.appointmentDetails.startTime,
            endTime: app.appointmentDetails.endTime,
            preConsultationHours: preHours,
            preConsulationMinutes: preMins,
            cancellationDays: canDays,
            cancellationHours: canHours,
            cancellationMins: canMins,
            rescheduleDays: reschDays,
            rescheduleHours: reschHours,
            rescheduleMins: reschMins,
            doctorId: doctor.doctorId,
            patientId: app.appointmentDetails.patientId,
            doctorFirstName: doctor.firstName,
            doctorLastName: doctor.lastName,
            patientFirstName: patient.firstName,
            patientLastName: patient.lastName,
            doctorLiveStatus: doctor.doctorLiveStatus,
            prescriptionUrl: prescriptionUrl,
            attenderEmail: app.appointmentDetails.attenderEmail,
            attenderName: app.appointmentDetails.attenderName,
            attenderMobile: app.appointmentDetails.attenderMobile,
            isAttenderApp: app.appointmentDetails.patientId == details.patientId ? 0 : 1 ,
        }
        return res;

    }

    async getAvailableSlotsInSlotsList(slotsviews, appointmentDate) {
        let slotview;
        let appDate = Helper.getDayMonthYearFromDate(appointmentDate);
        for(let j=0;j<slotsviews.length;j++){
            let daydate = Helper.getDayMonthYearFromDate(slotsviews[j].day);
            if(appDate === daydate){
            slotview=slotsviews[j];
            break;
            }
        }
       return slotview;
    }

    async getSeletedDateAppList(user, datedate) {
        let slotsviews = await this.appointmentSlotsView(user, 'userGivenDate');
        let slotview;
        for(let j=0;j<slotsviews.length;j++){
            let daydate = Helper.getDayMonthYearFromDate(slotsviews[j].day);
            if(daydate == datedate){
            slotview=slotsviews[j];
            break;
            }
        }
        return slotview;
    }

    async availableSlots(user: any, type: string): Promise<any> {
        const doctor = await this.doctorDetails(user.doctorKey);
        const app = await this.appointmentRepository.query(queries.getAppointments, [doctor.doctorId, user.appointmentDate]);
       
        const config = await this.getDoctorConfigDetails(user.doctorKey)
        let days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        let dt = new Date(user.appointmentDate);
        //let day = days[user.appointmentDate.getDay()]
        let day = days[dt.getDay()];
        let datedate = Helper.getDayMonthYearFromDate(dt); //todo check date
        user.paginationNumber=0;

        // find today availablity seates
        let slotsviews = await this.appointmentSlotsView(user, 'todaysAvailabilitySeats');
        let slotview;

    //    for(let j=0;j<slotsviews.length;j++){
        if(slotsviews && slotsviews.length && typeof slotsviews === 'object'
        && !slotsviews.statusCode
         /*&& slotsviews[0].dayOfWeek.toLowerCase() === day.toLowerCase()*/){
            let daydate = Helper.getDayMonthYearFromDate(slotsviews[0].day);
            //let datedate = moment(date).format('YYYY-MM-DD');
            // console.log("test: ", v.appointment_date, " : daydate : " , daydate, " :datedate : ", datedate);
            if (daydate == datedate) {
                slotview=slotsviews[0];
            } else if(type && type === 'getRecentUpComingDayApp'){
                for(let j=0;j<slotsviews.length;j++){
                    let daydate = Helper.getDayMonthYearFromDate(slotsviews[j].day);
                    if(daydate == datedate){
                    slotview=slotsviews[j];
                    break;
                    }
                }
                if(!slotsviews) {
                    return [];
                } else if(user.confirmation){
                    const nextday = new Date(dt);
                    let breakTheLoop = 0;
                    while(!slotview){
                        if(slotsviews.length == 0 || breakTheLoop > 7) break;
                        nextday.setDate(nextday.getDate() + 1);
                        // day = days[nextday.getDay()];
                        user.appointmentDate = nextday;
                        slotview = await this.getAvailableSlotsInSlotsList(slotsviews, user.appointmentDate);
                        // breakTheLoop++;
                    }
                    // if(breakTheLoop > 7 && !slotview) {
                    //     user.appointmentDate = dt;
                    //     slotview = await this.getFutureAppList(user, datedate);
                    // }
                } else {
                    const nextday = new Date(dt);
                    let breakTheLoop = 0;
                    while(!slotview){
                        if(slotsviews.length == 0 || breakTheLoop > 7) break;
                        // nextday.setDate(nextday.getDate() + 1);
                        // day = days[nextday.getDay()];
                        user.appointmentDate = nextday;
                        slotview = await this.getAvailableSlotsInSlotsList(slotsviews, user.appointmentDate);
                        breakTheLoop++;
                    }
                    if(breakTheLoop > 7 && !slotview) {
                        user.appointmentDate = dt;
                        slotview = await this.getSeletedDateAppList(user, datedate);
                    }
                }
            } else {
                console.log("asgujgaduyaf7wte87rgwejkfwveifuwgevgu")
            }
            // console.log("asdasds, ", slotview )
            // break;
        } else if(!slotsviews) {
            return [];
        } 
//         else if (!type && type !== 'doctorList') {
//             for(let j=0;j<slotsviews.length;j++){

//                 if(slotsviews[j].dayOfWeek.toLowerCase() === day.toLowerCase()){
                
//                 slotview=slotsviews[j];
                
//                 break;
//                 }
//             }
//         }
    //    }
       let date = new Date();
       date = moment(new Date(date)).utcOffset(user.timeZone).format("YYYY-MM-DDTHH:mm:ss.SSSS");
       date = new Date(date);
       var time = date.getHours() + ":" + date.getMinutes();
       var timeMilli = Helper.getTimeInMilliSeconds(time);
       let resSlot=[];
       let dateForm = Helper.getDayMonthYearFromDate(date);
       dt = new Date(user.appointmentDate);
       let dtForm = Helper.getDayMonthYearFromDate(dt);
       if(slotview !== undefined)
       if(dateForm == dtForm){
        for(let j=0;j<slotview.slots.length;j++){
            let end = Helper.getTimeInMilliSeconds(slotview.slots[j].endTime);
            let start = Helper.getTimeInMilliSeconds(slotview.slots[j].startTime);
            if((slotview.slots[j].slotType.toLowerCase() == 'free') && timeMilli < end && start >= timeMilli){
                resSlot.push(slotview.slots[j]);
            }
        }
       } else {
            for(let j=0;j<slotview.slots.length;j++){
                if(slotview.slots[j].slotType.toLowerCase() == 'free'){
                    resSlot.push(slotview.slots[j]);
                }
            }
        }
        // console.log("resSlot: ", resSlot);
       return resSlot;
    }

    async patientDetails(patientId: any): Promise<any> {
        const app = await this.appointmentRepository.query(queries.getAppListForPatient, [patientId]);
        const patient = await this.patientDetailsRepository.query(queries.getPatientDetails, [patientId]);
        let res = {
            patientDetails: patient[0],
            appointments: app
        }
        return res;
    }

    async patientDetailsByPatientId(patientId: number): Promise<any> {
        const patient = await this.patientDetailsRepository.query(queries.getPatientDetails, [patientId]);
        return patient[0];
    }

    async reports(accountKey: any, paginationNumber: any): Promise<any> {
        let offset = paginationNumber * 10;
        const app = await this.appointmentRepository.query(queries.getReports, [accountKey, offset]);
        return app;
    }

    async listOfDoctorsInHospital(accountKey: any): Promise<any> {
        const app = await this.doctorRepository.query(queries.getDocListDetails, [accountKey]);
        let res = [];
        app.forEach(a => {
            let b = {
                doctorId: a.doctorId,
                accountkey: a.account_key,
                doctorKey: a.doctor_key,
                speciality: a.speciality,
                photo: a.photo,
                signature: a.signature,
                number: a.number,
                firstName: a.first_name,
                lastName: a.last_name,
                registrationNumber: a.registration_number,
                fee: a.consultation_cost,
                street: a.street1 ? a.street : "",
                city:a.city ? a.city : "",
                state:a.state ? a.state : "",
                pincode:a.pincode ? a.pincode : "",
                country:a.country ? a.country : "",
                hospitalName: a.hospital_name,
                experience:a.experience
            }
            res.push(b);
        });
        return res;
    }

    async viewDoctor(details: any): Promise<any> {
        const doctor = await this.doctorDetails(details.doctorKey);
        const account = await this.accountDetails(doctor.accountKey);
        const config = await this.getDoctorConfigDetails(doctor.doctorKey);
        let preHours;
        let preMins;
        let canDays;
        let canHours;
        let canMins;
        let reschDays;
        let reschHours;
        let reschMins;
        if (config.isPreconsultationAllowed) {
            preHours = config.preconsultationHours;
            preMins = config.preconsultationMins;
        }
        if (config.isPatientCancellationAllowed) {
            canDays = config.cancellationDays;
            canHours = config.cancellationHours;
            canMins = config.cancellationMins;
        }
        if (config.isPatientRescheduleAllowed) {
            reschDays = config.rescheduleDays;
            reschHours = config.rescheduleHours;
            reschMins = config.rescheduleMins;
        }
        var res = {
            name: doctor.doctorName,
            firstName: doctor.firstName,
            lastName: doctor.lastName,
            speciality: doctor.speciality,
            experience: doctor?.experience,
            mobileNo: doctor.number,
            hospitalName: account.hospitalName,
            street:account.street1  ? account.street1 : "",
            city: account.city  ? account.city : "",
            pincode:account.pincode ? account.pincode : "",
            state:account.state  ? account.state : "",
            country:account.country ? account.country : "",
            fee: config.consultationCost,
            preConsultationHours: preHours,
            preConsulationMinutes: preMins,
            cancellationHours: canHours,
            cancellationDays: canDays,
            cancellationMins: canMins,
            rescheduleDays: reschDays,
            rescheduleHours: reschHours,
            rescheduleMins: reschMins,
            photo: doctor.photo,
            sessionTiming: config.consultationSessionTimings
        }
        return res;
    }

    async getPatientDetails(patientId: any) {
        const patient = await this.patientDetailsRepository.findOne({patientId: patientId});
        return patient;
    }

    async getAppDoctorConfigDetails(appointmentId): Promise<any> {
        return await this.appointmentDocConfigRepository.findOne({appointmentId: appointmentId});
    }

    async detailsOfPatient(patientId: any): Promise<any> {
        const patient = await this.patientDetailsRepository.query(queries.getPatientDetails, [patientId]);
        let patientDetails = patient[0];
        patientDetails["description"] = "";
        patientDetails["allergiesList"] = [];
        return patientDetails;
    }
    
    // async convertUtcToUserTimeZone(appoinments, timeZone) {
    //     let userTimeZone;
    //     console.log("Priting the tz values: ", timeZone);
    //     timeZone = timeZone ? timeZone : '+05:30';
    //     if (timeZone.includes('+')) {
           
    //         userTimeZone = timeZone.split('+')[1];
    //         for(let x of appoinments){
    //             console.log("log in + sign", x.startTime);
    //             x.startTime = moment(x.startTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
    //             console.log("log in + sign1234", x.startTime);
    //             x.endTime = moment(x.endTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
    //         }
    //         return appoinments;
    //     } else {
    //         console.log("log in - sign")
    //         userTimeZone = timeZone.split('-')[1];
    //         for(let x of appoinments){
    //             x.startTime = moment(x.startTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
    //             x.endTime = moment(x.endTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
    //         }
    //         return appoinments;
    //     }
    // }

    async convertAppointmentsUtctoUserTimeZone(appoinments, timeZone) {
        try {
            let userTimeZone;
            timeZone = timeZone ? timeZone : '+05:30';
            if (timeZone.includes('+')) {
               
                userTimeZone = timeZone.split('+')[1];
                for(let x of appoinments){
                    x.appointment_date = moment(x.appointment_date).add(x.startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
                    x.appointmentDate = moment(x.appointmentDate).add(x.startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
                    x.startTime = moment(x.startTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
                    x.endTime = moment(x.endTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
                    x.appointment_date = moment(new Date(x.appointment_date)).utcOffset(timeZone).format("YYYY-MM-DDTHH:mm:ss.SSSS");
                    x.appointmentDate = moment(new Date(x.appointmentDate)).utcOffset(timeZone).format("YYYY-MM-DDTHH:mm:ss.SSSS");
                }
                return appoinments;
            } else {
                
                userTimeZone = timeZone.split('-')[1];
                for(let x of appoinments){
                    x.appointment_date = moment(x.appointment_date).add(x.startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
                    x.appointmentDate = moment(x.appointmentDate).add(x.startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
                    x.startTime = moment(x.startTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
                    x.endTime = moment(x.endTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
                    x.appointment_date = moment(new Date(x.appointment_date)).utcOffset(timeZone).format("YYYY-MM-DDTHH:mm:ss.SSSS");
                    x.appointmentDate = moment(new Date(x.appointmentDate)).utcOffset(timeZone).format("YYYY-MM-DDTHH:mm:ss.SSSS");
                }
                return appoinments;
            }  
        }  catch(err)  {
            console.log("Error in convertAppointmentsUtctoUserTimeZone function: ", err);
            return appoinments;
        }
            
    }

    async convertMyAppUtcToUser(appoinmentDto, timeZone) { 
        try {
            let userTimeZone;
            timeZone = timeZone ? timeZone : '+05:30';
            if (timeZone.includes('+')) {
               
                userTimeZone = timeZone.split('+')[1];
                appoinmentDto.appointmentDate = moment(appoinmentDto.appointmentDate).add(appoinmentDto.startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
                appoinmentDto.startTime = moment(appoinmentDto.startTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
                appoinmentDto.endTime = moment(appoinmentDto.endTime, 'HH:mm:ss').add(moment.duration(userTimeZone)).format("HH:mm:ss");
                appoinmentDto.appointmentDate = moment(new Date(appoinmentDto.appointmentDate)).utcOffset(timeZone).format("YYYY-MM-DD");
                appoinmentDto.appointmentDate = new Date(appoinmentDto.appointmentDate);
                
                return appoinmentDto;
            } else {
                
                userTimeZone = timeZone.split('-')[1];
                appoinmentDto.appointmentDate = moment(appoinmentDto.appointmentDate).add(appoinmentDto.startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
                appoinmentDto.startTime = moment(appoinmentDto.startTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
                appoinmentDto.endTime = moment(appoinmentDto.endTime, 'HH:mm:ss').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
                appoinmentDto.appointmentDate = new Date(moment(new Date(appoinmentDto.appointmentDate)).utcOffset(timeZone).format("YYYY-MM-DDTHH:mm:ss.SSSS"));
                
                return appoinmentDto;
            }
        }   catch(err) {
                console.log("Error in convertMyAppUtcToUser function : ", err);
                return appoinmentDto;
        }    
    }

    async patientUpcomingAppointmentsForDoctor(user: any): Promise<any> {
        const doc = await this.doctorDetails(user.patientDto.doctorKey);
        const d: Date = new Date();
        let app =[];
        let res=[];
        var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
        //var date = moment().format('YYYY-MM-DD');
        if (user.patientDto.paginationNumber) {
            let offset = (user.paginationNumber) * (10);
            app = await this.appointmentRepository.query(queries.getUpcomingAppointmentsForPatient, [user.patientDto.patientId, date, offset, doc.doctorId, 'notCompleted', 'paused']);
        } else {
            app = await this.appointmentRepository.query(queries.getAppDoctorList, [doc.doctorId, user.patientDto.patientId, date, 'notCompleted', 'paused'])
        }
        app = await this.convertAppointmentsUtctoUserTimeZone(app, user.timeZone);
        for(let x of app){
            let time = null;
            let preHours = 0;
            let preMins = 0;
            if(x.is_preconsultation_allowed){
                if(x.pre_consultation_hours){
                    preHours = x.pre_consultation_hours;
                }
                if(x.pre_consultation_mins){
                    preMins = x.pre_consultation_mins;
                }
                time = preHours*60 + preMins;
            }
            let result ={
                appointmentId:x.appointmentId,
                appointmentDate:x.appointmentDate,
                isPreconsultationAllowed:x.is_preconsultation_allowed,
                preConsultationTime:time,
                doctorId:x.doctorId,
                doctorFirstName:x.doctorFirstName,
                doctorLastName:x.doctorLastName,
                patientId:x.patientId,
                startTime:x.startTime,
                endTime:x.endTime,
                hospitalName:x.hospitalName
            }
            res.push(result);
        }
        return res;
    }

    async adminPatientUpcomingAppointmentsForDoctor(user: any): Promise<any> {
        const accountKey=user.patientDto.accountKey;
        const d: Date = new Date();
        let app =[];
        let res=[];
        var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
        if (user.patientDto.paginationNumber) {
            let offset = (user.paginationNumber) * (10);
            app = await this.appointmentRepository.query(queries.getUpcomingAppointmentsForPatientAdmin, [user.patientDto.patientId, date, offset, accountKey, 'notCompleted', 'paused']);
        } else {
            app = await this.appointmentRepository.query(queries.getAppDoctorListForAdmin, [accountKey, user.patientDto.patientId, date, 'notCompleted', 'paused'])
        }
        app = await this.convertAppointmentsUtctoUserTimeZone(app, user.timeZone);
        for(let x of app){
            let time = null;
            let preHours = 0;
            let preMins = 0;
            if(x.is_preconsultation_allowed){
                if(x.pre_consultation_hours){
                    preHours = x.pre_consultation_hours;
                }
                if(x.pre_consultation_mins){
                    preMins = x.pre_consultation_mins;
                }
                time = preHours*60 + preMins;
            }
            let result ={
                appointmentId:x.appointmentId,
                appointmentDate:x.appointmentDate,
                isPreconsultationAllowed:x.is_preconsultation_allowed,
                preConsultationTime:time,
                doctorId:x.doctorId,
                doctorFirstName:x.doctorFirstName,
                doctorLastName:x.doctorLastName,
                patientId:x.patientId,
                startTime:x.startTime,
                endTime:x.endTime,
                hospitalName:x.hospitalName
            }
            res.push(result);
        }
        return res;
    }
    
    async patientPastAppointmentsForDoctor(user: any): Promise<any> {
        const doc = await this.doctorDetails(user.patientDto.doctorKey);
        const d: Date = new Date();
        var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
        //var date = moment().format('YYYY-MM-DD');
        if (user.patientDto.paginationNumber) {
            let offset = (user.paginationNumber) * (10);
            let app = await this.appointmentRepository.query(queries.getPastAppointmentsForPatient, [user.patientDto.patientId, date, offset, doc.doctorId, 'completed']);
            app = await this.convertAppointmentsUtctoUserTimeZone(app, user.timeZone);
            return app;
        } else {
            let app = await this.appointmentRepository.query(queries.getPastAppDoctorList, [doc.doctorId, user.patientDto.patientId, date, 'completed'])
            app = await this.convertAppointmentsUtctoUserTimeZone(app, user.timeZone);
            return app;
        }
    }

    async adminPatientPastAppointmentsForDoctor(user: any): Promise<any> {
        const accountKey=user.patientDto.accountKey;
        const d: Date = new Date();
        var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
        if (user.patientDto.paginationNumber) {
            let offset = (user.paginationNumber) * (10);
            let app = await this.appointmentRepository.query(queries.getPastAppointmentsForPatientAdmin, [user.patientDto.patientId, date, offset, accountKey, 'completed']);
            app = await this.convertAppointmentsUtctoUserTimeZone(app, user.timeZone);
            return app;
        } else {
            let app = await this.appointmentRepository.query(queries.getPastAppDoctorListForAdmin, [accountKey, user.patientDto.patientId, date, 'completed'])
            app = await this.convertAppointmentsUtctoUserTimeZone(app, user.timeZone);
            return app;
        }
    }

    async updatePatOnline(patientId): Promise<any> {
        var condition: any = {
            patientId: patientId
        }
        let dto = {
            liveStatus: 'online'
        }
        var values: any = dto;
        return await this.patientDetailsRepository.update(condition, values);
    }

    async updatePatOffline(patientId): Promise<any> {
        var condition: any = {
            patientId: patientId
        }
        let dto = {
            liveStatus: 'offline'
        }
        var values: any = dto;
        return await this.patientDetailsRepository.update(condition, values);
    }

    async updatePatLastActive(patientId): Promise<any> {
        //let date = moment().format();
        let date = new Date();
        var condition: any = {
            patientId: patientId
        }
        let dto = {
            lastActive: date
        }
        var values: any = dto;
        return await this.patientDetailsRepository.update(condition, values);
    }

    async updateDocOnline(doctorKey): Promise<any> {
        var condition: any = {
            doctorKey: doctorKey
        }
        let dto = {
            liveStatus: 'online'
        }
        var values: any = dto;
        console.log('updateDocOnline status ', {condition: condition, values: values});

        let docOnlineStatus = await this.doctorRepository.update(condition, values);
        console.log('updateDocOnline status ', docOnlineStatus);

        return docOnlineStatus;
    }

    async updateDocOffline(doctorKey): Promise<any> {
        var condition: any = {
            doctorKey: doctorKey
        }
        let dto = {
            liveStatus: 'offline'
        }
        var values: any = dto;
        return await this.doctorRepository.update(condition, values);
    }

    async updateDocLastActive(doctorKey): Promise<any> {
        //let date = moment().format();
        let date = new Date();
        var condition: any = {
            doctorKey: doctorKey
        }
        let dto = {
            lastActive: date
        }
        var values: any = dto;
        return await this.doctorRepository.update(condition, values);
    }


    async patientGeneralSearch(patientSearch: any, doctorId: any): Promise<any> {
        try {
            const app = await this.appointmentRepository.query(queries.getPatientDoctorApps, [doctorId, patientSearch]);
            return app
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }

    }

    async adminPatientGeneralSearch(patientSearch: any,accountKey: any): Promise<any> {
        try {
            const app = await this.appointmentRepository.query(queries.getPatientAdminApps, [accountKey, patientSearch]);      
            return app
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }

    }

    async updateDoctorAndPatientStatus(role: string, id: string, status: string, appointmentId: any) {

        if (role === CONSTANT_MSG.ROLES.DOCTOR) {
            const doc = await this.doctorRepository.findOne({doctorKey: id});
            if (doc) {
                doc.liveStatus = status === 'doctorRejectedSession' ? 'online' : status;
                // //doc.lastActive = moment().format();
                doc.lastActive = new Date();
                let sessionData:any = {
                    status: status
                };
                doc.videoCallDetails = !doc.videoCallDetails ? JSON.stringify(sessionData) : doc.videoCallDetails;
                let data:any = {};
                if(appointmentId && status === 'doctorRejectedSession') {
                    doc.videoCallDetails = null;
                    const app = await this.appointmentRepository.query(queries.getDocDetailsFromApp, [appointmentId]);                   
                    var attender={
                        attenderDetails:[],
                        isNewAttender:false
                    };                  
                    if(app && app[0].attender_mobile){                        
                        const attenderDetails = await this.patientDetailsRepository.query(queries.getAttenderDetails,[appointmentId]);
                        attender.attenderDetails = attenderDetails;
                        if(!attender.attenderDetails.length){
                            attender.isNewAttender = true;
                        }
                    }

                    await this.patientDetailsRepository.update(
                        { patientId: app[0].patient_id },
                        { videoCallDetails: null, lastActive: new Date(), liveStatus: 'online' },
                      );
                    data.patientId = app[0].patient_id;
                    data.doctorId = app[0].doctorId;
                    data.doctorKey = app[0].doctor_key;
                }
                doc.videoCallDetails = status === 'online' ? null : doc.videoCallDetails;
                // doc.videoCallDetails = null;
                await this.doctorRepository.save(doc);
                return {status: true, data: data, attender:attender};
            }
        } else if (role === CONSTANT_MSG.ROLES.PATIENT) {
            const patient = await this.patientDetailsRepository.findOne({patientId: Number(id)});
            let response = true;
            if (patient) {
                patient.liveStatus = status;
                //patient.lastActive = moment().format()
                if(status === 'online')
                patient.videoCallDetails = null;
                else{
                    if(appointmentId) {
                        const app = await this.appointmentRepository.query(queries.getDocDetailsFromApp, [appointmentId]);
                        if(app && app[0]) {
                            let docVideoDetails = app[0].video_call_details ? JSON.parse(app[0].video_call_details) : app[0].video_call_details;
                            if(!docVideoDetails || (docVideoDetails && docVideoDetails.patientId == patient.patientId)) {
                                const sessionData = {
                                    status: status,
                                    doctorKey: app ? app[0].doctor_key : '',
                                    doctorId: app ? app[0].doctorId : '',
                                    appointmentId: appointmentId
                                }
                                patient.videoCallDetails = JSON.stringify(sessionData);
                                response = !docVideoDetails ? response : true;
                            }
                        }
                    }
                }
                patient.lastActive = new Date();
                await this.patientDetailsRepository.save(patient);
            }
            return {status: response};

        }

    }

    async accountPatientList(accountKey: any): Promise<any> {
        const doctorId = await this.doctorRepository.find({accountKey: accountKey});
        let app = [];
        for (let m of doctorId) {
            const app1 = await this.appointmentRepository.query(queries.getAccountAppList, [m.doctorId]);
            app = app.concat(app1)
        }
        let ids = [];
        app.forEach(a => {
            let flag = false;
            ids.forEach(i => {
                if (i == a.patient_id)
                    flag = true;
            });
            if (flag == false) {
                ids.push(a.patient_id)
            }
        });
        let patientList = [];
        for (let x of ids) {
            const patient = await this.patientDetailsRepository.query(queries.getPatientDetails, [x]);
            patientList.push(patient[0]);
        }
        return patientList;
    }

    async tableDataView(accountDto: any): Promise<any> {
        let tab: string = accountDto.table
        const doctor = await this.accountDetailsRepository.query(queries.getTableData+tab,[]);
        return doctor;
    }
    
    async tableDataDelete(accountDto: any): Promise<any> {
        let pre = 'DELETE FROM "'+accountDto.table +'" WHERE "'+accountDto.column+'" = '+accountDto.id
        const doctor = await this.accountDetailsRepository.query(pre);
        return doctor;
    }

    async appointmentPresentOnDate(user:any): Promise<any> {
        // let currentTime = new Date();// add user time zone into current time zone\
        let currentDateAndTime;
        let userTimeZone, cDt;
        if(user.timeZone.includes('+')){
            userTimeZone = user.timeZone.split('+')[1];
            cDt = moment(new Date()).utcOffset('-'+ userTimeZone).format("YYYY-MM-DD");
            currentDateAndTime = moment(new Date()).utcOffset('-'+ userTimeZone).format('YYYY-MM-DDTHH:mm:ss.SSSS');
            // currentTime = moment(new Date()).utcOffset(user.timeZone).format("YYYY-MM-DD");
        } else {
            userTimeZone = user.timeZone.split('-')[1];
            cDt = moment(new Date()).utcOffset('-'+ userTimeZone).format("YYYY-MM-DD");
            currentDateAndTime = moment(new Date()).utcOffset('-'+ userTimeZone).format('YYYY-MM-DDTHH:mm:ss.SSSS');
            // currentTime = moment(new Date()).utcOffset(user.timeZone).format("YYYY-MM-DD");
        }
        currentDateAndTime = new Date(currentDateAndTime);
        let currentDate = Helper.getDayMonthYearFromDate(currentDateAndTime);
        let appDate = new Date(user.appointmentDate);
        let appdt = Helper.getDayMonthYearFromDate(appDate);
        // cDt = new Date(cDt);
        var oneDayMinusFromcurrentTime = Helper.getDayMonthYearFromDate(currentDateAndTime.setDate(currentDateAndTime.getDate()+1));
        let exist = [];
        if(/*appdt === currentDate ||*/ appdt === oneDayMinusFromcurrentTime) {
            const currentTimeInArray = moment(new Date()).format("HH:mm:ss").split(':');
            const currentTimeFormat = currentTimeInArray[0] + ':' + currentTimeInArray[1] + ':' + currentTimeInArray[2];
            exist = await this.appointmentRepository.query(queries.getTodayAndTomExistApp, [user.doctorId, user.patientId, user.appointmentDate, cDt]);
            if (exist.length) {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.APPOINT_ALREADY_PRESENT
                }
            }else{
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.NO_APPOINT_PRESENT
                }
            } 
        } else {
            console.log("sdkjhsdjfhsdf : ")
            // user.appointmentDate = moment(new Date()).format("YYYY-MM-DD");
            exist = await this.appointmentRepository.query(queries.getExistAppointment, [user.doctorId, user.patientId, user.appointmentDate]);
            if (exist.length) {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.APPOINT_ALREADY_PRESENT
                }
            }else{
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.NO_APPOINT_PRESENT
                }
            } 
        }
     }

     async doctorRegistration(doctorDto: DoctorDto): Promise<any> {
        const doctor = await this.doctorRepository.doctorRegistration(doctorDto);
        if(doctor){
            // add config details
            const config = await this.doctorConfigRepository.doctorConfigSetup(doctor, doctorDto)
            return doctor;
        } else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.DOC_REG_FAIL
            };
        }
        
    }

    async accountdetailsInsertion(accountDto: any): Promise<any> {
        const doctor = await this.accountDetailsRepository.accountdetailsInsertion(accountDto);
        return doctor;
    }

    async listOfHospitals(): Promise<any> {
        const hospitals = await this.accountDetailsRepository.find();
        return hospitals;
    }

    async concatHospitalAddress(street1, landmark, city, state, pincode) {
        var hospitaladdress = '';
        if(street1){
            hospitaladdress = hospitaladdress + ((landmark == '' && city == '' && state == '' && !pincode) ? street1 : street1 + ', ');
            }
            if(landmark){
                hospitaladdress = hospitaladdress + ((city == '' && state == '' && !pincode) ? landmark : landmark + ', ');
            }
            if(city){
                hospitaladdress = hospitaladdress + ((state == '' && !pincode) ? city : city + ', ');
            }
            if(state){
                hospitaladdress = hospitaladdress + ((!pincode) ? state : state + ', ');
            }
            if(pincode){
                hospitaladdress = hospitaladdress + pincode;
            }
            return hospitaladdress;
    }

    async prescriptionInsertion(user: any): Promise<any> {
        const details = await this.appointmentRepository.findOne({ id: user.prescriptionDto.appointmentId });
        const pat = await this.patientDetailsRepository.findOne({ patientId: details.patientId });
        const doc = await this.doctorRepository.findOne({ doctorId: details.doctorId });
        const hosp = await this.accountDetailsRepository.findOne({ accountKey: doc.accountKey });
        const hospitaladdress= await this.concatHospitalAddress(hosp.street1, hosp.landmark, hosp.city, hosp.state, hosp.pincode);
        let result = [];
        let cDt = moment(new Date()).format('YYYY-MM-DDTHH:mm:ss.SSSS');
        if (doc.doctorKey == user.doctor_key) {

            let prescriptionMedicineDetail = [];
            for (let i = 0; i < user.prescriptionDto.prescriptionList.length ; i++) {
                prescriptionMedicineDetail = [];
                // Add prescription
                const prescriptionDetails = {
                    currentDate: moment(cDt).add(user.timeZone).format("DD/MM/YYYY"), 
                    currentTime: moment(cDt).add(user.timeZone).format("hh:mm:ss A"),
                    appointmentId: details.id,
                    appointmentDate: details.appointmentDate,
                    hospitalLogo: hosp.hospitalPhoto,
                    hospitalName: hosp.hospitalName,
                    doctorName: "Dr."+" "+ doc.firstName + " " + doc.lastName,
                    doctorSignature: doc.signature,
                    patientName: pat.firstName + " " + pat.lastName,
                    doctorId:doc.doctorId,
                    remarks:user.prescriptionDto.remarks,
                    diagnosis:user.prescriptionDto.diagnosis,
                    patientAge:pat.age,
                    Gender:pat.gender,
                    patientGender:pat.honorific,
                    DoctorKey:doc.doctorKey,
                    hospitalAddress:hospitaladdress,
                    qualification:doc.qualification,
                    doctorRegistrationNumber:doc.registrationNumber,
                
                }
                const prescriptionDetail = await this.prescriptionRepository.prescriptionInsertion(prescriptionDetails);
                prescriptionMedicineDetail.push(prescriptionDetail.appointmentdetails);
                prescriptionMedicineDetail[0].medicineList = [];
                // Add medicine for prescription
                for (let j = 0; j< user.prescriptionDto.prescriptionList[i].medicineList.length; j++) {
                    const medicineData = {
                        prescriptionId: prescriptionDetail.appointmentdetails.id,
                        nameOfMedicine: user.prescriptionDto.prescriptionList[i].medicineList[j].nameOfMedicine,
                        frequencyOfEachDose: user.prescriptionDto.prescriptionList[i].medicineList[j].frequencyOfEachDose,
                        doseOfMedicine: user.prescriptionDto.prescriptionList[i].medicineList[j].doseOfMedicine,
                        typeOfMedicine: user.prescriptionDto.prescriptionList[i].medicineList[j].typeOfMedicine,
                        countOfDays: user.prescriptionDto.prescriptionList[i].medicineList[j].countOfDays,
                    }

                    const medicineDetail = await this.medicineRepository.medicineInsertion(medicineData);
                    prescriptionMedicineDetail[0].medicineList.push(medicineData);
                }

                // Generate pdf to store in cloud
                let generatePdfPrescription = await this.htmlToPdf(prescriptionMedicineDetail, 
                    prescriptionDetails.patientName,
                    prescriptionDetails.remarks,
                    prescriptionDetails.diagnosis,
                    prescriptionMedicineDetail[0].id,
                    prescriptionDetails.patientAge,
                    prescriptionDetails.currentDate,
                    prescriptionDetails.currentTime,
                    prescriptionDetails.Gender,
                    prescriptionDetails.DoctorKey,
                    prescriptionDetails.hospitalLogo,
                    prescriptionDetails.qualification, 
                    prescriptionDetails.doctorRegistrationNumber,
                    prescriptionDetails.hospitalAddress,
                    );

                if (i === user.prescriptionDto.prescriptionList.length - 1) {
                    result.push(prescriptionDetail);
                    return result;
                } else {
                    result.push(prescriptionDetail);
                }
                    
            }
            
            
        } else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }

    }

    // common functions below===============================================================

    async findTimeOverlaping(doctorScheduledDays, scheduleTimeInterval): Promise<any> {
        // validate with previous data
        let starTime = scheduleTimeInterval.startTime;
        let endTime = scheduleTimeInterval.endTime;
        let isOverLapping = false;
        // convert starttime into milliseconds
        let startTimeMilliSeconds = Helper.getTimeInMilliSeconds(starTime);
        let endTimeMilliSeconds = Helper.getTimeInMilliSeconds(endTime);
        // compare the startTime in any previous records, if start time or endTime comes between previous time interval
        doctorScheduledDays.forEach(v => {
            let vstartTimeMilliSeconds = Helper.getTimeInMilliSeconds(v.startTime);
            let vEndTimeMilliSeconds = Helper.getTimeInMilliSeconds(v.endTime);
            if (startTimeMilliSeconds >= vstartTimeMilliSeconds && startTimeMilliSeconds < vEndTimeMilliSeconds) {
                isOverLapping = true;
            } else if (endTimeMilliSeconds <= vEndTimeMilliSeconds && endTimeMilliSeconds > vstartTimeMilliSeconds) {
                isOverLapping = true;
            } else if (startTimeMilliSeconds === vstartTimeMilliSeconds && endTimeMilliSeconds === vEndTimeMilliSeconds) {
                isOverLapping = true;
            }
        })
        return isOverLapping;
    }

    async findTimeOverlapingForAppointments(doctorScheduledDays, scheduleTimeInterval): Promise<any> {
        // validate with previous data
        let starTime = scheduleTimeInterval.startTime;
        let endTime = scheduleTimeInterval.endTime;
        let isOverLapping = false;
        // convert starttime into milliseconds
        let startTimeMilliSeconds = Helper.getTimeInMilliSeconds(starTime);
        let endTimeMilliSeconds = Helper.getTimeInMilliSeconds(endTime);
        // compare the startTime in any previous records, if start time or endTime comes between previous time interval
        doctorScheduledDays.forEach(v => {
            let vstartTimeMilliSeconds = Helper.getTimeInMilliSeconds(v.startTime);
            let vEndTimeMilliSeconds = Helper.getTimeInMilliSeconds(v.endTime);
            if (startTimeMilliSeconds >= vstartTimeMilliSeconds && startTimeMilliSeconds < vEndTimeMilliSeconds) {
                isOverLapping = true;
            } else if (endTimeMilliSeconds <= vEndTimeMilliSeconds && endTimeMilliSeconds > vstartTimeMilliSeconds) {
                isOverLapping = true;
            } else if (startTimeMilliSeconds === vstartTimeMilliSeconds && endTimeMilliSeconds === vEndTimeMilliSeconds) {
                isOverLapping = true;
            }
            if (v.is_cancel == true) {
                isOverLapping = false;
            }
        })
        return isOverLapping;
    }


    async isPhoneExists(phone): Promise<any> {
        let isPhone = false;
        const number = await this.patientDetailsRepository.findOne({phone: phone});
        if (number) {
            isPhone = true;
        }
        return {isPhone: isPhone, patientDetails: number};
    }


    async isWorkScheduleAvailable(day, workScheduleObj): Promise<any> {
        return workScheduleObj[day] && workScheduleObj[day].length >= 1 ? true : false;
    }

    async sendAppCreatedEmail(req) {

        var email = req.email;
        var doctorFirstName = req.doctorFirstName;
        var doctorLastName = req.doctorLastName;
        var patientFirstName = req.patientFirstName;
        var patientLastName = req.patientLastName;
        var hospital = req.hospital;
        var startTime = req.startTime;
        var endTime = req.endTime;
        var role = req.role;
        var appointmentId = req.appointmentId;
        var appointmentDate = req.appointmentDate;

        const params: any = {};

        params.subject = 'Appointment Created';
        params.recipient = email;
        params.template = '  <div style="height: 7px; background-color: #535353;"></div><div style="background-color:#E8E8E8; margin:0px; padding:20px 20px 40px 20px; font-family:Open Sans, Helvetica, sans-serif; font-size:12px; color:#535353;"><div style="text-align:center; font-size:24px; font-weight:bold; color:#535353;">New Appointment Created</div><div style="text-align:center; font-size:18px; font-weight:bold; color:#535353; padding: inherit">One user created appointment through VIRUJH. Please find the appointment details Below</div></div>\
             <div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Created By</div><div style="display: inline-block;">: {role}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Id</div><div style="display: inline-block;">: {appointmentId}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Doctor Name</div><div style="display: inline-block;">: {doctorFirstName} {doctorLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Patient Name</div><div style="display: inline-block;">: {patientFirstName} {patientLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Date</div><div style="display: inline-block;">: {appointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Start time</div><div style="display: inline-block;">: {startTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment End time</div><div style="display: inline-block;">: {endTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Email</div><div style="display: inline-block;">: {email}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div  class="reset_titles" style="display: inline-block;">Hospital</div><div style="display: inline-block;">: {hospital}</div></div><br>Thank you</div></div>  ';        //sending Mail to user

        params.template = params.template.replace(/{doctorFirstName}/gi, doctorFirstName);
        params.template = params.template.replace(/{doctorLastName}/gi, doctorLastName);
        params.template = params.template.replace(/{patientFirstName}/gi, patientFirstName);
        params.template = params.template.replace(/{patientLastName}/gi, patientLastName);
        params.template = params.template.replace(/{email}/gi, email);
        params.template = params.template.replace(/{hospital}/gi, hospital);
        params.template = params.template.replace(/{startTime}/gi, startTime);
        params.template = params.template.replace(/{endTime}/gi, endTime);
        params.template = params.template.replace(/{role}/gi, role);
        params.template = params.template.replace(/{appointmentId}/gi, appointmentId);
        params.template = params.template.replace(/{appointmentDate}/gi, appointmentDate);
        try {
            const sendMail = await this.email.sendEmail(params);
            return {
                statusCode: HttpStatus.OK,
                message: CONSTANT_MSG.MAIL_OK
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }

    }

    async sendAppCancelledEmail(req) {

        var email = req.email;
        var doctorFirstName = req.doctorFirstName;
        var doctorLastName = req.doctorLastName;
        var patientFirstName = req.patientFirstName;
        var patientLastName = req.patientLastName;
        var hospital = req.hospital;
        var startTime = req.startTime;
        var endTime = req.endTime;
        var role = req.role;
        var appointmentId = req.appointmentId;
        var appointmentDate = req.appointmentDate;
        var cancelledOn = req.cancelledOn;

        const params: any = {};

        params.subject = 'Appointment Cancelled';
        params.recipient = email;
        params.template = '  <div style="height: 7px; background-color: #535353;"></div><div style="background-color:#E8E8E8; margin:0px; padding:20px 20px 40px 20px; font-family:Open Sans, Helvetica, sans-serif; font-size:12px; color:#535353;"><div style="text-align:center; font-size:24px; font-weight:bold; color:#535353;">Appointment Cancelled</div><div style="text-align:center; font-size:18px; font-weight:bold; color:#535353; padding: inherit">One user cancelled appointment through VIRUJH. Please find the appointment details Below</div></div>\
         <div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Cancelled By</div><div style="display: inline-block;">: {role}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Id</div><div style="display: inline-block;">: {appointmentId}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Doctor Name</div><div style="display: inline-block;">: {doctorFirstName} {doctorLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Patient Name</div><div style="display: inline-block;">: {patientFirstName} {patientLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Date</div><div style="display: inline-block;">: {appointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Start time</div><div style="display: inline-block;">: {startTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment End time</div><div style="display: inline-block;">: {endTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Email</div><div style="display: inline-block;">: {email}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Cancelled On</div><div style="display: inline-block;">: {cancelledOn}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div  class="reset_titles" style="display: inline-block;">Hospital</div><div style="display: inline-block;">: {hospital}</div></div><br>Thank you</div></div>  ';        //sending Mail to user

        params.template = params.template.replace(/{doctorFirstName}/gi, doctorFirstName);
        params.template = params.template.replace(/{doctorLastName}/gi, doctorLastName);
        params.template = params.template.replace(/{patientFirstName}/gi, patientFirstName);
        params.template = params.template.replace(/{patientLastName}/gi, patientLastName);
        params.template = params.template.replace(/{email}/gi, email);
        params.template = params.template.replace(/{hospital}/gi, hospital);
        params.template = params.template.replace(/{startTime}/gi, startTime);
        params.template = params.template.replace(/{endTime}/gi, endTime);
        params.template = params.template.replace(/{role}/gi, role);
        params.template = params.template.replace(/{appointmentId}/gi, appointmentId);
        params.template = params.template.replace(/{appointmentDate}/gi, appointmentDate);
        params.template = params.template.replace(/{cancelledOn}/gi, cancelledOn);

        try {
            const sendMail = await this.email.sendEmail(params);
            return {
                statusCode: HttpStatus.OK,
                message: CONSTANT_MSG.MAIL_OK
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }

    }

    async sendAppRescheduleEmail(req) {

        var email = req.email;
        var doctorFirstName = req.doctorFirstName;
        var doctorLastName = req.doctorLastName;
        var patientFirstName = req.patientFirstName;
        var patientLastName = req.patientLastName;
        var hospital = req.hospital;
        var startTime = req.startTime;
        var endTime = req.endTime;
        var role = req.role;
        var appointmentId = req.appointmentId;
        var appointmentDate = req.appointmentDate;
        var rescheduledAppointmentDate = req.rescheduledAppointmentDate;
        var rescheduledStartTime = req.rescheduledStartTime;
        var rescheduledEndTime = req.rescheduledEndTime;
        var rescheduledOn = req.rescheduledOn;

        const params: any = {};

        params.subject = 'Appointment Rescheduled';
        params.recipient = email;
        params.template = '  <div style="height: 7px; background-color: #535353;"></div><div style="background-color:#E8E8E8; margin:0px; padding:20px 20px 40px 20px; font-family:Open Sans, Helvetica, sans-serif; font-size:12px; color:#535353;"><div style="text-align:center; font-size:24px; font-weight:bold; color:#535353;">Appointment Rescheduled</div><div style="text-align:center; font-size:18px; font-weight:bold; color:#535353; padding: inherit">One user rescheduled appointment through VIRUJH. Please find the appointment details Below</div></div>\
         <div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Rescheduled By</div><div style="display: inline-block;">: {role}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Old Appointment Id</div><div style="display: inline-block;">: {appointmentId}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Doctor Name</div><div style="display: inline-block;">: {doctorFirstName} {doctorLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Patient Name</div><div style="display: inline-block;">: {patientFirstName} {patientLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Date</div><div style="display: inline-block;">: {appointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Start time</div><div style="display: inline-block;">: {startTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment End time</div><div style="display: inline-block;">: {endTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Rescheduled Appointment Date</div><div style="display: inline-block;">: {rescheduledAppointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Rescheduled Appointment Start time</div><div style="display: inline-block;">: {rescheduledStartTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Resheduled Appointment End time</div><div style="display: inline-block;">: {rescheduledEndTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Rescheduled On</div><div style="display: inline-block;">: {rescheduledOn}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div  class="reset_titles" style="display: inline-block;">Hospital</div><div style="display: inline-block;">: {hospital}</div></div><br>Thank you</div></div>  ';        //sending Mail to user

        params.template = params.template.replace(/{doctorFirstName}/gi, doctorFirstName);
        params.template = params.template.replace(/{doctorLastName}/gi, doctorLastName);
        params.template = params.template.replace(/{patientFirstName}/gi, patientFirstName);
        params.template = params.template.replace(/{patientLastName}/gi, patientLastName);
        params.template = params.template.replace(/{rescheduledAppointmentDate}/gi, rescheduledAppointmentDate);
        params.template = params.template.replace(/{rescheduledStartTime}/gi, rescheduledStartTime);
        params.template = params.template.replace(/{rescheduledEndTime}/gi, rescheduledEndTime);
        params.template = params.template.replace(/{hospital}/gi, hospital);
        params.template = params.template.replace(/{startTime}/gi, startTime);
        params.template = params.template.replace(/{endTime}/gi, endTime);
        params.template = params.template.replace(/{role}/gi, role);
        params.template = params.template.replace(/{appointmentId}/gi, appointmentId);
        params.template = params.template.replace(/{appointmentDate}/gi, appointmentDate);
        params.template = params.template.replace(/{rescheduledOn}/gi, rescheduledOn);

        try {
            const sendMail = await this.email.sendEmail(params);
            return {
                statusCode: HttpStatus.OK,
                message: CONSTANT_MSG.MAIL_OK
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }

    }

    async sendSmsForCreatingAppointment(req) {
        var number = req.number;
        const params: any = {}
        params.message = 'Appointment created\nCreated by {role}';
        params.sender = 'Virujh';
        params.number = number;
        try {
            const sendMail = await this.sms.sendSms(params);
            return {
                statusCode: HttpStatus.OK,
                message: CONSTANT_MSG.SMS_OK
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async htmlToPdf(prescription, patientName,remarks, diagnosis, prescriptionId,patientAge,currentDate, currentTime,Gender,
        DoctorKey, hospitalLogo,qualification,doctorRegistrationNumber,hospitalAddress) {
        const params: any = {};
        const AWS = require('aws-sdk');
        let htmlPdf : any = '';
        const ID = 'AKIAISEHN3PDMNBWK2UA';
        const SECRET = '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';
        const BUCKET_NAME = 'virujh-cloud';
         
        // s3 bucket creation
         const s3 = new AWS.S3({
            accessKeyId: ID,
            secretAccessKey: SECRET
        });


        let tabledata = '';

        params.htmlTemplate = `<!DOCTYPE html>
        <html lang="en">
        
        <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
        </head>
        <style>
            .frm-tp{
            margin-top: 20px;
        }
        
        .col-lg-1, .col-lg-10, .col-lg-11, .col-lg-12, .col-lg-2, .col-lg-3, .col-lg-4, .col-lg-5, .col-lg-6, .col-lg-7, .col-lg-8, .col-lg-9, .col-md-1, .col-md-10, .col-md-11, .col-md-12, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6, .col-md-7, .col-md-8, .col-md-9, .col-sm-1, .col-sm-10, .col-sm-11, .col-sm-12, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6, .col-sm-7, .col-sm-8, .col-sm-9, .col-xs-1, .col-xs-10, .col-xs-11, .col-xs-12, .col-xs-2, .col-xs-3, .col-xs-4, .col-xs-5, .col-xs-6, .col-xs-7, .col-xs-8, .col-xs-9 {
            position: relative;
            min-height: 1px;
            padding-right: 7px;
            padding-left: 7px;
        }
        
        .doc_details{
           margin-top: 15px;
           color:#0bb5ff;
           font-weight: 600;
           margin-bottom: 15px; 
           font-family: serif;
        }
        
        .presc_cus{
            margin-top: 5px;
            background: #f3fbff;
            padding: 0px;
            border-top: 1px solid #0BB5FF;
            border-bottom: 1px solid #0BB5FF;
            margin-bottom: 5px;
        }
        .head-style{
            margin-top: 10px;
            background: #f3fbff;
            padding: 25px;
            color: #5F626E;
            border-top: 1px solid #0BB5FF;
            border-bottom: 1px solid #0BB5FF;
            margin: auto;
        }
        
        .doc_sgn{
            text-align: right; 
            color: #0BB5FF;
            font-weight: 300;
            font-size: 9px;
            font-family: serif;
            
        }
        .table_cus h4{
            color: #5F626E;
            font-weight: 600;
        }
        .head_title{
            font-weight: 600;
            font-size: 16px;
            color: #5F626E;
            font-family: serif;
        }
        .mid_sec{
            left: 45px;
        }
        .mid_sec2{
            left: 35px;
        }
        
        @media (min-width:980px){
        
            .txt-style{
                margin: 25px 87px;
                font-size: 9px;
                text-align: justify;
            }      
        .vlogo{
            position: relative;
            top: -30px;
        }
        .frm-date{
            position: relative;
            left: 70px;
            font-family: serif;
        }
        .frm-grd{
            display: grid;
            grid-template-columns: 18% 82%;
            font-size: 9px;
            font-weight: 400;
            line-height: 1.4em;
            font-family: serif;
        }
        .frm-grd2{
            display: grid;
            grid-template-columns: 20% 80%;
            font-size: 9px;
            font-weight: 400;
            line-height: 1.4em;
            font-family: serif;
        }
        
        .def_txt{
            color: #9C9C9C;
            font-size: 9px;
        }
        .b_txt{
            color: #5F626E;
            font-size: 9px;
        }
        .pt_table{
            margin: 5px 5px !important;
        }
        .vir_lg{
            position: absolute;
            left: 35%;
            bottom: -30%;
        }
        }
        
        .b_line{
            border-bottom: 1px solid #E0E0E0;
        }
        @media (min-width: 992px){
            .col-md-4{
                float: left;
            }}
        @media (min-width: 992px){
        .col-md-4 {
            width: 33.33333333%;
        }}
        .row {
            margin-right: -5px;
            margin-left: -5px;
        }
        @media (min-width: 1200px){
        .container {
            width: 1170px;
        }}
        @media (min-width: 992px){
        .container {
            width: 970px;
        }}
        @media (min-width: 768px){
        .container {
            width: 750px;
        }}
        .container {
            padding-right: 15px;
            padding-left: 15px;
            margin-right: auto;
            margin-left: auto;
        }
        
        @media (min-width: 1200px){
        .container {
            width: 1170px;
        }}
        
        .row:before {
            display: table;
            content: " ";
        }
        
        .row:after {
            clear: both;
        }
        
        .row:after {
            display: table;
            content: " ";
        }
        
        * {
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
        }
        
        .container:before{
            display: table;
            content: " ";
        }
        .h4, .h5, .h6, h4, h5, h6 {
            margin-top: 10px;
            margin-bottom: 10px;
        }
        
        .h1, .h2, .h3, .h4, .h5, .h6, h1, h2, h3, h4, h5, h6 {
            font-family: inherit;
            font-weight: 500;
            line-height: 1.1;
            color: inherit;
        }
        
        p {
            margin: 0 0 10px;
        }
        html {
            font-size: 6px;
            -webkit-tap-highlight-color: rgba(0,0,0,0);
        }
        html {
            font-family: serif;
            -ms-text-size-adjust: 100%;
            -webkit-text-size-adjust: 100%;
        }
        .h4, h4 {
            font-size: 10px;
        }
        body {
            font-family: serif;
            font-size: 8px;
            line-height: 1.42857143;
            color: #9c9c9c;
            background-color: #fff;
        }
        @media (max-width: 1102px){
            .col-md-4{
                float: left;
                width: 33.33333333%;
            }
            .frm-grd{
            display: grid;
            grid-template-columns: 30% 70%;
            font-size: 9px;
            font-weight: 400;
            line-height: 1.4em;
            font-family: serif;
        }
        .frm-grd2{
            display: grid;
            grid-template-columns: 35% 65%;
            font-size: 9px;
            font-weight: 400;
            line-height: 1.4em;
            font-family: serif;
        }
        
            
            }
        @media(max-width:980px){
            .vir_lg{
            position: absolute;
            left: 25%;
            bottom: -25%;
        }}
        
        
        
        
        
        </style>
        <body>
                <div class="container frm-tp">
                    <div class="row">
                        <div class="col-md-4"> <img src="virujh-svg.svg" width="120" class="vlogo"> </div>
                        <div class="col-md-4">
                            <h4 class="head_title">Prescription</h4> </div>
                        <div class="col-md-4 frm-date">
                            <br>
                            <p class="def_txt">Date : {currentDate}
                                <br> Time : {currentTime} </p>
                        </div>
                    </div>
                    <h4 class="doc_details">Doctor’s Details </h4>
                    <div class="row">
                        <div class="col-md-4 frm-grd">
                            <div><b class="b_txt">Name :</b></div>
                            <div class="def_txt">
                                <p>{doctor_name}
                                    <br> {hospitalAddress} </p>
                            </div>
                        </div>
                        <div class="col-md-4 mid_sec">
                            <p class="def_txt"> <b class="b_txt">Code : </b> {DoctorKey} </p>
                        </div>
                        <div class="col-md-4 frm-grd2">
                            <div><b class="b_txt">Address: </b></div>
                            <p class="def_txt"> {hospitalAddress} </p>
                        </div>
                    </div>
                
                    <h4 class="doc_details">Patient's Details </h4>
                    <div class="row">
                        <div class="col-md-4 frm-grd">
                            <div><b class="b_txt">Name :</b></div>
                            <div class="d_name def_txt">
                            <p> {patient_name} </p>
                            </div>
                        </div>
                        <div class="col-md-4 mid_sec">
                            <p class="def_txt"> <b class="b_txt" style="margin-left:10px">  Age : </b> {patientAge} </p>
                        </div>
                        <div class="col-md-4">
                            <p  class="def_txt"> <b class="b_txt">Gender : </b>{Gender} </p>
                        </div>
                    </div>
                    <div style="padding:10px;"> </div>
        
                    <div class="row presc_cus">
                        <div class="pt_table">
                        <div class="col-md-4 table_cus"><h4>Description</h4></div>
                        <div class="col-md-4 table_cus"><h4>Quantity</h4></div>
                        <div class="col-md-4 table_cus"><h4>Comments</h4></div>
                      </div>
                    </div>
                    
                    {tabledata}
                   
                    <div class="row " style="margin-top: 7px;">
                        <div class="presc_cus">
                        <div class="pt_table table_cus"><h4 style="text-align:center">Diagnosis</h4></div>
                        </div>
                        <p class="txt-style def_txt"> {diagnosis} </p>
                        <div class="b_line"></div>
                    </div>
                  
                    <div class="row">
                        <div class="presc_cus">
                        <div class="pt_table table_cus"><h4 style="text-align:center">Remarks</h4></div>
                        </div>
                        <p class="txt-style def_txt"> {remarks}</p>
                        <div class="b_line"></div>	
                    </div>
                    <div class="vir_lg">
                        <img src="virujh-bac.svg" width="380">
                    </div>
					<div style="padding: 10px;">
                        <div class="row">
                            <div class="col-md-4"></div>
                            <div class="col-md-4"></div>
                            <div class="col-md-4">
                                <p class = "doc_sgn"> <img style="width: 130px;" src="{doctor_signature}"> <br> Doctor Signature </p>
                            </div>
                          </div>
                    </div>
                </div>
        </body>
        
        </html>`;

        prescription[0].medicineList.forEach(element => {

            tabledata += `<div class="row pt_table" style="margin: 5px 0px;">
                <div class="col-md-4 def_txt " > ` + (element.nameOfMedicine ? element.nameOfMedicine : '-') + `</div>
                <div class="col-md-4 mid_sec2 def_txt">`  + (element.countOfDays ? element.countOfDays : '-') + `</div>
                <div class="col-md-4 def_txt"> ` + (element.doseOfMedicine ? element.doseOfMedicine : '-') +  ` </div>
            </div>`;
        });


        // currentDate= new Date();

        params.htmlTemplate = params.htmlTemplate.replace('{doctor_name}', prescription[0].doctorName);
        params.htmlTemplate = params.htmlTemplate.replace('{patient_name}', prescription[0].patientName);
        params.htmlTemplate = params.htmlTemplate.replace('{doctor_signature}', prescription[0].doctorSignature);
        params.htmlTemplate = params.htmlTemplate.replace('{tabledata}', tabledata);
        params.htmlTemplate = params.htmlTemplate.replace('{remarks}', remarks);
        params.htmlTemplate = params.htmlTemplate.replace('{diagnosis}', diagnosis);
        params.htmlTemplate = params.htmlTemplate.replace('{patientAge}', patientAge);
        params.htmlTemplate = params.htmlTemplate.replace('{currentDate}', currentDate);
        params.htmlTemplate = params.htmlTemplate.replace('{currentTime}', currentTime);
        params.htmlTemplate = params.htmlTemplate.replace('{Gender}', Gender ? Gender : '');
        params.htmlTemplate = params.htmlTemplate.replace('{DoctorKey}', DoctorKey);
        params.htmlTemplate = params.htmlTemplate.replace('{hospitalLogo}', hospitalLogo);
        params.htmlTemplate = params.htmlTemplate.replace('{qualification}',qualification );
        params.htmlTemplate = params.htmlTemplate.replace('{doctorRegistrationNumber}',doctorRegistrationNumber );
        params.htmlTemplate = params.htmlTemplate.replace('{hospitalAddress}', hospitalAddress);
        params.htmlTemplate = params.htmlTemplate.replace('{hospitalAddress}', hospitalAddress);

        var options = { 
            format: 'Letter',
            orientation: "portrait", // portrait or landscape
                "border": {
                  "top": "0",// default is 0, units: mm, cm, in, px
                  "right": "0",
                  "left": "0"
                },
                paginationOffset: 1,       // Override the initial pagination number
                footer: {
                  "height": "0",
                },
                type: "pdf",
                quality: "75",
         };

         const attachment = new Promise((resolve, reject) => {
            pdf.create(params.htmlTemplate, options).toFile('./temp/prescription.pdf', (err, res) =>{
                if (err) {
                    console.log("error occured while creating pdf:"+err);
                    return reject(err)
                }
                console.log("pdf created successfull response:"+JSON.stringify(res));
                htmlPdf = res.filename;
                const fileContent = fs.readFileSync(htmlPdf);
                
                // Setting up S3 upload parameters
                const parames = {
                    ACL: 'public-read',
                    Bucket: BUCKET_NAME,
                    Key: `virujh/${patientName}/prescription/prescription-${prescriptionId}.pdf`, // File name you want to save as in S3
                    Body: fileContent,
                };
            
                // Uploading files to the bucket

                s3.upload(parames, async (err, data) => {
                    if (err) {
                        console.log('Unable to upload prescription ' + prescriptionId + ' ', err);
                        reject(err)
                    } else {
                        try {
                            // store prescription URL into database
                            const updateDB = await this.prescriptionRepository.update({
                                id: prescription[0].id,
                            },  {prescriptionUrl: data.Location});
                            resolve(updateDB)
                        } catch (err) {
                            reject(err)
                        }
                    }
                });   
            });
        })
        
        return attachment
    }
    

    //patientFileUploading

    async patientFileUpload(reports: any): Promise<any> {

        const AWS = require('aws-sdk');
        const ID = 'AKIAISEHN3PDMNBWK2UA';
        const SECRET = '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';
        const BUCKET_NAME = 'virujh-cloud';
        const date = new Date();
        const reportFileExist = await this.patientReportRepository.query(queries.getPatientReportDetails, [reports.data.patientId,reports.file.originalname,reports.file.mimetype]);

        if(reportFileExist && !reportFileExist.length){
            
            // s3 bucket creation
            const s3 = new AWS.S3({
                accessKeyId: ID,
                secretAccessKey: SECRET
    
            }); 

            if (reports.file.mimetype === "application/pdf") {
                var base64data = new Buffer(reports.file.buffer, 'base64');
            }
            else {
                var base64data = new Buffer(reports.file.buffer, 'binary');
            }   

            const parames = {
                ACL: 'public-read',
                Bucket: BUCKET_NAME,
                Key: `virujh/report/` + reports.file.originalname,// File name you want to save as in S3
                Body: base64data
            };

            // Uploading files to the bucket
            const result = new Promise((resolve, reject) => {
                s3.upload(parames, async (err, data) => {
                    if (err) {
                        console.log("Error in patientFileUpload function: ", err);
                        reject({
                            statusCode: HttpStatus.NO_CONTENT,
                            message: "Image Uploaded Failed",
                        })
                    } else {
                        // store prescription URL into database
                        await this.patientReportRepository.patientReportInsertion({
                            patientId: reports.data.patientId,
                            appointmentId: reports.data.appointmentId ? reports.data.appointmentId : null,
                            fileName: reports.file.originalname,
                            fileType: reports.file.mimetype,
                            reportURL: data.Location,
                            reportDate: date,
                            comments: reports.data.comments
                        })
                        resolve({
                            statusCode: HttpStatus.OK,
                            message: "Image Uploaded Successfully",
                            data: data.Location,
                        })
                    }
                })
            })
            return result;
        } else{
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: 'This report already exists',
            }
        }
    }
    
    async deletereport(id: any): Promise<any> {

        var account = await this.patientReportRepository.find({ id: id.id })
        if (account.length) {
            const app = await this.patientReportRepository.updateReportInsertion(id)
            return app
        }
        else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.NOREPORT,
            }
        }

    }

    
    //report Data
    async report(data: any): Promise<any> {
        const patientId = data.patientId;
        const offset = data.paginationStart;
        const endset = data.paginationLimit;
        const searchText = data.searchText?.toLowerCase();
        const appointmentId = data.appointmentId;
        const active = true;
        let response = {};
        let app = [], reportList = [];

        if (searchText) {
            if (appointmentId) {
                app = await this.patientReportRepository.query(queries.getSearchReportByAppointmentId, [appointmentId, offset, endset, '%' + searchText + '%', active]);
                reportList = await this.patientReportRepository.query(queries.getReportWithoutLimitAppointmentIdSearch, [appointmentId, '%' + searchText + '%', active]);

            } else {
                app = await this.patientReportRepository.query(queries.getSearchReport, [patientId, offset, endset, '%' + searchText + '%', active]);
                reportList = await this.patientReportRepository.query(queries.getReportWithoutLimitSearch, [patientId, '%' + searchText + '%', active]);
            }

        } else {
            if (appointmentId) {
                app = await this.patientReportRepository.query(queries.getReportByAppointmentId, [appointmentId, offset, endset, active]);
                reportList = await this.patientReportRepository.query(queries.getReportWithAppointmentId, [appointmentId, active]);

            } else {
                reportList = await this.patientReportRepository.query(queries.getReportWithoutLimit, [patientId, active]);
                app = await this.patientReportRepository.query(queries.getReport, [patientId, offset, endset, active]);
            }


        }
        response['totalCount'] = reportList.length;
        response['list'] = app;
        return response;


    }



    // update consultation status
    async consultationStatusUpdate(appointmentObject: any) {

        if (appointmentObject.appointmentId) {
            const appointmentDetails = await this.appointmentRepository.findOne({ id: appointmentObject.appointmentId });

            if (appointmentDetails) {
                // Update consultation status
                var condition = {
                    id: appointmentObject.appointmentId
                }
                var values: any = {
                    hasConsultation: true,
                }

                const consultationStatus = await this.appointmentRepository.update(condition, values);

                console.log('consultationStatus', consultationStatus)
                if (consultationStatus.affected) {
                    return {
                        statusCode: HttpStatus.OK,
                        message: CONSTANT_MSG.SUCCESS_UPDATE_APPO,
                        data: appointmentDetails
                    }
                } else {
                    return {
                        statusCode: HttpStatus.BAD_REQUEST,
                        message: CONSTANT_MSG.FAILED_UPDATE_APPO
                    }
                }
            } else {
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message: CONSTANT_MSG.NO_APPOINTMENT
                }
            }


        } else {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: CONSTANT_MSG.NO_APPOINTMENT
            }
        }


    }

    async addDoctorSignature(reports: any): Promise<any> {
        try {
            const AWS = require('aws-sdk');
            const ID = 'AKIAISEHN3PDMNBWK2UA';
            const SECRET = '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';
            const BUCKET_NAME = 'virujh-cloud';

            // s3 bucket creation
            const s3 = new AWS.S3({
                accessKeyId: ID,
                secretAccessKey: SECRET

            });


            if (reports.file.mimetype === "application/pdf") {
                var base64data = Buffer.from(reports.file.buffer, 'base64');
            }
            else {
                var base64data = Buffer.from(reports.file.buffer, 'binary');
            }

            const parames = {
                ACL: 'public-read',
                Bucket: BUCKET_NAME,
                Key: `virujh/signature/` + reports.file.originalname,// File name you want to save as in S3
                Body: base64data
            };

            // Uploading files to the bucket
            const result = new Promise((resolve, reject) => {
                let queryRes;
                s3.upload(parames, async (err, data) => {
                    if (err) {
                        reject({
                            statusCode: HttpStatus.NO_CONTENT,
                            message: "Image Uploaded Failed"
                        });
                    } else {
                        queryRes = await this.doctorRepository.query(queries.updateSignature, [reports.data.doctorId, data.Location])
                        resolve({
                            statusCode: HttpStatus.OK,
                            message: "Image Uploaded Successfully",
                            data: data.Location,
                            // url: path
                        })
                    }
                });
            });
            return result;
        } catch (err) {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: err.message,
                error: err
            };
        }

    }

    //upload files
    async uploadFile(files: any) {
        try {
            const AWS = require('aws-sdk');
            let htmlPdf: any = '';
            const ID = 'AKIAISEHN3PDMNBWK2UA';
            const SECRET = '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';
            const BUCKET_NAME = 'virujh-cloud';
            var profileURL = "";
            // s3 bucket creation
            const s3 = new AWS.S3({
                accessKeyId: ID,
                secretAccessKey: SECRET

            });

            if (files.file.mimetype === "application/pdf") {
                var base64data = new Buffer(files.file.buffer, 'base64');
            }
            else {
                var base64data = new Buffer(files.file.buffer, 'binary');
            }

            const parames = {
                ACL: 'public-read',
                Bucket: BUCKET_NAME,
                Key: `virujh/files/` + files.file.originalname,// File name you want to save as in S3
                Body: base64data
            };
            var location;


            const result = new Promise((resolve, reject) => {
                s3.upload(parames, async (err, data) => {
                    if (err) {
                        reject({
                            statusCode: HttpStatus.NO_CONTENT,
                            message: "Image Uploaded Failed"
                        });
                    } else {
                        resolve({
                            statusCode: HttpStatus.OK,
                            message: "Image Uploaded Successfully",
                            data: data.Location,
                            // url: path
                        })
                    }
                });
            });
            return result
        } catch (err) {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: err.message,
                error: err
            };
        }
    }

    async getDoctorDetails(doctorKey: any) {
        const doctor = await this.doctorRepository.findOne({ doctorKey: doctorKey });
        return doctor;
    }

    async getDoctorDetailsByEmail(email: any) {
        const doctor = await this.doctorRepository.findOne({ email: email });
        return doctor;
    }

    async getHospitalDetails(accountKey: any) {
        const hospital = await this.accountDetailsRepository.findOne({ accountKey: accountKey });
        return hospital;
    }

    //Getting patient report in patient detail page
    async patientDetailLabReport(patientId: any): Promise<any> {
        try {
            const patientReport = await this.patientDetailsRepository.query(queries.getPatientDetailLabReport, [patientId]);
            let patientDetailReport = patientReport;
            if (patientDetailReport.length) {
                return {
                    statusCode: HttpStatus.OK,
                    message: 'Patient Detail Report List fetched successfully',
                    data: patientDetailReport,
                }
            }
            else {
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message: 'No record found'
                }
            }
        } catch (err) {
            console.log(err);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    //Getting appointment list report
    async appointmentListReport(user: any): Promise<any> {
        const offset = user.paginationStart;
        const endset = user.paginationLimit;
        const searchText = user.searchText;
        const from = user.fromDate;
        const to = user.toDate;
        let response = {};
        let app = [], reportList = [];

        let query = queries.getDoctorReportField + queries.getDoctorReportFromField + queries.getAppointmentListReportJoinField;

        query += user.user.doctor_key ? queries.getDoctorReportWhereForDoctor : queries.getDoctorReportWhereForAdmin;
        let whereParam = user.user.doctor_key ? user.user.doctor_key : user.user.account_key;

        if (searchText && to === undefined) {
            console.log("query 000000000000 >>> ", query + queries.getAppointmentListReportWithSearch)
            app = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithSearch, [whereParam, offset, endset, '%' + searchText + '%', from]);
            reportList = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithoutLimitSearch, [whereParam, '%' + searchText + '%', from]);

        }
        else if (to) {
            if (searchText) {
                console.log("query 111111111111111 >>> ", query + queries.getAppointmentListReportWithFilterSearch)
                app = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithFilterSearch, [whereParam, offset, endset, '%' + searchText + '%', from, to]);
                reportList = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithoutLimitFilterSearch, [whereParam, '%' + searchText + '%', from, to]);
            }
            else {
                console.log("query 2222222 >>> ", query + queries.getAppointmentListReportWithFilter)
                app = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithFilter, [whereParam, offset, endset, from, to]);
                reportList = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithoutLimitFilter, [whereParam, from, to]);
            }
        } else {
            console.log("query 33333333333 >>> ", query + queries.getAppointmentListReportWithLimit)
            if (user.user.doctor_key) {
                app = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithLimit, [whereParam, offset, endset, from]);
                reportList = await this.patientReportRepository.query(query + queries.getAppointmentListReport, [whereParam, from]);
            }
        }
        console.log("appapp: ", app);
        const appReport = await this.convertAppointmentReportUTCToUser(app, user.timeZone);
        console.log("appReportappReportappReport: ", appReport);
        response['totalCount'] = reportList.length;
        response['list'] = appReport;

        if (reportList.length) {
            return {
                statusCode: HttpStatus.OK,
                message: 'Appointment Report List fetched successfully',
                data: response,
            }
        }
        else {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: 'No record found'
            }
        }
    }


    async getMessageTemplate(messageType: string, communicationType: string): Promise<any> {
        try {

            const template = await this.appointmentRepository.query(queries.getMessageTemplate, [messageType, communicationType]);
            if (template && template.length) {
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.MESSAGE_TEMPLATE_FETCH_SUCCESS,
                    data: template[0]
                }

            } else {
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message: CONSTANT_MSG.NO_MESSAGE_TEMPLATE
                }
            }

        } catch (err) {
            console.log(err);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }

        }
    }

    //Getting amount  list report
    async amountListReport(user: any): Promise<any> {
        const offset = user.paginationStart;
        const endset = user.paginationLimit;
        const searchText = user.searchText;
        const from = user.fromDate;
        const to = user.toDate;
        let response = {};
        let app = [], reportList = [];

        let query = queries.getDoctorReportField + queries.getDoctorReportFromField + queries.getAmountListReportJoinField;

        query += user.user.doctor_key ? queries.getDoctorReportWhereForDoctor : queries.getDoctorReportWhereForAdmin;
        let whereParam = user.user.doctor_key ? user.user.doctor_key : user.user.account_key;

        if (searchText && to === undefined) {
            app = await this.patientReportRepository.query(query + queries.getAmountListReportWithSearch, [whereParam, offset, endset, '%' + searchText + '%', from]);
            reportList = await this.patientReportRepository.query(query + queries.getAmountListReportWithoutLimitSearch, [whereParam, '%' + searchText + '%', from]);

        }
        else if (to) {
            if (searchText) {
                app = await this.patientReportRepository.query(query + queries.getAmountListReportWithFilterSearch, [whereParam, offset, endset, '%' + searchText + '%', from, to]);
                reportList = await this.patientReportRepository.query(query + queries.getAmountListReportWithoutLimitFilterSearch, [whereParam, '%' + searchText + '%', from, to]);
            }
            else {
                app = await this.patientReportRepository.query(query + queries.getAmountListReportWithFilter, [whereParam, offset, endset, from, to]);
                reportList = await this.patientReportRepository.query(query + queries.getAmountListReportWithoutLimitFilter, [whereParam, from, to]);
            }
        } else {
            if (user.user.doctor_key) {
                app = await this.patientReportRepository.query(query + queries.getAmountListReportWithLimit, [whereParam, offset, endset, from]);
                reportList = await this.patientReportRepository.query(query + queries.getAmountListReport, [whereParam, from]);
            }
        }
        const appReport = await this.convertAppointmentReportUTCToUser(app, user.timeZone);
        response['totalCount'] = reportList.length;
        response['list'] = appReport;

        if (reportList.length) {
            return {
                statusCode: HttpStatus.OK,
                message: 'Amount Collection List fetched successfully',
                data: response,
            }
        }
        else {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: 'No record found'
            }
        }
    }

    // Getting advertisement list
    async advertisementList(user: any): Promise<any> {
        try {
            const advertisement = await this.patientReportRepository.query(queries.getAdvertisementList);
            if (advertisement && advertisement.length) {
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.ADVERTISEMENT_LIST_FETCH_SUCCESS,
                    data: advertisement,
                }
            }
            else {
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message: CONSTANT_MSG.NO_ADVERTISEMENT_LIST
                }
            }

        } catch (err) {
            console.log(err);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async getPrescriptionList(appointmentId: any): Promise<any> {
        const response = await this.prescriptionRepository.query(
            queries.getPrescription,
            [appointmentId],
        );
        return response;
    }

    async getReportList(doctorId: number, patientId: any, appointmentId: any): Promise<any> {
        const response = await this.patientReportRepository.query(
            queries.getReportVideoUsage,
            [doctorId, patientId, appointmentId, 0, 5],
        );
        return response;
    }

    async getPrescriptionDetails(appointmentId: Number): Promise<any> {
        const prescription = await this.medicineRepository.query(queries.getPrescriptionDetails, [appointmentId])
        //pres remark
        const remarks=await this.prescriptionRepository.query(queries.getRemarks,[appointmentId])

        const prescriptionRemarks = remarks && remarks.length ? remarks[remarks.length-1].remarks : null;

        const prescriptionDiagnosis = remarks && remarks.length ? remarks[remarks.length-1].diagnosis : null;

        return {
            appointmentId,
            prescription,
            prescriptionRemarks,
            prescriptionDiagnosis,
        }
    }
    async getAppointmentDetails(appointmentId: Number): Promise<any> {
        return await this.appointmentRepository.query(queries.getAppointmentDetails, [appointmentId])
    }

    async getAppointmentReports(user: any): Promise<any> {
        let appoinmentId = user.appointmentId;
        const appointmentDetails = await this.appointmentRepository.findOne({ id: appoinmentId });
        const attenderDetails = await this.appointmentRepository.query(queries.getAttenderDetails,[appoinmentId])
        
        const attenderVideoSession = attenderDetails.length > 0 ? attenderDetails[0].video_call_details ? JSON.parse(attenderDetails[0].video_call_details) : null : null ; 
        const reports=[];

        if((user.permission === 'ATTENDER' && user.appId != appoinmentId) || (user.permission === 'CUSTOMER' && (((appointmentDetails.patientId != user.patientId && !attenderDetails) && (attenderDetails.length > 0 && user.patientId != attenderDetails[0].patient_id)) || (user.patientId != appointmentDetails.patientId && attenderVideoSession && attenderVideoSession.appointmentId &&  attenderVideoSession.appointmentId != appoinmentId))) ) {
            
            return {
                statusCode: HttpStatus.OK,
                message: 'Fetched report successfully',
                appoinmentId,
                reports
            }
        }
         if(appointmentDetails.reportid){   
            const reportIds = appointmentDetails.reportid.split(',');
            for(const id of reportIds) {
                const report = await this.patientReportRepository.findOne({

                    where: {
                        id: parseInt(id),
                        active:true
                    }
                    });
                    if(report)
                        reports.push(report);
    
            }
            
        
    }

        return {
            statusCode: HttpStatus.OK,
            message: 'Fetched report successfully',
            appoinmentId,
            reports
        }
    }

    async updatereport(data: any): Promise<any> {

        var account = await this.appointmentRepository.find({ id : data.appointmentId })  
        var arr = JSON.parse("[" + account[0].reportid + "]");
        data.id = data.insertId;
        data.id = data.insertId;
        
        if(account.length){
            const app = await this.appointmentRepository.updateReportId(data)
            return app
        }
       
        else{
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.NOREPORT,
            }
        }
        
    

    }

    async  registerDoctorDetail(doctorDto: DoctorDto): Promise<any> {
        const accountDetail = await this.createAccountDetail(doctorDto);
        const doctor = await this.doctorRepository.doctorRegistration(doctorDto);
        doctorDto.registrationNumber = doctor.registrationNumber;
        const config = await this.doctorConfigRepository.doctorConfigSetup(doctor, doctorDto);
        return doctorDto;
    }

    async createDoctorDetail(doctorDto: any) : Promise<any> {
        try {
            const doctor = new Doctor();
            doctor.doctorName = doctorDto.firstName + doctorDto.lastName || null;
            doctor.accountKey = doctorDto.accountKey;
            doctor.doctorKey = doctorDto['doctor_key'];
            doctor.experience = Number(doctorDto['experience']) || 0;
            doctor.speciality = doctorDto['specialization'] || null;
            doctor.qualification = doctorDto.qualification || null;
            doctor.number = doctorDto.number || null;
            doctor.firstName = doctorDto.firstName || null;
            doctor.lastName = doctorDto.lastName || null;
            doctor.email = doctorDto.email || null;
            doctor.liveStatus = "online";
            doctor.registrationNumber = doctorDto.registrationNumber;
            // const docDetail = await this.doctorRepository.query(queries.insertDoctorInCalender,
            //     [doctor.doctorName, doctor.accountKey, doctor.doctorKey, doctor.experience, doctor.speciality, doctor.qualification,
            //     doctor.number, doctor.firstName, doctor.lastName, doctor.registrationNumber, doctor.email, doctor.liveStatus]);
            // if (docDetail) return doctorDto; 
            // else
             return null;
            } catch (err) {
                return err;
            }
    }

    async createAccountDetail(doctorDto: any) : Promise<any> {
        try {
            const account = await this.accountDetailsRepository.query(queries.getAccountDetailCalendar);
            if (account && account.length) {
                try {
                const accountDetail = await this.accountDetailsRepository.query(queries.insertAccountDetail,
                    [doctorDto.accountKey, doctorDto['hospitalName'] || null, '600000', doctorDto.number, account[0].account_details_id + 1]);
                    return doctorDto;
                } catch (error) {
                    this.logger.error(`Unexpected Appointment save error` + error.message);
                    throw new InternalServerErrorException();
                }
            } else {
                try {
                    console.log(doctorDto)
                    const accountDetail = await this.accountDetailsRepository.query(queries.insertAccountDetail,
                        [doctorDto.accountKey, doctorDto['hospitalName'] || null, '600000', doctorDto.number, 1]);
                        console.log(accountDetail)
                        return doctorDto;
                } catch (error) {
                    this.logger.error(`Unexpected Appointment save error` + error.message);
                    throw new InternalServerErrorException();
                }
               
            }
        } catch (err) {
            return err;
        }
    }

    async addRegistrationIdProof(registrationIdProof: any): Promise<any> {
        try {
            const AWS = require('aws-sdk');
            const ID = 'AKIAISEHN3PDMNBWK2UA';
            const SECRET = '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';
            const BUCKET_NAME = 'virujh-cloud';
            const s3 = new AWS.S3({
                accessKeyId: ID,
                secretAccessKey: SECRET

            });
            if (registrationIdProof.file.mimetype === "application/pdf") {
                var base64data = Buffer.from(registrationIdProof.file.buffer, 'base64');
            }
            else {
                var base64data = Buffer.from(registrationIdProof.file.buffer, 'binary');
            }
            const parames = {
                ACL: 'public-read',
                Bucket: BUCKET_NAME,
                Key: `virujh/registrationIdProof/` + registrationIdProof.file.originalname,
                Body: base64data
            };

            const result = new Promise((resolve, reject) => {
                s3.upload(parames, async (err, data) => {
                    if (err) {
                        console.log(`registrationIdProof file Uploade Failed` + err);
                        reject({
                            statusCode: HttpStatus.NO_CONTENT,
                            message: "Image Uploaded Failed"
                        });
                    } else {
                        resolve({
                            statusCode: HttpStatus.OK,
                            message: "Image Uploaded Successfully",
                            data: data.Location,
                        })
                    }
                });
            });
            return result;
        } catch (err) {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: err.message,
                error: err
            };
        }
    }

    async setPatientTokenExpiry(patientId: number): Promise<any> {
        const patient = await this.patientDetailsRepository.query(queries.setPatientTokenExpiry, [patientId]);
        return patient[0];
    }

    async setDoctorTokenExpiry(doctorId: number): Promise<any> {
        const doctor = await this.doctorRepository.query(queries.setDoctorTokenExpiry, [doctorId]);
        return doctor[0];
    }

     async getPatientTokenExpiry(patientId: number): Promise<any> {
        const patient = await this.patientDetailsRepository.query(queries.changePatientTokenExpiry, [patientId]);
        return patient[0];
    }

    async getDoctorTokenExpiry(doctorId: number): Promise<any> {
        const doctor = await this.doctorRepository.query(queries.changeDoctorTokenExpiry, [doctorId]);
        return doctor[0];
    }

    async patientTokenExpiryFinal(patientId: number): Promise<any> {
        const patient = await this.patientDetailsRepository.query(queries.patientTokenExpiryFinal, [patientId]);
        return patient[0];
    } 

    async updateDoctorTokenExpiry(doctorId: number): Promise<any> {
        const doctor = await this.doctorRepository.query(queries.doctorTokenExpiryFinal, [doctorId]);
        return doctor[0];
    }

    async patientDetailsByEmail(email: string): Promise<any> {
        const patient = await this.patientDetailsRepository.query(queries.getPatientDetailsByEmail, [email]);
        return patient[0];
    }

    async getDocAndPatDetailsByAppId(appId: number) {
        return await this.appointmentRepository.query(queries.getDocAndPatDetailsByAppId,  [appId]);
    }

    async validateAppDateForJoinCall(appointmentId: number): Promise<any> {
        const appDetails = await this.appointmentRepository.query(queries.getDocAndPatDetailsByAppId,  [appointmentId]);        
        if(appDetails && appDetails[0].attender_email) {
            // let userCurrentDate = new Date(moment(new Date()).utcOffset(app.timeZone).format("YYYY-MM-DDTHH:mm:ss.SSSS"));
            let currentDate = new Date();
            const currentTime = currentDate.getHours() + ':' + currentDate.getMinutes() + ':' + '00';
            let dayBefore = moment(new Date(currentDate).setDate(new Date(currentDate).getDate() - 1)).format("YYYY-MM-DD");
            dayBefore = moment(dayBefore).add(currentTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
            const appointmentDate = moment(appDetails[0].appointment_date).add(appDetails[0].startTime).format('YYYY-MM-DDTHH:mm:ss.SSSS');
            let maxDate = new Date(currentDate);
            maxDate.setHours(23,59,59,0);
            maxDate = moment(maxDate).format('YYYY-MM-DDTHH:mm:ss.SSSS');
           
            if (dayBefore <= appointmentDate &&  maxDate>= appointmentDate) {                
                return {
                    statusCode : HttpStatus.OK,
                    message : 'Appointment details fetched successfully',
                    appDetails : appDetails[0]
                }
            }
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.FUTURE_CALLS_NOT_POSSIBLE,
            }
        }
        return {
            statusCode: HttpStatus.BAD_REQUEST,
            message: CONSTANT_MSG.INVALID_REQUEST,
        }
    }

    async getAppointmentByValidation(meetingId: string,passcode: string): Promise<any> {      
        var sessionDetails = await this.appointmentSessionDetailsRepository.findOne({meetingId:meetingId});
        if(sessionDetails && sessionDetails.passcode && bcrypt.compareSync(passcode, sessionDetails.passcode)){
            return sessionDetails;
        } else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
    }

    async checkPatientExistOrNot(patientDetails) {
        // const patient = await this.patientDetailsRepository.query(queries.checkPatientExistOrNot, [patientDetails.mobile, patientDetails.email]);
        const valuesArray = [];
        //patientDetails.attenderEmail && valuesArray.push({email: patientDetails.attenderEmail});
        patientDetails.attenderMobile && valuesArray.push({phone: patientDetails.attenderMobile});
        const patient = await this.patientDetailsRepository.findOne({where :valuesArray });
        return patient;
    }

    async updateAttenderEmailByPatient(appointmentDto: any): Promise<any> {
        try {
            const currentAppointment = await this.appointmentRepository.query(queries.getDocAndPatDetailsByAppId,  [appointmentDto.appointmentId]);
            if(currentAppointment && currentAppointment[0].patient_id == appointmentDto.user.patientId) {
                const pat = await this.checkPatientExistOrNot(appointmentDto);
                if(!currentAppointment[0].isCancel && (!pat|| (pat && pat?.patientId != currentAppointment[0].patientId))) {
                    var isAttenderEmailSame:boolean = false;
                    var values:any = {};
                    if(appointmentDto.attenderEmail) {
                        values.attenderEmail = appointmentDto.attenderEmail;
                        if(appointmentDto.attenderEmail == currentAppointment[0].attender_email){
                            isAttenderEmailSame = true;
                        }
                    }
                    if(appointmentDto.attenderName) {
                        values.attenderName = appointmentDto.attenderName;
                    }
                    if(appointmentDto.attenderMobile) {
                        values.attenderMobile = appointmentDto.attenderMobile;
                    }
                    var updatedDetails = await this.appointmentRepository.update({id: appointmentDto.appointmentId}, values);
                    var updatedSessionDetails = await this.insertUpdateSessionDetails(appointmentDto.appointmentId);
                      if (updatedDetails.affected && updatedSessionDetails) {
                        currentAppointment[0].meetingId = updatedSessionDetails.meetingId;
                        currentAppointment[0].passcode = updatedSessionDetails.passcode
                        return {
                            statusCode: HttpStatus.OK,
                            message: "Attender details updated Successfully",
                            isAttenderExistPat: pat ? true : false,
                            isAttenderEmailSame : isAttenderEmailSame,
                            appointmentDetails: currentAppointment[0]
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
                        message: pat?.patientId != currentAppointment[0].patientId ? `Don't add your own email or phone as attender email` : CONSTANT_MSG.APPOINT_NOT_AVAILABLE
                    }
                }
            } else {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.INVALID_REQUEST
                }
            }
        } catch (err) {
            console.log("Error in updateAttenderEmailByPatient function: ", err);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }
    
    async removeAttenderDetails(user: any): Promise<any> {
        const app = await this.appointmentRepository.query(queries.getAppointmentDetails,[user.appointmentId]);
        if(app && app[0].patientid == user.patientId){
            try {
                const removeDetails = await this.patientDetailsRepository.query(queries.removeAttenderDetailsByPatient, [user.appointmentId]);
                return{
                    statusCode: HttpStatus.OK,
                    message: "Attender details removed Successfully",              
                }
            }
            catch (e) {
                return {
                    statusCode: HttpStatus.NOT_MODIFIED,
                    message: CONSTANT_MSG.UPDATE_FAILED,
                };
            } 
        }
        else {
            return {
            statusCode: HttpStatus.BAD_REQUEST,
            message: CONSTANT_MSG.INVALID_REQUEST,
            };
        }        
    }

    async insertAttenderDetails(appointmentDto: any): Promise<any> {
        try {
            const currentAppointment = await this.appointmentRepository.query(queries.getDocAndPatDetailsByAppId,  [appointmentDto.appointmentId]);
            if(currentAppointment && Number(currentAppointment[0].patient_id) === Number(appointmentDto.user.patientId)) {
                const pat = await this.checkPatientExistOrNot(appointmentDto);
                if(!currentAppointment[0].isCancel && (!pat||(pat && Number(pat.patientId) != Number(currentAppointment[0].patient_id)))) {
                    var values:any = {};
                    values.attenderEmail = appointmentDto.attenderEmail;
                    values.attenderName = appointmentDto.attenderName;
                    values.attenderMobile = appointmentDto.attenderMobile;                    
                    var updatedDetails = await this.appointmentRepository.update({id: appointmentDto.appointmentId}, values);
                    var updatedSessionDetails = await this.insertUpdateSessionDetails(appointmentDto.appointmentId);
                    if (updatedDetails.affected && updatedSessionDetails) {
                          currentAppointment[0].meetingId = updatedSessionDetails.meetingId;
                          currentAppointment[0].passcode = updatedSessionDetails.passcode
                        return {
                            statusCode: HttpStatus.OK,
                            message: "Attender details added Successfully",  
                            isAttenderExistPat: pat ? true : false,
                            appointmentDetails: currentAppointment[0]
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
                        message: pat.patientId != currentAppointment[0].patientId ? `Don't add your own email or phone as attender email` : CONSTANT_MSG.APPOINT_NOT_AVAILABLE
                    }
                }
            } else {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.APPOINT_NOT_AVAILABLE
                }
            }
        } catch (err) {
            console.log("Error in updateAttenderEmailByPatient function: ", err);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async insertUpdateSessionDetails(appointmentId:any):Promise<any>{    
        var sessionDetails = await this.appointmentSessionDetailsRepository.findOne({appointmentId:appointmentId});
        let values : any ={};
        values.meetingId = 'VIRUJH-' + Math.random().toString(36).slice(-5);
        let passcode = Math.random().toString(36).substring(3,9);
        let saltRounds = CONSTANT_MSG.SALT_ROUNDS;
        const encryptedPasscode = bcrypt.hashSync(passcode, saltRounds);
        values.passcode = encryptedPasscode;        
        if(!sessionDetails){
            values.appointmentId = appointmentId;
            var insertSessionDetails = await this.appointmentSessionDetailsRepository.save(values);
            return {
                insertSessionDetails :insertSessionDetails,
                passcode : passcode,
                meetingId :values.meetingId
            };
        } else{
            var updatedSessionDetails = await this.appointmentSessionDetailsRepository.update({appointmentId:appointmentId},values);
            return {
                updatedSessionDetails:updatedSessionDetails,
                passcode : passcode,
                meetingId :values.meetingId
            };
        }
    }
}
