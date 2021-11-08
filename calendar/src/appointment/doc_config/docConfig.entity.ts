import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class docConfig extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'id'
    })
    id : number;

    @Column({
        name : 'doctor_key'
    })
    doctorKey : string;

    @Column({
        name : 'consultation_cost'
    })
    consultationCost : string;

    @Column({
        name : 'is_pre_consultation_allowed'
    })
    isPreconsultationAllowed : boolean;

    @Column({
        name : 'pre-consultation-hours'
    })
    preconsultationHours : number;

    @Column({
        name : 'pre-consultation-mins'
    })
    preconsultationMins : number;

    @Column({
        name : 'is_patient_cancellation_allowed'
    })
    isPatientCancellationAllowed : boolean;


    @Column({
        name : 'cancellation_days'
    })
    cancellationDays : string;

    @Column({
        name : 'cancellation_hours'
    })
    cancellationHours : string;

    @Column({
        name : 'cancellation_mins'
    })
    cancellationMins : string;

    @Column({
        name : 'is_patient_reschedule_allowed'
    })
    isPatientRescheduleAllowed : boolean;

    @Column({
        name : 'reschedule_days'
    })
    rescheduleDays : string;


    @Column({
        name : 'reschedule_hours'
    })
    rescheduleHours : string;

    @Column({
        name : 'reschedule_mins'
    })
    rescheduleMins : string;


    @Column({
        name : 'auto_cancel_days'
    })
    autoCancelDays : string;

    @Column({
        name : 'auto_cancel_hours'
    })
    autoCancelHours : string;

    @Column({
        name : 'auto_cancel_mins'
    })
    autoCancelMins : string;
    

    @Column({
        name : 'isActive'
    })
    isActive : boolean;

    @Column({
        name : 'created_on'
    })
    createdOn : Date;

    @Column({
        name : 'modified_on'
    })
    modifiedOn : Date;

    @Column({
        name : 'consultationSessionTimings'
    })
    consultationSessionTimings : number;

    @Column({
        name : 'overBookingType'
    })
    overBookingType : string;

    @Column({
        name : 'overBookingCount'
    })
    overBookingCount : number;

    @Column({
        name : 'overBookingEnabled'
    })
    overBookingEnabled : boolean;

}