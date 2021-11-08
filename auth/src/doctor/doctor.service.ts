import { Injectable } from '@nestjs/common';
//import { DoctorRepository } from './doctor.repository';
import { InjectRepository } from '@nestjs/typeorm';
import { AppointmentDto, UserDto, DoctorDto} from 'common-dto';
//import { AccountRepository } from './account.repository';
//import { Appointment } from './appointment.entity';
//import { Doctor } from './doctor.entity';
//import { Account } from 'account/account.entity';

@Injectable()
export class DoctorService {

    constructor(
    //    @InjectRepository(DoctorRepository) private doctorRepository: DoctorRepository
    ) {
    }

    // async GetDoctorList(doctorDto : DoctorDto): Promise<Doctor[]>{
    //     const { email, password } = userDto;
    //    return await this.doctorRepository.find({});
    // }

    // async doctorLogin(email,password) : Promise<any> {
    //    const doctor = await this.doctorRepository.findOne({email : email, password : password});
    //     if(doctor){
    //         return doctor;
    //     }
    //     else{
    //         return 'Invalid Credentials';
    //     }
       
    // }


    // async findDoctor(id) : Promise<any> {
    //     const doctor = await this.doctorRepository.findOne({doctor_id : id });
    //     if(doctor){
    //         return doctor;
    //     }
    //     else{
    //         return 'No Doctor Found';
    //     }
       
    // }

    // async doctorList(accountId) : Promise<any> {
    //     const doctor = await this.doctorRepository.find({accountId : accountId });
    //     if(doctor){
    //         return doctor;
    //     }
    //     else{
    //         return 'No Doctor Found';
    //     }
       
    // }

        
    

}


