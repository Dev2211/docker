import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class PatientReport extends BaseEntity{
   
    @PrimaryGeneratedColumn({
        name : 'id'
    })
    id : number;

    @Column({
        name : 'patient_id'
    })
     patientId : number;

     @Column({
        name : 'appointment_id'
    })
     appointmentId : number;

     @Column({
        name : 'file_name'
    })
     fileName : string;

     @Column({
        name : 'file_type'
    })
     fileType : string;

     @Column({
        name : 'report_url'
    })
     reportURL : string;


     @Column({
        name : 'report_date'
    })
     reportDate : Date;

     @Column({
        name : 'comments'
    })
     comments : string;

     @Column({
        name : 'active'
    })
    active : boolean;


}