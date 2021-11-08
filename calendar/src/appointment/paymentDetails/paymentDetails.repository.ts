import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {PaymentDetails} from "./paymentDetails.entity";


@EntityRepository(PaymentDetails)
export class PaymentDetailsRepository extends Repository<PaymentDetails> {

    private logger = new Logger('PaymentDetailsRepository');
    

}