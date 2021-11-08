import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class Prescription extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'id'
    })
    id : number;

    @Column({
        name : 'appointment_id'
    })
    appointmentId : number;

    @Column({
        name : 'appointment_date'
    })
    appointmentDate : Date;

    @Column({
        name : 'hospital_logo'
    })
    hospitalLogo : string;

    @Column({
        name : 'hospital_name'
    })
    hospitalName : string;

    @Column({
        name : 'doctor_name'
    })
    doctorName : string;

    @Column({
        name : 'doctor_signature'
    })
    doctorSignature : string;

    @Column({
        name : 'patient_name'
    })
    patientName : string;

    @Column({
        name : 'prescription_url'
    })
    prescriptionUrl : string;
    
    @Column({
        name : 'remarks'
    })
    remarks : string;

    @Column({
        name : 'diagnosis'
    })
    diagnosis : string;
    
    @Column({
        name : 'hospitalAddress'
    })
    hospitalAddress : string; 
}