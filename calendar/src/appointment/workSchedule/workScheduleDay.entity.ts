import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class WorkScheduleDay extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'id'
    })
    id : number;

    @Column({
        name : 'doctor_id'
    })
    doctorId : number;

    @Column({
        name : 'date'
    })
    date : Date;

    @Column({
        name : 'is_active'
    })
    isActive : boolean;

    @Column({
        name : 'doctor_key'
    })
    doctorKey : string;

}