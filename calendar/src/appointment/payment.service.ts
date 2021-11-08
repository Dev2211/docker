import { Injectable, HttpStatus } from '@nestjs/common';
import { CONSTANT_MSG } from 'common-dto'
import {AppointmentRepository} from './appointment.repository';
import  * as RazorPay from 'razorpay';
import {PaymentDetailsRepository} from "./paymentDetails/paymentDetails.repository";
import { PaymentDetails } from "./paymentDetails/paymentDetails.entity";
import { json } from 'express';
import Axios from 'axios'
const shortid = require('shortid');
const crypto = require('crypto');
var instance = new RazorPay({
    key_id:'rzp_test_yaoAQ9nmvuUZx4',
    key_secret:'tttY7AYPndi9cCEj549QkovH'
})


@Injectable()
export class PaymentService {

    constructor(private appointmentRepository:AppointmentRepository,private paymentDetailsRepository: PaymentDetailsRepository){
    }
 
    async paymentOrder(req): Promise<any> {
        const options = {
            amount:req.amount*100,
            currency:'INR',
            receipt:shortid.generate(),
            payment_capture:1
        }
       const response = await instance.orders.create(options);
       let res:any = response.amount/100;
       if(response){
            const pay = new PaymentDetails();
            pay.amount = res;
            pay.orderId = response.id;
            pay.receiptId = response.receipt;
            pay.paymentStatus = CONSTANT_MSG.PAYMENT_STATUS.NOT_PAID
            const payment = await pay.save();
       }
       console.log(response);
       response.amount = res;
       response.amount_due = res;
       return response;
    }

    async paymentReciptDetails(pymntId: String) : Promise<any> {
        //username & password for basic auth of razorpay
        const username = 'rzp_test_yaoAQ9nmvuUZx4'
        const password = 'tttY7AYPndi9cCEj549QkovH'

        try {
            return await Axios.get(`https://api.razorpay.com/v1/payments/${pymntId}`, {
                auth: { username, password }
            })
        }
        catch (e) {
            console.log(e)
            return null
        }
 
    }

    async paymentVerification(req): Promise<any> {
        const secret = 'tttY7AYPndi9cCEj549QkovH';
        console.log(req);
        let data = req.razorpay_order_id+"|"+req.razorpay_payment_id;
        const digest = crypto.createHmac('SHA256', secret).update(data).digest('hex');
        console.log(digest,req.razorpay_signature)
        if(digest === req.razorpay_signature){
            try{
                const pay = await this.paymentDetailsRepository.findOne( { where : {orderId : req.razorpay_order_id}});
                pay.paymentStatus = CONSTANT_MSG.PAYMENT_STATUS.FULLY_PAID;
                const payment = await this.paymentDetailsRepository.save(pay);
                console.log(payment);
                return{
                    statusCode:HttpStatus.OK,
                    paymentId:payment.id,
                    message:CONSTANT_MSG.SIGNATURE_VERIFIED
                } 
            }catch(e){
                console.log(e);
                return{
                    statusCode:HttpStatus.BAD_REQUEST,
                    message:CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
        }else{
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:CONSTANT_MSG.SIGNATURE_NOT_MATCHED
            }
        }
    }

    async createPaymentLink(req): Promise<any> {
       const response = await instance.invoices.create(req);
       console.log(response);
       return response;
    }


}