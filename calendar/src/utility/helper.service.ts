import { HttpStatus } from "@nestjs/common";
import { CONSTANT_MSG, Email, queries } from "common-dto";
import { AppointmentRepository } from "src/appointment/appointment.repository";

export class HelperService {

    constructor(private appointmentRepository: AppointmentRepository) {}

    async sendConfirmationMailOrSMS(data: any): Promise<any> {
        const {email, messageType, commType} = data;

        if(messageType && commType && email) {

            let params: any = {
                recipient: email,
                subject: '',
                template: ''
            };
            let templateBody: any = '';
            let isTemplate: boolean = false;

            const template = await this.appointmentRepository.query(queries.getMessageTemplate, [messageType, commType]);
            if(template && template.length){
                isTemplate = true;
                params.subject = template[0].subject;
                templateBody = template[0].body;

                if(messageType === CONSTANT_MSG.MAIL.PATIENT_REGISTRATION){
                    templateBody = templateBody.replace('{full_name}', data.name);
                } else if(messageType === CONSTANT_MSG.MAIL.REGISTRATION_FOR_DOCTOR){
                    templateBody = templateBody.replace('{full_name}', data.name);
                }

                params.template = templateBody;
            }


            if(isTemplate){
                try{
                    let email = new Email();
                    const sendMail = await email.sendEmail(params);
                    console.log("mail response", sendMail);
                    return {
                        statusCode: HttpStatus.OK,
                        message: CONSTANT_MSG.MAIL_OK
                    }
                } catch(err){
                    console.log('send mail error ==> ', err)
                    return {
                        statusCode: HttpStatus.NO_CONTENT,
                        message: CONSTANT_MSG.DB_ERROR
                    }
                }
            } else {
                return {
                    statusCode: HttpStatus,
                    message: 'Template is Not Found'
                }
            }
        } else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
       
    }

    async sendConfirmationSMS(data: any): Promise<any> {

    }

}