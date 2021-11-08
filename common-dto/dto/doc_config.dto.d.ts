export declare class DocConfigDto {
    id: number;
    doctorKey: string;
    consultationCost: string;
    isPreconsultationAllowed: boolean;
    preconsultationHours: number;
    preconsultationMins: number;
    isPatientCancellationAllowed: boolean;
    cancellationDays: string;
    cancellationHours: string;
    cancellationMins: string;
    isPatientRescheduleAllowed: boolean;
    rescheduleDays: string;
    rescheduleHours: string;
    rescheduleMins: string;
    autoCancelDays: string;
    autoCancelHours: string;
    autoCancelMins: string;
    isActive: boolean;
    createdOn: Date;
    modifiedOn: Date;
    timeZone: string;
}
