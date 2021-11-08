import { Module } from '@nestjs/common';
import { AppointmentController } from './appointment.controller';
import { AppointmentService } from './appointment.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppointmentRepository } from './appointment.repository';
import { DoctorRepository } from './doctor/doctor.repository';
import { AccountDetailsRepository } from './account/account.repository';
import { DoctorConfigPreConsultationRepository } from './doctorConfigPreConsultancy/doctor_config_preconsultation.repository';
import { DoctorConfigCanReschRepository } from './docConfigReschedule/doc_config_can_resch.repository';
import {docConfigRepository} from "./doc_config/docConfig.repository";
import {DocConfigScheduleDayRepository} from "./docConfigScheduleDay/docConfigScheduleDay.repository";
import {DocConfigScheduleIntervalRepository} from "./docConfigScheduleInterval/docConfigScheduleInterval.repository";
import {WorkScheduleDayRepository} from "./workSchedule/workScheduleDay.repository";
import {WorkScheduleIntervalRepository} from "./workSchedule/workScheduleInterval.repository";
import {PatientDetailsRepository} from "./patientDetails/patientDetails.repository";
import {PaymentDetailsRepository} from "./paymentDetails/paymentDetails.repository";
import {OpenViduSessionRepository} from "./openviduSession/openviduSession.repository";
import {OpenViduSessionTokenRepository} from "./openviduSession/openviduSessionToken.repository";
import {AppointmentDocConfigRepository} from "./appointmentDocConfig/appointmentDocConfig.repository";
import {PrescriptionRepository} from "./prescription.repository";
import {PatientReportRepository} from "./patientReport.repository";
import {AppointmentCancelRescheduleRepository} from "./appointmentCancelReschedule/appointmentCancelReschedule.repository";

import { VideoService } from './video.service';
import { PaymentService } from './payment.service';
import { OpenViduService } from './open-vidu.service';
import { MedicineRepository } from './medicine.repository';
import { HelperService } from 'src/utility/helper.service';
import { VersionRepository } from './mobile_version/mobile_version.repository';
import { AppointmentSessionDetailsRepository } from './appointmentSessionDetails/appointmentSessionDetails.repository'
// import { DoctorController } from './doctor/doctor.controller';
// import { DoctorService } from './doctor/doctor.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([AppointmentRepository,DoctorRepository, AccountDetailsRepository,
      DoctorConfigPreConsultationRepository,DoctorConfigCanReschRepository, docConfigRepository,DocConfigScheduleDayRepository,
      DocConfigScheduleIntervalRepository,WorkScheduleDayRepository,WorkScheduleIntervalRepository ,PatientDetailsRepository,
      PaymentDetailsRepository,AppointmentDocConfigRepository,AppointmentCancelRescheduleRepository,
      PrescriptionRepository,PatientReportRepository, MedicineRepository,
      OpenViduSessionRepository,OpenViduSessionTokenRepository, VersionRepository,AppointmentSessionDetailsRepository])

  ],
  controllers: [AppointmentController],
  providers: [AppointmentService, VideoService, OpenViduService,PaymentService, HelperService]
})
export class AppointmentModule { }
