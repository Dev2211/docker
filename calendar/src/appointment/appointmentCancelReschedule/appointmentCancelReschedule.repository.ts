import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {AppointmentCancelReschedule} from "./appointmentCancelReschedule.entity";


@EntityRepository(AppointmentCancelReschedule)
export class AppointmentCancelRescheduleRepository extends Repository<AppointmentCancelReschedule> {

    private logger = new Logger('AppointmentCancelRescheduleRepository');
    

}