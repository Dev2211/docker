import { IsNumber, IsOptional } from "class-validator";

export class AppointmentSessionDetailsDto {
    @IsOptional()
    @IsNumber()
    id : number;
    
    @IsOptional()
    @IsNumber()
    appointmentId:number;

    meetingId : string;
    passcode : string;
}