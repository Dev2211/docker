import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';
import { Exclude } from 'class-transformer';

@Entity()
export class PaymentDetails extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'id'
    })
    id : number;

    @Column({
        name : 'appointment_id'
    })
    appointmentId : number;

    @Column({
        name : 'order_id'
    })
    orderId : string;

    @Column({
        name : 'receipt_id'
    })
    receiptId : string;

    @Column({
        name : 'amount'
    })
    amount : string;

    @Column({
        name : 'payment_status'
    })
    paymentStatus : string;

}