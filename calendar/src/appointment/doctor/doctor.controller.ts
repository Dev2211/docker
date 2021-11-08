// import { Controller, HttpStatus, Logger, UnauthorizedException } from '@nestjs/common';
// import { DoctorService } from './doctor.service';
// import { MessagePattern } from '@nestjs/microservices';
// import {CONSTANT_MSG, queries, DoctorDto} from 'common-dto';
// import {AppointmentService} from 'src/appointment/appointment.service';



// @Controller('doctor')
// export class DoctorController {

//     private logger = new Logger('DoctorController');

//     constructor(private readonly doctorService: DoctorService,private readonly appointmentService: AppointmentService) {

//     }


//     @MessagePattern({cmd: 'app_doctor_list'})
//     async doctorList(user): Promise<any> {
//         const account = await this.appointmentService.accountDetails(user.account_key);
//         if (user.role == CONSTANT_MSG.ROLES.DOCTOR) {
//             var docKey = await this.doctorService.doctorDetails(user.doctor_key);
//             docKey.fees = 5000;
//             docKey.todaysAppointment = ['4.00pm', '4.15pm', '4.30pm'];
//             docKey.todaysAvailabilitySeats = 12;
//             return {
//                 statusCode: HttpStatus.OK,
//                 accountDetails: account,
//                 doctorList: [docKey]
//             }

//         }else{
//             const doctor = await this.doctorService.doctor_List(user.account_key);
//               // add static values for temp
//               doctor.forEach(v => {
//                 v.fees = 5000;
//                 v.todaysAppointment = ['4.00pm', '4.15pm', '4.30pm'];
//                 v.todaysAvailabilitySeats = 12;
//             })
//             return {
//                 statusCode: HttpStatus.OK,
//                 accountDetails: account,
//                 doctorList: doctor
//             }
//         }
          
//     }



// }
