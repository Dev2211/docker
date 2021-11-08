import { InternalServerErrorException } from "@nestjs/common";
import { Logger } from "@nestjs/common";
import { EntityRepository, Repository } from "typeorm";
import { AppointmentSessionDetails } from "./appointmentSessionDetails.entity";
//import { AppointmentSessionDetailsDto} from "common-dto";

@EntityRepository(AppointmentSessionDetails)
export class AppointmentSessionDetailsRepository extends Repository<AppointmentSessionDetails>{
    private logger = new Logger('AppointmentSessionDetailsRepository');

    async createMeetingId(appointmentSessionDetailsDto: any):Promise<any> {
        const { appointmentId, meetingId, passcode } = appointmentSessionDetailsDto;

        const appointmentSessionDetails = new AppointmentSessionDetails();

        appointmentSessionDetails.appointmentId = appointmentSessionDetailsDto.appointmentId;
        appointmentSessionDetails.meetingId = appointmentSessionDetailsDto.meetingId;
        appointmentSessionDetails.passcode = appointmentSessionDetailsDto.passcode;

        try {
            const appSessionDetails =  await appointmentSessionDetails.save();  
            return {
                appointmentSessionDetails:appSessionDetails
            };         
        } catch (error) {
            throw new InternalServerErrorException();
        }
    }
}