import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import {AppointmentDocConfig} from "./appointmentDocConfig.entity";


@EntityRepository(AppointmentDocConfig)
export class AppointmentDocConfigRepository extends Repository<AppointmentDocConfig> {

    private logger = new Logger('AppointmentDocConfigRepository');
    async createAppDocConfig(appointmentDto: any): Promise<any> {
        const appointment = new AppointmentDocConfig();
        appointment.appointmentId = appointmentDto.appointmentId;
        appointment.consultationCost =appointmentDto.config.consultationCost ;
        appointment.isPatientPreconsultationAllowed = appointmentDto.config.isPreconsultationAllowed ;
        appointment.preconsultationHours = appointmentDto.config.preconsultationHours;
        appointment.preconsultationMinutes = appointmentDto.config.preconsultationMins;
        appointment.isPatientCancellationAllowed = appointmentDto.config.isPatientCancellationAllowed;
        appointment.cancellationDays= appointmentDto.config.cancellationDays;
        appointment.cancellationHours= appointmentDto.config.cancellationHours;
        appointment.cancellationMinutes = appointmentDto.config.cancellationMins;
        appointment.isPatientRescheduleAllowed = appointmentDto.config.isPatientRescheduleAllowed;
        appointment.rescheduleDays = appointmentDto.config.rescheduleDays;
        appointment.rescheduleHours= appointmentDto.config.rescheduleHours;
        appointment.rescheduleMinutes= appointmentDto.config.rescheduleMins;
        appointment.autoCancelDays = appointmentDto.config.autoCancelDays;
        appointment.autoCancelHours= appointmentDto.config.autoCancelHours;
        appointment.autoCancelMinutes= appointmentDto.config.autoCancelMins;             

        try {
            const app =  await appointment.save(); 
            return app; 
        } catch (error) {
            console.log(error);
                throw new InternalServerErrorException();
        }
    }
}

