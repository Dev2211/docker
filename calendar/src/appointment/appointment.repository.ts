import { Repository, EntityRepository } from "typeorm";
import {InjectRepository} from '@nestjs/typeorm';
import {HttpStatus} from '@nestjs/common';
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { Appointment } from "./appointment.entity";
import { PaymentDetails } from "./paymentDetails/paymentDetails.entity";
import { AppointmentDto , DoctorConfigPreConsultationDto,CONSTANT_MSG,queries} from  "common-dto";
import { AppointmentDocConfigRepository } from "./appointmentDocConfig/appointmentDocConfig.repository";
import { AppointmentCancelRescheduleRepository } from "./appointmentCancelReschedule/appointmentCancelReschedule.repository";
import { AppointmentDocConfig } from "./appointmentDocConfig/appointmentDocConfig.entity";

var moment = require('moment');

@EntityRepository(Appointment)
export class AppointmentRepository extends Repository<Appointment> {
    //constructor AppointmentRepository(appointmentDocConfigRepository: AppointmentDocConfigRepository, appointmentCancelRescheduleRepository: AppointmentCancelRescheduleRepository): AppointmentRepository

    private logger = new Logger('AppointmentRepository');
    private appointmentDocConfigRepository:AppointmentDocConfigRepository;
    private appointmentCancelRescheduleRepository:AppointmentCancelRescheduleRepository;
    async convertStartAndEndTimeUtcToUserTimeZone(startTime, endTime, timeZone) {
        console.log("test cal app/; ",startTime," : ", endTime , " : ", timeZone)
        let isAdd = true;
        let userTimeZone;
        let startTimeInUserTimeZone, endTimeInUserTimeZone;
        timeZone = timeZone ? timeZone : '+05:30';
            if (timeZone.includes('-')) {
                isAdd = false;
                userTimeZone = timeZone.split('-')[1];
            } else {
                userTimeZone = timeZone.split('+')[1];
            }
        if (isAdd) {
            startTimeInUserTimeZone = moment(startTime, 'HH:mm').add(moment.duration(userTimeZone)).format("HH:mm:ss");
            endTimeInUserTimeZone = moment(endTime, 'HH:mm').add(moment.duration(userTimeZone)).format("HH:mm:ss");
        } else {
            startTimeInUserTimeZone = moment(startTime, 'HH:mm').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
            endTimeInUserTimeZone = moment(endTime, 'HH:mm').subtract(moment.duration(userTimeZone)).format("HH:mm:ss");
        }
        return { startTimeInUserTimeZone, endTimeInUserTimeZone }
    }

    async createAppointment(appointmentDto: any): Promise<any> {

        const { doctorId, patientId, appointmentDate, startTime, endTime } = appointmentDto;

        const appointment = new Appointment();
        appointment.doctorId = appointmentDto.doctorId;
        appointment.patientId =appointmentDto.patientId ;
        appointment.appointmentDate =new Date(appointmentDto.appointmentDate);
        appointment.startTime = appointmentDto.startTime;
        appointment.endTime = appointmentDto.endTime;
        // appointment.appointmentDate = moment.utc(moment(appointmentDto.appointmentDate)).format();
        // appointment.startTime = new moment(appointmentDto.startTime, "HH:mm").utc();
        // appointment.endTime = new moment(appointmentDto.endTime, "HH:mm").utc();
        appointment.slotTiming = appointmentDto.configSession;
        appointment.isActive= true;
        appointment.isCancel= false;
        appointment.paymentOption = appointmentDto.paymentOption;
        appointment.consultationMode = appointmentDto.consultationMode;
        appointment.createdTime = new Date();
        //appointment.createdTime = moment().format();
        // if(appointmentDto.user){
        //     appointment.createdBy = appointmentDto.user.role.indexOf('DOCTOR') != -1 ? CONSTANT_MSG.ROLES.DOCTOR : appointmentDto.user.role.indexOf('ADMIN') != -1 ? CONSTANT_MSG.ROLES.ADMIN : CONSTANT_MSG.ROLES.DOCTOR;
        //     appointment.createdId = appointmentDto.user.userId;
        // }else{
        //     appointment.createdBy = CONSTANT_MSG.ROLES.PATIENT;
        //     appointment.createdId = appointmentDto.patientId;
        // }
        if(appointmentDto && appointmentDto.user && (appointmentDto.user.role.indexOf('DOCTOR') != -1 || (appointmentDto.user.role.indexOf('ADMIN') != -1) || (appointmentDto.user.role.indexOf('DOC_ASSISTANT') != -1))){
            appointment.createdBy = appointmentDto.user.role.indexOf('DOCTOR') != -1 ? CONSTANT_MSG.ROLES.DOCTOR : appointmentDto.user.role.indexOf('ADMIN') != -1 ? CONSTANT_MSG.ROLES.ADMIN : appointmentDto.user.role.indexOf('DOC_ASSISTANT') != -1 ? CONSTANT_MSG.ROLES.DOC_ASSISTANT : CONSTANT_MSG.ROLES.DOCTOR;
            appointment.createdId = appointmentDto.user.userId;
        }else{
            appointment.createdBy = CONSTANT_MSG.ROLES.PATIENT;
            appointment.createdId = appointmentDto.patientId;
        }
        if(appointmentDto?.reportid){
            appointment.reportid = appointmentDto.reportid
        }               
        if(appointmentDto?.attenderEmail){
            appointment.attenderEmail = appointmentDto.attenderEmail;
        }
        if(appointmentDto?.attenderMobile){
            appointment.attenderMobile = appointmentDto.attenderMobile;
        }
        if(appointmentDto?.attenderName){
            appointment.attenderName = appointmentDto.attenderName;
        }               

        try {
            const app =  await appointment.save();  
            appointmentDto.appointmentId = app.id;
            let { startTimeInUserTimeZone, endTimeInUserTimeZone } = await this.convertStartAndEndTimeUtcToUserTimeZone(app.startTime, app.endTime, appointmentDto.timeZone);
            app.startTime = startTimeInUserTimeZone;
            app.endTime = endTimeInUserTimeZone;
            return {
                appointmentdetails:app,
            };         
        } catch (error) {
            if (error.code === "22007") {
                this.logger.warn(`appointment date is invalid ${appointment.appointmentDate}`);
            } else {
                this.logger.error(`Unexpected Appointment save error` + error.message);
                throw new InternalServerErrorException();
            }
        }
    }

    async updateReportId(data): Promise<any>{
       
        const newdata = await this.query(queries.getReportId,[data.id,data.appointmentId] ) 
        try {
            return{
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.Report,
            
            }
         } 
         catch (error) {
         this.logger.error(`Unexpected patientReport save error` + error.message);
         throw new InternalServerErrorException();
     }
    }
    async deleteReportid(data): Promise<any>{
       
        const newdata = await this.query(queries.getReportId,[data.id,data.appointmentId] ) 
        try {
            return{
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.  REPORTDELETE,
           
            }
         } 
         catch (error) {
         this.logger.error(`Unexpected patientReport save error` + error.message);
         throw new InternalServerErrorException();
     }
    }
    
}