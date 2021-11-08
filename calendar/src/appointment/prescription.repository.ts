import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { Prescription } from "./prescription.entity";


@EntityRepository(Prescription)
export class PrescriptionRepository extends Repository<Prescription> {

    private logger = new Logger('PrescriptionRepository');
    async prescriptionInsertion(accountDto: any): Promise<any> {

        const prescription = new Prescription();
        prescription.id = accountDto.id;
        prescription.appointmentId = accountDto.appointmentId;
        prescription.appointmentDate = accountDto.appointmentDate ? accountDto.appointmentDate : null;
        prescription.hospitalLogo = accountDto.hospitalLogo ? accountDto.hospitalLogo : null;
        prescription.hospitalName = accountDto.hospitalName ? accountDto.hospitalName : null;
        prescription.doctorName = accountDto.doctorName ? accountDto.doctorName : null;
        prescription.doctorSignature = accountDto.doctorSignature ? accountDto.doctorSignature : null;
        prescription.patientName = accountDto.patientName ? accountDto.patientName : null;
        prescription.prescriptionUrl =accountDto.prescriptionUrl? accountDto.prescriptionUrl : null;
        prescription.remarks = accountDto.remarks ? accountDto.remarks : null;
        prescription.diagnosis = accountDto.diagnosis ? accountDto.diagnosis : null;
        prescription.hospitalAddress = accountDto.hospitalAddress ? accountDto.hospitalAddress : null;
        
        try {
            const acc = await prescription.save();
            return {
                appointmentdetails: acc,
            };
        } catch (error) {
            this.logger.error(`Unexpected prescription save error` + error.message);
            throw new InternalServerErrorException();
        }
    }

}