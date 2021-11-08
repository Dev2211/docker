import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class WorkScheduleInterval extends BaseEntity{

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
        name : 'work_schedule_day_id'
    })
    workScheduleDayId : number;

    @Column({
        name : 'is_active'
    })
    isActive : boolean;

}