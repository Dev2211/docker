// import { Controller, Logger } from '@nestjs/common';
// import { DoctorService } from './doctor.service';
// import { AccountService } from 'src/account/account.service';
// import { MessagePattern } from '@nestjs/microservices';
// import { DoctorDto } from 'common-dto';
// import { AccountController } from 'src/account/account.controller';
// import { AccountRepository } from 'src/account/account.repository';



// @Controller('doctor')
// export class DoctorController {

//     private logger = new Logger('DoctorController');

//     constructor(private readonly doctorService: DoctorService, private accountService: AccountService) {

//     }
    

//     @MessagePattern({ cmd: 'auth_doctor_login' })
//     async doctorLogin(doctorDto: any): Promise<any> {
//         const { email, password } = doctorDto;
//         var res=[];
//         const doctor = await this.doctorService.doctorLogin(email,password);
//         var accountId = doctor.accountId;
//         res[0] = doctor;
//         const account = await this.accountService.findById(accountId);
//         res[1] = account;
//         return res;
//     }

     
//     @MessagePattern({ cmd: 'auth_doctor_list' })
//     async doctorList(id: any): Promise<any> {
//         const doctor = await this.doctorService.findDoctor(id);
//         var accountId = doctor.accountId;
//         const list = await this.doctorService.doctorList(accountId);
//         return list;
//     }

//     @MessagePattern({ cmd: 'auth_doctor_view' })
//     async doctorView(doctorDto: any): Promise<any> {
//         const { email, password } = doctorDto;
//         const doctor = await this.doctorService.doctorLogin(email,password);
//         return doctor;
//     }




// }
