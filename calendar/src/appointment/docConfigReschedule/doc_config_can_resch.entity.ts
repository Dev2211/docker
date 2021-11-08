import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class DoctorConfigCanResch extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'doc_config_can_resch_id'
    })
    docConfigCanReschId : number;

    @Column({
        name : 'doc_key'
    })
    doctorKey : string;

    @Column({
        name : 'is_patient_cancellation_allowed'
    })
    isPatientCancellationAllowed : boolean;

    @Column({
        name : 'cancellation_days'
    })
    cancellationDays : number;


    @Column({
        name : 'cancellation_hours'
    })
    cancellationHours : number;

    @Column({
        name : 'cancellation_mins'
    })
    cancellationMinutes : number;

    
    @Column({
        name : 'is_patient_resch_allowed'
    })
    isPatientReschAllowed : boolean;

    @Column({
        name : 'reschedule_days'
    })
    rescheduleDays : number;


    @Column({
        name : 'reschedule_hours'
    })
    rescheduleHours : number;

    @Column({
        name : 'reschedule_mins'
    })
    rescheduleMinutes : number;


    @Column({
        name : 'auto_cancel_days'
    })
    autoCancelDays : number;

    @Column({
        name : 'auto_cancel_hours'
    })
    autoCancelHours : number;

    @Column({
        name : 'auto_cancel_mins'
    })
    autoCancelMinutes : number;

    @Column({
        name : 'is_active'
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

}