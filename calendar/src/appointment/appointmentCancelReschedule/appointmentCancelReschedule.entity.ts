import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class AppointmentCancelReschedule extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'appointment_cancel_reschedule_id'
    })
    appointmentCancelRescheduleId : number;

    @Column({
        name : 'cancel_on'
    })
    cancelOn : number;

    @Column({
        name : 'cancel_by'
    })
    cancelBy : string;

    @Column({
        name : 'cancel_payment_status'
    })
    cancelPaymentStatus : boolean;

    @Column({
        name : 'cancel_by_id'
    })
    cancelById : number;

    @Column({
        name : 'reschedule'
    })
    reschedule : boolean;

    @Column({
        name : 'reschedule_appointment_id'
    })
    rescheduleAppointmentId : number;

    @Column({
        name : 'appointment_id'
    })
    appointmentId : number;

}