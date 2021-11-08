import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique, Timestamp } from 'typeorm';

@Entity()
export class RolePermissions extends BaseEntity{

    @PrimaryGeneratedColumn()
    id : number;

    @Column()
    roleId : number;

    @Column()
    permissionId : number;

}