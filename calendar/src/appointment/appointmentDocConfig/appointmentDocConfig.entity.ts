import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class AppointmentDocConfig extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'appointment_doc_config_id'
    })
    appointmentDocConfigId : number;

    @Column({
        name : 'appointment_id'
    })
    appointmentId : number;

    @Column({
        name : 'consultation_cost'
    })
    consultationCost : string;

    @Column({
        name : 'is_preconsultation_allowed'
    })
    isPatientPreconsultationAllowed : boolean;

    @Column({
        name : 'pre_consultation_hours'
    })
    preconsultationHours : number;

    @Column({
        name : 'pre_consultation_mins'
    })
    preconsultationMinutes : number;

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
        name : 'is_patient_reschedule_allowed'
    })
    isPatientRescheduleAllowed : boolean;

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

}