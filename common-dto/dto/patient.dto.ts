import { IsNumber, IsOptional } from "class-validator";

export class PatientDto {
    @IsOptional()
    @IsNumber()
    id: number;
    honorific: string;
    name: string;
    landmark: string;
    country: string;
    registrationNumber: string;
    address: string;
    state: string;
    @IsOptional()
    pincode: string;
    city:string;
    @IsOptional()
    email: string;
    photo: string;
    @IsOptional ()
    phone: string;
    @IsOptional ()
    @IsNumber()
    patientId: number;
    password: string;
    firstName: string;
    lastName: string;
    dateOfBirth: string;
    alternateContact: string;
    age: number;
    paymentOption:string;
    consultationMode:string;
    preconsultation:string;
    appointmentDate:Date;
    startTime:string;
    endTime:string;
    createdBy:string;
    salt:string;
    paginationNumber:number;
    doctorKey:string;
    confirmPassword: string;
    passcode:string;
    oldPassword:string;
    newPassword:string;
    confirmNewPassword:string;
    gender:string;
    timeZone: string;
    token: string;
    accountKey:string;
    attenderEmail: string;
}
