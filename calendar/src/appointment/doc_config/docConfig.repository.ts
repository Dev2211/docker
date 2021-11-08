import { Repository, EntityRepository } from "typeorm";
import { InternalServerErrorException,  Logger } from "@nestjs/common";
import {docConfig} from "./docConfig.entity";
import { queries, DoctorDto } from "common-dto";
import { Doctor } from "../doctor/doctor.entity";

@EntityRepository(docConfig)
export class docConfigRepository extends Repository<docConfig> {

    private logger = new Logger('docConfigRepository');
    
    async doctorConfigSetup(doctor: Doctor, doctorDto: DoctorDto): Promise<any> {

        // const docConfigQuery  = await this.query(queries.docConfig, [doctor.doctorKey, 0]);
        const Sunday = await this.query(queries.sunday, [doctor.doctorId, doctor.doctorKey ,'Sunday'])
        const Monday = await this.query(queries.monday, [doctor.doctorId, doctor.doctorKey, 'Monday'])
        const Tuesday = await this.query(queries.tuesday, [doctor.doctorId, doctor.doctorKey, 'Tuesday'])
        const Wednesday = await this.query(queries.wednesday, [doctor.doctorId, doctor.doctorKey, 'Wednesday'])
        const Thursday = await this.query(queries.thursday, [doctor.doctorId, doctor.doctorKey, 'Thursday'])
        const Friday = await this.query(queries.friday, [doctor.doctorId, doctor.doctorKey, 'Friday'])
        const Saturday = await this.query(queries.saturday, [doctor.doctorId, doctor.doctorKey, 'Saturday'])

        const config = new docConfig();
        console.log(doctorDto['doctor_key'])
        config.doctorKey = doctorDto['doctor_key'];
        config.consultationCost = doctorDto['consultationCost'] ? doctorDto['consultationCost'] : 100;
        config.consultationSessionTimings = doctorDto['consultationSessionTimings'] ? doctorDto['consultationSessionTimings'] : 15;
        config.isPatientRescheduleAllowed = false;
        config.isPreconsultationAllowed = false;
        config.isPatientCancellationAllowed = false;

        try {
            return await config.save();
        } catch (error) {
            this.logger.error(`Unexpected Appointment save error` + error.message);
            throw new InternalServerErrorException();
        }
    }  

}