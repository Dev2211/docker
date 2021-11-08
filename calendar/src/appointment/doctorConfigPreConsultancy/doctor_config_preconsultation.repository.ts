import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { Appointment } from "../appointment.entity";
import { AppointmentDto , DoctorConfigPreConsultationDto} from "common-dto";
import { Doctor } from "../doctor/doctor.entity";
import { DoctorConfigPreConsultation } from "./doctor_config_preconsultation.entity";

@EntityRepository(DoctorConfigPreConsultation)
export class DoctorConfigPreConsultationRepository extends Repository<DoctorConfigPreConsultation> {

    private logger = new Logger('DoctorConfigPreConsultationRepository');


    // async doctorPreconsultation(doctorConfigPreConsultationDto: any): Promise<any> {

    //     const { doctorConfigId, doctorKey, consultationCost,isPreConsultationAllowed, preConsultationHours, preconsultationMinutes,isActive,createdOn, modifiedOn } = doctorConfigPreConsultationDto;

    //     const appointment = new DoctorConfigPreConsultation();
    //     // appointment.doctorConfigId = doctorConfigPreConsultationDto.doctorConfigId;
    //     appointment.doctorKey =doctorConfigPreConsultationDto.user.doctor_key;
    //     appointment.consultationCost = doctorConfigPreConsultationDto.consultationCost;
    //     appointment.isPreconsultationAllowed = doctorConfigPreConsultationDto.isPreconsultationAllowed;
    //     appointment.preconsultationHours = doctorConfigPreConsultationDto.preConsultationHours;
    //     appointment.preconsultationMinutes = doctorConfigPreConsultationDto.preConsultationMinutes;
    //     appointment.isActive = true;
    //     appointment.createdOn = doctorConfigPreConsultationDto.createdOn;
    //     appointment.modifiedOn =new Date();



    //     try {
    //         return await appointment.save();          
    //     } catch (error) {
    //         if (error.code === "22007") {
    //            // this.logger.warn(`appointment date is invalid ${appointment.appointmentDate}`);
    //         } else {
    //             this.logger.error(`Unexpected Appointment save error` + error.message);
    //             throw new InternalServerErrorException();
    //         }
    //     }
    // }


}