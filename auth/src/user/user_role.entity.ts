import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique, Timestamp } from 'typeorm';

@Entity()
export class UserRole extends BaseEntity{

    @PrimaryGeneratedColumn()
    id : number;

    @Column()
    user_id : number;

    @Column()
    role_id : number;

}