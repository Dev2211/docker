import { createParamDecorator } from "@nestjs/common";
import { DoctorDto } from 'common-dto';

export const GetDoctor = createParamDecorator((data, req) : DoctorDto => {
    return req.args[0].doctor;
})