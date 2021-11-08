
import { PassportStrategy } from '@nestjs/passport';
import { Strategy, ExtractJwt} from 'passport-jwt';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtPayLoad } from './jwt-payload.interface';
import { JwtPatientLoad } from './jwt-patientload.interface';
import { UserService } from 'src/service/user.service';
import { UserDto,DoctorDto,AppointmentDto,AccountDto,PatientDto,CONSTANT_MSG } from 'common-dto';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {

    constructor(private readonly userService : UserService){
        super({
            jwtFromRequest : ExtractJwt.fromAuthHeaderAsBearerToken(),
            secretOrKey: 'topSecret51'
        })
    }



    // async validate(payload : any) : Promise<UserDto>{
    //     console.log("JWT Payload >> "+ JSON.stringify(payload));
    //     const user : UserDto = await this.userService.findUserByEmail(payload.email).toPromise();
    //     if(!user){
    //         throw new UnauthorizedException("Malformed User");
    //     }
    //     return payload;
    // }

    async validate(payload : any) : Promise<any>{
        if(payload.permission == "CUSTOMER"){
            const patient : PatientDto = await this.userService.findUserByPhone(payload.phone).toPromise();
            if(!patient){
                throw new UnauthorizedException("Malformed User");
            }
        }else{
            const user : any = await this.userService.findUserByEmail(payload.email).toPromise();
            if(!user){
                throw new UnauthorizedException("Malformed User");
            }
        }
        return payload;
    }







    // async validate(patientload : JwtPatientLoad) : Promise<PatientDto>{
    //     console.log("JWT Patientload >> "+ JSON.stringify(patientload));
    //     const patient : PatientDto = await this.userService.findUserByPhone(patientload.phone).toPromise();
    //     if(!patient){
    //         throw new UnauthorizedException("Malformed User");
    //     }
    //     console.log(patient);
    //     return patient;
    // }

       
    // async validate(payload : any) : Promise<UserDto>{
    // console.log("JWT Payload >> "+ JSON.stringify(payload));
    // if(payload.email){
    // const user : UserDto = await this.userService.findUserByEmail(payload.email).toPromise();
    // if(!user){
    // throw new UnauthorizedException("Malformed User");
    // }
    // }else if(!payload.phone){
    // const patient : PatientDto = await this.userService.findPatientByPhone(payload.phone).toPromise();
    // if(!patient){
    // throw new UnauthorizedException("Malformed User");
    // }
    // } else {
    // throw new UnauthorizedException("Malformed User");
    // }
    // return payload;

}