import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';
import { Timestamp } from 'rxjs';

@Entity()
export class Appointment extends BaseEntity{

    @PrimaryGeneratedColumn()
    id : number;

    @Column({
        name : 'doctorId'
    })
    doctorId : number;

    @Column({
        name : 'patient_id'
    })
    patientId : number;

    @Column({
        name : 'appointment_date'
    })
    appointmentDate : Date;

    @Column({
        name : 'startTime'
    })
    startTime : string;

    @Column({
        name : 'endTime'
    })
    endTime : string;

    @Column({
        name : 'payment_status'
    })
    paymentStatus : boolean;

    @Column({
        name : 'is_active'
    })
    isActive : boolean;

    @Column({
        name : 'is_cancel'
    })
    isCancel : boolean;

    @Column({
        name : 'created_by'
    })
    createdBy : string;

    @Column({
        name : 'created_id'
    })
    createdId : number; 
    
    @Column({
        name : 'cancelled_by'
    })
    cancelledBy : string;

    @Column({
        name : 'cancelled_id'
    })
    cancelledId : number;  

    @Column({
        name : 'slotTiming'
    })
    slotTiming : number;  

    @Column({
        name : 'paymentoption'
    })
    paymentOption : string;  

    @Column({
        name : 'consultationmode'
    })
    consultationMode : string; 
    
    @Column({
        name : 'status'
    })
    status : string; 

    @Column({
        name : 'createdTime'
    })
    createdTime : Date; 

    @Column({
        name: 'hasConsultation'
    })
    hasConsultation: boolean

    @Column({
        name:'reportid'
    })
    reportid:string;
 
    @Column({
        name: 'attender_email'
    })
    attenderEmail: string;

    @Column({
        name: 'attender_name'
    })
    attenderName: string;

    @Column({
    name: 'attender_mobile'
    })
    attenderMobile: string;
}