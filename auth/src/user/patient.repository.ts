import { Repository, EntityRepository } from "typeorm";
import { Users } from "./users.entity";
import { Account } from "./account.entity";
import { UserDto,PatientDto,CONSTANT_MSG, Sms } from "common-dto";
import * as bcrypt from "bcrypt";
import { ConflictException, InternalServerErrorException, Logger,HttpStatus } from "@nestjs/common";
import { Patient } from "./patient.entity";
import * as config from 'config';
const textLocal = config.get('textLocal');

@EntityRepository(Patient)
export class PatientRepository extends Repository<Patient> {

    private logger = new Logger('PatientRepository');

    async patientRegistration(patientDto: PatientDto): Promise<any> {

        const { name, phone, password} = patientDto;

        const patient = new Patient();
        const salt = await bcrypt.genSalt();
        if(password){
            patient.password = await this.hashPassword(password, salt);
            patient.salt = salt
        }        
        patient.phone = phone;
        patient.createdBy = patientDto.createdBy;
        if(patientDto.timeZone) {
            patient.time_zone = patientDto.timeZone;
        }

        try {
            const response = await patient.save();
            console.log(response);
            //send OTP 
            const pass = await this.random(4);
            if(response && response.patient_id){
                response.passcode = pass;

                let where = {
                    patient_id: response.patient_id
                };
                const updatePasscode = await this.update(where, {passcode: pass});
                console.log(updatePasscode);
                let sms = new Sms();
                let param: any = {
                    apiKey: textLocal.APIKey,
                    message: 'OTP for verification ' + pass,
                    sender: 'TXTLCL',
                    number: phone
                };
                // const sendOtp = await sms.sendSms(param);
                // console.log(sendOtp);
            }
            
            return response;
        } catch (error) {
            if (error.code === "23505") {
                this.logger.warn(`Phone number already exists, Phone number is ${phone}`);
                throw new ConflictException("Phone number already exists");
            } else {
                this.logger.error(`Unexpected Sign up process save error` + error);
                throw new InternalServerErrorException();
            }
        }


    }

    private async hashPassword(password: string, salt : string): Promise<string> {
        return bcrypt.hash(password, salt);
    }

    private async random(len: number){
        const result = Math.floor(Math.random() * Math.pow(10, len));
        return (result.toString().length < len) ? this.random(len) : result;
    }

    async validatePhoneAndPassword(phone,password) : Promise<any> {
        const patient = await this.findOne({phone : phone});
        if(!patient){
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_PHONE
            }
        }
        if(patient && await patient.validatePassword(password)){
            return patient;
        }else {
            console.log("===",JSON.stringify(patient))
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_PASSWORD
            }
           // return null;
        }

    }

    async getPatientByPatientId(patient: any)  : Promise<any> {
        return await this.findOne({patient_id: patient.patientId});
    }


}