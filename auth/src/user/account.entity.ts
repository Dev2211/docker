import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique, Timestamp } from 'typeorm';

@Entity()
export class Account extends BaseEntity{

    @PrimaryGeneratedColumn()
    account_id : number;

    @Column()
    no_of_users : number;

    @Column()
    sub_start_date : Date;

    @Column()
    sub_end_date : Date;

    @Column()
    account_key : string;

    @Column()
    account_name : string;

    @Column()
    updated_time : Date;

    @Column()
    updated_user : number;

    @Column()
    is_active : boolean;


}