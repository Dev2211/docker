import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {WorkScheduleDay} from "./workScheduleDay.entity";


@EntityRepository(WorkScheduleDay)
export class WorkScheduleDayRepository extends Repository<WorkScheduleDay> {

    private logger = new Logger('WorkScheduleDayRepository');


}