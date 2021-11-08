import {IsEmail,IsNumber,IsPhoneNumber,IsOptional, IsIn, IsMilitaryTime } from 'class-validator';
export class WorkScheduleDto {
    @IsOptional()
    @IsNumber()
    workScheduleId: number;
    @IsOptional()
    @IsNumber()
    doctorId: number;
    date: Date;
    @IsOptional()
    @IsMilitaryTime()
    startTime:string;
    endTime:string;
    doctorKey:string;
    @IsOptional()
    @IsIn(['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'])
    dayOfWeek:string;
  }