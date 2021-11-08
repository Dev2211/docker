import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity({name : "openvidu_session"})
export class OpenViduSession extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'openvidu_session_id'
    })
    openviduSessionId : number;

    @Column({
        name : 'doctor_key'
    })
    doctorKey : string;

    @Column({
        name : 'session_name'
    })
    sessionName : string;

    @Column({
        name : 'session_id'
    })
    sessionId : string;

    @Column({
        name : 'appointment_id'
    })
    appointmentId : number;

}