import {IsNumber,IsOptional } from 'class-validator';

export class HospitalDto {
    @IsOptional ()
    @IsNumber()
    id: number;
    accountKey: string;
    hospitalName: string;
    street1: string;
    city: string;
    state: string;
    pincode: string;
    cityState: string;
    @IsOptional ()
    supportEmail: string;
    hospitalPhoto: string;
    @IsOptional ()
    phone: string;
}