import {
  PrimaryGeneratedColumn,
  Column,
  Entity,
  BaseEntity,
  Unique,
} from 'typeorm';
import { Exclude } from 'class-transformer';

@Entity()
export class Doctor extends BaseEntity {
  @PrimaryGeneratedColumn({
    name: 'doctorId',
  })
  doctorId: number;

  @Column({
    name: 'doctor_name',
  })
  doctorName: string;

  //  @Exclude()
  @Column({
    name: 'account_key',
  })
  accountKey: string;

  @Column({
    name: 'doctor_key',
  })
  doctorKey: string;

  @Column({
    name: 'experience',
  })
  experience: number;

  @Column({
    name: 'speciality',
  })
  speciality: string;

  @Column({
    name: 'qualification',
  })
  qualification: string;

  @Column({
    name: 'photo',
  })
  photo: string;

  @Column({
    name: 'number',
  })
  number: string;

  @Column({
    name: 'signature',
  })
  signature: string;

  @Column({
    name: 'first_name',
  })
  firstName: string;

  @Column({
    name: 'last_name',
  })
  lastName: string;

  @Column({
    name: 'registration_number',
  })
  registrationNumber: string;

  @Column({
    name: 'email',
  })
  email: string;

  @Column({
    name: 'live_status',
  })
  liveStatus: string;

  @Column({
    name: 'last_active',
  })
  lastActive: Date;

  @Column({
    name: 'registration_id_proof',
  })
  registrationIdProof: string;

  @Column({
    name : 'report_remainder_id'
  })
  reportRemainderId : number;

  @Column({
    name: 'is_token_expired',
  })
  is_token_expired: boolean;

  @Column({
    name: 'video_call_details',
  })
  videoCallDetails: string;
}