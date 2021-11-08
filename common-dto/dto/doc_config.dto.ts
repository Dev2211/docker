import {IsEmail,IsNumber,IsPhoneNumber,IsOptional, Min, Max, IsInt } from 'class-validator';

export class DocConfigDto {
    @IsNumber()
    @IsOptional()
    id : number;
    doctorKey: string;
    @IsOptional()
    @IsNumber()
    @Min(0)
    @Max(9999)
    consultationCost: string;
    isPreconsultationAllowed: boolean;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(23)
    preconsultationHours: number;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(59)
    preconsultationMins : number;
    isPatientCancellationAllowed : boolean;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(31)
    cancellationDays : number;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(23)
    cancellationHours : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(59)
    cancellationMins : string;
    isPatientRescheduleAllowed : boolean;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(31)
    rescheduleDays : number;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(23)
    rescheduleHours : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(59)
    rescheduleMins : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(31)
    autoCancelDays : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(23)
    autoCancelHours : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(59)
    autoCancelMins : string;
    isActive: boolean;
    createdOn: Date;
    modifiedOn: Date;
    @IsNumber()
    @IsOptional()
    @Min(10)
    @Max(60)
    consultationSessionTimings:number;
    timeZone: string;
}
