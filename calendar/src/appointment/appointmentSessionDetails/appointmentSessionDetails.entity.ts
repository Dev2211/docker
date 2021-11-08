import { BaseEntity, Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class AppointmentSessionDetails extends BaseEntity{

    @PrimaryGeneratedColumn({
        name:'id',
    })
    id : number;

    @Column({
        name:'appointment_id',
    })
    appointmentId : number;

    @Column({
        name:'meeting_id',
    })
    meetingId : string;

    @Column({
        name:'passcode'
    })
    passcode : string;
}