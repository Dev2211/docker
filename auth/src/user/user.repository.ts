import { Repository, EntityRepository } from "typeorm";
import { Users } from "./users.entity";
import { UserRole } from "./user_role.entity";
import { UserDto,DoctorDto ,PatientDto,CONSTANT_MSG,queries } from "common-dto";
import * as bcrypt from "bcrypt";
import { ConflictException, InternalServerErrorException, Logger ,HttpStatus} from "@nestjs/common";

@EntityRepository(Users)
export class UserRepository extends Repository<Users> {

    private logger = new Logger('UserRepository');

    async signUP(userDto: UserDto): Promise<any> {

        const { name, email, password} = userDto;

        const user = new Users();
        const salt = await bcrypt.genSalt();
        user.name = name;
        user.password = await this.hashPassword(password, salt);
        user.salt = salt
        user.email = email;
        // user.role = role;

        try {
            return await user.save();
        } catch (error) {
            if (error.code === "23505") {
                this.logger.warn(`Email already exists, Email is ${email}`);
                throw new ConflictException("Email already exists");
            } else {
                this.logger.error(`Unexpected Sign up process save error` + error);
                throw new InternalServerErrorException();
            }
        }

    }

    async doctorRegistration(doctorDto: DoctorDto): Promise<any> {
        const user = new Users();
        const salt = await bcrypt.genSalt();

        const uid: any = await this.query(queries.getUser)
        let id = Number(uid[0].id) + 1;
        user.id = id;
        var password = 'docVirujh#12';

        if (doctorDto.password && doctorDto.password.trim()) {
            password = doctorDto.password.trim();
        }

        var firstName = '', lastName = '';

        if (doctorDto['firstName']) {
            firstName = doctorDto['firstName'];
        }
        if (doctorDto['lastName']) {
            lastName = doctorDto['lastName'];
        }
        user.name = firstName + " " + lastName;
        if (doctorDto.password) {
            password = doctorDto.password;
        }
        user.password = await this.hashPassword(password, salt);
        user.salt = salt
        user.email = doctorDto.email;

        if (doctorDto['isNewAccount']) {
            //creating new Account with accountDetails And then updating AdminDetails
            return {
                'message' : 'Under development'
            }
        } else {
            user.account_id = doctorDto.accountId;
        }

        // Find max doctor Key
        const maxDocKey: any = await this.query(queries.getDoctorKey)
        let docKey = 'Doc_';
        if (maxDocKey.length) {
            let m = maxDocKey[0]
            docKey = docKey + (Number(maxDocKey[0].maxdoc) + 1)
        } else {
            docKey = 'Doc_1'
        }
        user.doctor_key = docKey;

        const userRes = await this.query(queries.insertDoctor, [user.id, user.name, user.email, user.password, user.salt, user.account_id, user.doctor_key])
       
        try {
            var roleId = 2;
            const userRole = new UserRole();
            userRole.user_id = id;
            userRole.role_id = roleId;
            const userRoles = await userRole.save();
            return user;

        } catch (error) {

            if (error.code === "23505") {
                this.logger.warn(`Email already exists, Email is ${doctorDto.email}`);
                throw new ConflictException("Email already exists");
            } else {
                this.logger.error(`Unexpected Sign up process save error` + error);
                throw new InternalServerErrorException();
            }
        }

    }

    async validateEmailPassword(userDto : UserDto) : Promise<any> {
        const { email, password } = userDto;
        const user = await this.findOne({email : email});
        if(user && await user.validatePassword(password)){
            return user;
        }else {
            return null;
        }

    }

    private async hashPassword(password: string, salt : string): Promise<string> {
        return bcrypt.hash(password, salt);
    }

    async validateEmailAndPassword(email,password) : Promise<any> {
        const user = await this.findOne({email : email});
        if(user && await user.validatePassword(password)){
            if(user.is_active) {
                return user;
            } else {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.ACCOUNT_NOT_ACTIVATE
                }
            }
        }else {
            console.log("===",JSON.stringify(user))
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_CREDENTIALS
            }
            return null;
        }

    }

    async validatePhoneAndPassword(phone,password) : Promise<any> {
        console.log("======test")

        const user = await this.findOne({email : phone});
        if(user && await user.validatePassword(password)){
            return user;
        }else {
            console.log("===",JSON.stringify(user))
            return null;
        }

    }

    async getUserByUserId(user: any)  : Promise<any> {
        return await this.findOne({id: user.userId});
    }

}