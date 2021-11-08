import {IsEmail,IsNumber,IsPhoneNumber,IsOptional,IsMilitaryTime,IsDate } from 'class-validator';

export class AppointmentDto {
  @IsOptional()
  @IsNumber()
  id : number;
  @IsOptional()
  @IsNumber()
  doctorId : number;
  @IsOptional()
  @IsNumber()
  patientId : number;
  @IsOptional()
  appointmentDate : Date;
  @IsOptional()
  @IsMilitaryTime()
  startTime : string;
  @IsOptional()
  @IsNumber()
  appointmentId:number;
  endTime : string;   
  paymentStatus : boolean;
  isActive : boolean; 
  isCancel : boolean;
  createdBy : string;
  createdId : number;
  cancelledBy : string;
  cancelledId : number;
  paymentOption:string;
  consultationMode:string;
  confirmation:boolean;
  hasConsultation: boolean;
  attenderEmail: string;
  attenderMobile: string;
  attenderName: string;
}
export class AppointmentsDto {
  id : string;
  appointmentId:number;
  insertid:string;
  deleteid:string;
}