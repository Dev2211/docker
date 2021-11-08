import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class DoctorConfigPreConsultation extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'doctor_config_id'
    })
    doctorConfigId : number;

    @Column({
        name : 'doctor_key'
    })
    doctorKey : string;

    @Column({
        name : 'consultation_cost'
    })
    consultationCost : string;

    @Column({
        name : 'is_preconsultation_allowed'
    })
    isPreconsultationAllowed : boolean;

    @Column({
        name : 'preconsultation_hours'
    })
    preconsultationHours : number;

    @Column({
        name : 'preconsultation_minutes'
    })
    preconsultationMinutes : number;

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