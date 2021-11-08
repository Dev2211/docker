import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique, Timestamp } from 'typeorm';

@Entity()
export class Roles extends BaseEntity{

    @PrimaryGeneratedColumn()
    roles_id : number;

    @Column()
    roles : string;

}