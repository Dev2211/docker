import { Repository, EntityRepository } from "typeorm";
import { Users } from "./users.entity";
import { Account } from "./account.entity";
import { UserDto,queries } from "common-dto";
import * as bcrypt from "bcrypt";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { UserRole } from "./user_role.entity";
import { UserRepository } from "./user.repository";
//import { Account } from "src/account/account.entity";

@EntityRepository(Account)
export class AccountRepository extends Repository<Account> {

    private logger = new Logger('AccountRepository');
    private userRepository:UserRepository;

    async createAccount(accountDto: any): Promise<any> {
        const account = new Account();
        account.no_of_users = accountDto.no_of_users ? accountDto.no_of_users : 0;
        account.sub_start_date = accountDto.sub_start_date ? accountDto.sub_start_date : new Date();
        account.sub_end_date = accountDto.sub_end_date ? accountDto.sub_end_date : new Date();
        account.account_key = accountDto['accountKey'];
        account.account_name = accountDto['hospitalName'];
        account.updated_time =new Date();
        account.updated_user = accountDto.updated_user ? accountDto.updated_user : null;
        account.is_active = true;
       
        try {
            const accRes = await account.save();
            const user = new Users();
            var pwd = 'adminVirujh#123';
            if(accountDto.password){
                pwd = accountDto.password;
            }
            let salt = await bcrypt.genSalt();
            user.id = accountDto.id;
            user.name = accountDto.name;
            user.email = accountDto.adminEmail;
            user.salt = salt;
            user.password = await this.hashPassword(pwd, salt);
            user.account_id = accRes.account_id;
            user.is_active = true;          
            console.log(user);
            //user.updated_time = new Date();
            const users = await this.query(queries.insertDoctor, [accountDto.id, accountDto.name, accountDto.adminEmail, user.password, salt, accRes.account_id, user.doctor_key])
            //const users = await user.save();
            const userRole = new UserRole();
            var roleId = 1;
            userRole.user_id = user.id;
            userRole.role_id = roleId;
            const userRoles = await userRole.save();
            return {accountKey:accountDto.accountKey};

        } catch (error) {
            if (error.code === "23505") {
                this.logger.warn(`Email already exists, Email is ${accountDto.adminEmail}`);
                throw new ConflictException("Email already exists");
            } else {
                this.logger.error(`Unexpected Sign up process save error` + error);
                throw new InternalServerErrorException();
            }
        }

    }

    async createAccountDetail(doctorDto: any): Promise<any> {
        const account = new Account();
        account.no_of_users = doctorDto.no_of_users ? doctorDto.no_of_users : 0;
        account.sub_start_date = doctorDto.sub_start_date ? doctorDto.sub_start_date : new Date();
        account.sub_end_date = doctorDto.sub_end_date ? doctorDto.sub_end_date : new Date();
        account.account_key = doctorDto.accountKey;
        account.account_name = doctorDto.hospitalName;
        account.updated_time = new Date();
        account.updated_user = doctorDto.updated_user ? doctorDto.updated_user : null;
        account.is_active = false;
        try {
            const accRes = await account.save();
            const user = new Users();
            let pwd = 'adminVirujh#123';
            if(doctorDto.password) {
                pwd = doctorDto.password;
            }
            let salt = await bcrypt.genSalt();
            user.name = doctorDto.firstName + doctorDto.lastName;
            user.email = doctorDto.email;
            user.salt = salt;
            user.password = await this.hashPassword(pwd, salt);
            user.account_id = accRes.account_id;
            user.is_active = false;
            if (doctorDto.doctor_key) {
                user.doctor_key = doctorDto.doctor_key;
                // user.updated_time = new Date();
                // user.passcode = null;
            }
            await user.save();
            await this.updateUserRole(user.id, 1);  // Admin role update
            await this.updateUserRole(user.id, 2); // doctor role update
            return user;
        } catch (error) {
            console.log(error)
            this.logger.error(`Unexpected Sign up process save error` + error);
            throw new InternalServerErrorException();
        }
    }

    async createUserDetail(doctorDto: any): Promise<any> {
        try {
            const user = new Users();
            let pwd = 'adminVirujh#123';
            if(doctorDto.password) {
                pwd = doctorDto.password;
            }
            let salt = await bcrypt.genSalt();
            user.name = doctorDto.firstName + doctorDto.lastName;
            user.email = doctorDto.email;
            user.salt = salt;
            user.password = await this.hashPassword(pwd, salt);
            user.account_id = doctorDto.account_id;
            user.is_active = true;
            if (doctorDto.doctor_key) {
                user.doctor_key = doctorDto.doctor_key;
                // user.updated_time = new Date();
                // user.passcode = null;
            }
            await user.save();
            const userRole = new UserRole();
            var roleId = 1;
            userRole.user_id = user.id;
            userRole.role_id = roleId;
            await userRole.save();
            return user;
        } catch (error) {
            this.logger.error(`Unexpected Sign up process save error` + error);
            throw new InternalServerErrorException();
        }
    }

    private async hashPassword(password: string, salt : string): Promise<string> {
        return bcrypt.hash(password, salt);
    }

    async updateUserRole(userId, roleId): Promise<string> {
        const userRole = new UserRole();
        userRole.user_id = userId;
        userRole.role_id = roleId;
        await userRole.save();
        return userId;
    }
}