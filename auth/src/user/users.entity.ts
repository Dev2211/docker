import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique, Timestamp } from 'typeorm';
import * as bcrypt from "bcrypt";

@Entity()
@Unique(['email'])
export class Users extends BaseEntity{

    @PrimaryGeneratedColumn()
    id : number;

    @Column()
    name : string;

    @Column()
    email : string;

    @Column()
    password : string;

    @Column()
    salt : string;

    @Column()
    account_id : number;

    @Column()
    doctor_key : string;

    @Column()
    is_active : boolean;

    @Column()
    updated_time : Date;

    @Column()
    passcode : string;

    @Column()
    time_zone : string;

    async validatePassword(password : string) : Promise<boolean> {
        const newPassword = await bcrypt.hash(password, this.salt);
        return newPassword === this.password;
    }

}