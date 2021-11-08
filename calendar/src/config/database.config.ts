import { TypeOrmModuleOptions} from '@nestjs/typeorm';
import * as config from 'config';
import { Appointment } from 'src/appointment/appointment.entity';
import { AccountDetails } from 'src/appointment/account/account_details.entity';
import { DoctorConfigPreConsultation } from 'src/appointment/doctorConfigPreConsultancy/doctor_config_preconsultation.entity';
import { Doctor } from 'src/appointment/doctor/doctor.entity';
import { DoctorConfigCanResch } from 'src/appointment/docConfigReschedule/doc_config_can_resch.entity';
import {docConfig} from "../appointment/doc_config/docConfig.entity";
import {DocConfigScheduleDay} from "../appointment/docConfigScheduleDay/docConfigScheduleDay.entity";
import {DocConfigScheduleInterval} from "../appointment/docConfigScheduleInterval/docConfigScheduleInterval.entity";
import {WorkScheduleDay} from "../appointment/workSchedule/workScheduleDay.entity";
import {WorkScheduleInterval} from "../appointment/workSchedule/workScheduleInterval.entity";
import {PatientDetails} from "../appointment/patientDetails/patientDetails.entity";
import {PaymentDetails} from "../appointment/paymentDetails/paymentDetails.entity";
import {OpenViduSession} from "../appointment/openviduSession/openviduSession.entity";
import {OpenViduSessionToken} from "../appointment/openviduSession/openviduSessionToken.entity";
import {AppointmentDocConfig} from "../appointment/appointmentDocConfig/appointmentDocConfig.entity";
import {Prescription} from "../appointment/prescription.entity";
import {AppointmentCancelReschedule} from "../appointment/appointmentCancelReschedule/appointmentCancelReschedule.entity";
import { Medicine } from 'src/appointment/medicine.entity';
import { patientReportDto } from 'common-dto';
import { PatientReport } from 'src/appointment/patientReport.entity';
import { Mobile_version } from 'src/appointment/mobile_version/mobile_version.entity';
import { AppointmentSessionDetails } from 'src/appointment/appointmentSessionDetails/appointmentSessionDetails.entity';

const dbConfig = config.get('database');

export const databaseConfig : TypeOrmModuleOptions = {

    type : dbConfig.type,
    host : dbConfig.host,
    port : dbConfig.port,
    username : dbConfig.username,
    password : dbConfig.password,
    database : dbConfig.database,
    
    entities : [Appointment,AccountDetails,DoctorConfigPreConsultation, Doctor, DoctorConfigCanResch, docConfig,DocConfigScheduleDay,DocConfigScheduleInterval,WorkScheduleDay,WorkScheduleInterval,PatientDetails,PaymentDetails,AppointmentDocConfig,AppointmentCancelReschedule, OpenViduSession,OpenViduSessionToken,
        Prescription, Medicine, PatientReport, Mobile_version,AppointmentSessionDetails],
    synchronize : dbConfig.synchronize

} 