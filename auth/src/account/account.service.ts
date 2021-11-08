// import { Injectable } from '@nestjs/common';
// import { AccountRepository } from './account.repository';
// import { InjectRepository } from '@nestjs/typeorm';
// import { AppointmentDto, UserDto, AccountDto} from 'common-dto';
// //import { AccountRepository } from './account.repository';
// //import { Appointment } from './appointment.entity';
// import { Account } from './account.entity';

// @Injectable()
// export class AccountService {

//     constructor(
//         @InjectRepository(AccountRepository) private accountRepository: AccountRepository
//     ) {
//     }

//     async findById(id) : Promise<Account> {
//         const account = await this.accountRepository.findOne({accountId : id});
//         if(account){
//             return account;
//         }
//         // else{
//         //     return 'No hospital found';
//         // }
       
//         }
    

//     }


