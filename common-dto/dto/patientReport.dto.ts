import {IsEmail,IsNumber,IsPhoneNumber,IsOptional, IsIn, IsMilitaryTime } from 'class-validator';
export class  patientReportDto {
    @IsNumber()
    id: number;
    @IsNumber()
    patientId : number;
    @IsOptional()
    @IsNumber()
    appointmentId : number;
    fileName : string;
    fileType : string;
    reportURL : string;
    reportDate : Date;
    comments : string;
}
export class  ReportdeleteDto {
    @IsNumber()
    id: number;
}

