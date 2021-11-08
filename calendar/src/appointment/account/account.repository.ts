import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { AccountDetails } from "./account_details.entity";


@EntityRepository(AccountDetails)
export class AccountDetailsRepository extends Repository<AccountDetails> {

    private logger = new Logger('AccountDetailsRepository');
    async accountdetailsInsertion(accountDto: any): Promise<any> {

        const { accountKey, hospitalName, state, pincode, phone, supportEmail,cityState } = accountDto;

        const account = new AccountDetails();
        account.accountKey = accountDto.accountKey;
        account.hospitalName =accountDto.hospitalName ;
        account.street1 = accountDto.street1 ? accountDto.street1 : null;
       account.city = accountDto.city ? accountDto.city :null ;
        account.city = accountDto.city ? accountDto.city :null ;
        account.state = accountDto.state? accountDto.state:null;
        account.pincode= accountDto.pincode;
        account.phone= accountDto.phone;
        account.supportEmail = accountDto.supportEmail ? accountDto.supportEmail : null;
        account.hospitalPhoto = accountDto.hospitalPhoto ? accountDto.hospitalPhoto : null;
        account.country = accountDto.country ? accountDto.country : null;
        account.landmark = accountDto.landmark ? accountDto.landmark : null;            
        account.cityState = accountDto.cityState? accountDto.cityState: null;          
        try {
            const acc =  await account.save();        
            return {
                appointmentdetails:acc,
            };         
        } catch (error) {
            this.logger.error(`Unexpected AccountDetails save error` + error.message);
            throw new InternalServerErrorException();
        }
    }

}