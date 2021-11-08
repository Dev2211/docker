import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { DoctorConfigCanResch } from "./doc_config_can_resch.entity";
import { AppointmentDto , DoctorConfigPreConsultationDto, DoctorConfigCanReschDto} from "common-dto";



@EntityRepository(DoctorConfigCanResch)
export class DoctorConfigCanReschRepository extends Repository<DoctorConfigCanResch> {

    private logger = new Logger('DoctorConfigCanReschRepository');
    // async doctorCanReschEdit(doctorConfigCanReschDto: any): Promise<any> {

    // const { docConfigCanReschId, doctorKey, isPatientCancellationAllowed, cancellationDays,cancellationHours,cancellationMinutes,isPatientReschAllowed,rescheduleDays,rescheduleHours,rescheduleMinutes,autoCancelDays,autoCancelHours,autoCancelMinutes,isActive,createdOn,modifiedOn } = doctorConfigCanReschDto;

    //     const appointment = new DoctorConfigCanResch();
    //     appointment.doctorKey =doctorConfigCanReschDto.user.doctor_key ;
    //     appointment.isPatientCancellationAllowed = doctorConfigCanReschDto.isPatientCancellationAllowed;
    //     appointment.cancellationDays = doctorConfigCanReschDto.cancellationDays;
    //     appointment.cancellationHours = doctorConfigCanReschDto.cancellationHours;
    //     appointment.cancellationMinutes = doctorConfigCanReschDto.cancellationMinutes;
    //     appointment.isPatientReschAllowed = doctorConfigCanReschDto.isPatientReschAllowed;
    //     appointment.rescheduleDays = doctorConfigCanReschDto.rescheduleDays;
    //     appointment.rescheduleHours = doctorConfigCanReschDto.rescheduleHours;
    //     appointment.rescheduleMinutes = doctorConfigCanReschDto.rescheduleMinutes;
    //     appointment.autoCancelDays = doctorConfigCanReschDto.autoCancelDays;
    //     appointment.autoCancelHours = doctorConfigCanReschDto.autoCancelHours;
    //     appointment.autoCancelMinutes = doctorConfigCanReschDto.autoCancelMinutes;
    //     appointment.isActive = doctorConfigCanReschDto.isActive;
    //     appointment.createdOn = doctorConfigCanReschDto.createdOn;
    //     appointment.modifiedOn = new Date();

    //     try {
    //         return await appointment.save();          
    //     } catch (error) {
    //         if (error.code === "22007") {
    //             this.logger.warn(`appointment date is invalid ${appointment.doctorKey}`);
    //             //throw new ConflictException("Appointment already exists");
    //         } else {
    //             this.logger.error(`Unexpected Appointment save error` + error.message);
    //             throw new InternalServerErrorException();
    //         }
    //     }
    // }


    

}