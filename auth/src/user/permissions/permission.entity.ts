import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique, Timestamp } from 'typeorm';

@Entity()
export class Permissions extends BaseEntity{

    @PrimaryGeneratedColumn()
    id : number;

    @Column()
    name : string;

    @Column()
    description : string;

}