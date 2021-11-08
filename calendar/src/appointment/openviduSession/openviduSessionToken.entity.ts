import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity({name : "openvidu_session_token"})
export class OpenViduSessionToken extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'openvidu_session_token_id'
    })
    openviduSessionTokenId : number;

    @Column({
        name : 'openvidu_session_id'
    })
    openviduSessionId : number;

    @Column({
        name : 'token'
    })
    token : string;

    @Column({
        name : 'patient_id'
    })
    patientId : number;

    @Column({
        name : 'doctor_id'
    })
    doctorId : number;

}