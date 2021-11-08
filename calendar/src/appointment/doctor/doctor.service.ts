// import { Injectable, HttpStatus, Logger, UnauthorizedException } from '@nestjs/common';
// import {getRepository, Any} from "typeorm";
// import { DoctorRepository } from './doctor.repository';
// import { InjectRepository } from '@nestjs/typeorm';
// import { AppointmentDto, UserDto, DoctorDto,CONSTANT_MSG} from 'common-dto';
// import { Doctor } from './doctor.entity';

// @Injectable()
// export class DoctorService {

//     constructor(
//         @InjectRepository(DoctorRepository) private doctorRepository: DoctorRepository
//     ) {
//     }

//     async doctorDetails(doctorKey): Promise<any> {
//         return await this.doctorRepository.findOne({doctorKey: doctorKey});
//     }

//     async doctor_List(accountKey): Promise<any> {
//         try {
//             const doctorList = await this.doctorRepository.find({accountKey: accountKey});
//             if (doctorList.length) {
//                 return doctorList;
//             } else {
//                 return {
//                     statusCode: HttpStatus.NO_CONTENT,
//                     message: CONSTANT_MSG.INVALID_REQUEST
//                 }
//             }
//         } catch (e) {
//             return {
//                 statusCode: HttpStatus.NO_CONTENT,
//                 message: CONSTANT_MSG.DB_ERROR
//             }
//         }
//     }

//     async findDoctor(id) : Promise<any> {
//         const doctor = await this.doctorRepository.findOne({doctorId : id });
//         if(doctor){
//             return doctor;
//         }
//         else{
//             return 'No Doctor Found';
//         }
       
//     }

//     async doctorList(accountId) : Promise<any> {
//         const doctor = await this.doctorRepository.find({accountKey : accountId });
//         if(doctor){
//             return doctor;
//         }
//         else{
//             return 'No Doctor Found';
//         }
       
//     }

        
    

// }


