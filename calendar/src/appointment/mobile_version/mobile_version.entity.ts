import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique, VersionColumn} from 'typeorm';
import { Exclude } from 'class-transformer';

@Entity()

export class Mobile_version extends BaseEntity{

    
    @PrimaryGeneratedColumn({
        name : 'id'
    })
    id : number;

    @Column({
        name : 'android_version'
    })
    android_version : number;

    @Column({
        name : 'ios_version'
    })
    ios_version : number;

}