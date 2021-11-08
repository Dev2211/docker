import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class DocConfigScheduleInterval extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'id'
    })
    docConfigScheduleIntervalId : number;

    @Column({
        name : 'docConfigScheduleDayId'
    })
    docConfigScheduleDayId : number;

    @Column({
        name : 'startTime'
    })
    startTime : string;

    @Column({
        name : 'endTime'
    })
    endTime : string;


}