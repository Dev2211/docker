import { createParamDecorator } from "@nestjs/common";
import { AppointmentDto } from 'common-dto';

export const GetAppointment = createParamDecorator((data, req) : AppointmentDto => {
    return req.args[0].appointment;
})