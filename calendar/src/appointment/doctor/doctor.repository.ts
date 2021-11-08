import { Repository, EntityRepository } from "typeorm";
import { InternalServerErrorException, Logger } from "@nestjs/common";
import { Doctor } from "./doctor.entity";
import { queries, DoctorDto } from "common-dto";

@EntityRepository(Doctor)
export class DoctorRepository extends Repository<Doctor> {

    private logger = new Logger('DoctorRepository');

    async doctorRegistration(doctorDto: DoctorDto): Promise<any> {

        // Find max registration Key
        const maxAccKey: any = await this.query(queries.getRegKey)
        let regKey = 'RegD_';
        if (maxAccKey.length) {
            let m = maxAccKey[0]
            regKey = regKey + (Number(m.maxreg) + 1)
        } else {
            regKey = 'RegD_1'
        }
        doctorDto.registrationNumber = regKey;

        const doctor = new Doctor();
        doctor.accountKey = doctorDto.accountKey;
        doctor.doctorKey = doctorDto['doctor_key'];
        doctor.email = doctorDto.email;
        doctor.firstName = doctorDto['firstName'];
        doctor.lastName = doctorDto['lastName'];
        doctor.doctorName = doctorDto['firstName'] + " " + doctorDto['lastName'];
        doctor.experience = doctorDto['experience'] ? doctorDto['experience'] : null;
        doctor.speciality = doctorDto.speciality ? doctorDto.speciality : null;
        doctor.qualification = doctorDto.qualification ? doctorDto.qualification : null;
        doctor.photo = doctorDto.photo ? doctorDto.photo : null;
        doctor.number = doctorDto.number ? doctorDto.number : null;
        doctor.signature = doctorDto.signature ? doctorDto.signature : null;
        doctor.registrationNumber = doctorDto.registrationNumber ? doctorDto.registrationNumber : null;
        doctor.registrationIdProof = doctorDto['registrationIdProof'] ? doctorDto['registrationIdProof'] : null;
        doctor.reportRemainderId = 1; //1==ON_EVERY_APPOINTMENT
        try {
            return await doctor.save();
        } catch (error) {
            console.log(error)
            this.logger.error(`Unexpected Appointment save error` + error.message);
            throw new InternalServerErrorException();
        }
    }  

}