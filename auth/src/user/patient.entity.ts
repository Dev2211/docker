import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique, Timestamp } from 'typeorm';
import * as bcrypt from "bcrypt";

@Entity()
@Unique(['phone'])
export class Patient extends BaseEntity{

    @PrimaryGeneratedColumn()
    patient_id : number;

    @Column()
    phone : string;

    @Column()
    password : string;

    @Column()
    salt : string;

    @Column()
    createdBy : string;
    
    @Column()
    passcode: string;

    @Column()
    time_zone: string;

    async validatePassword(password : string) : Promise<boolean> {
        const newPassword = await bcrypt.hash(password, this.salt);
        return newPassword === this.password;
    }


}