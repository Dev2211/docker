import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {WorkScheduleInterval} from "./workScheduleInterval.entity";


@EntityRepository(WorkScheduleInterval)
export class WorkScheduleIntervalRepository extends Repository<WorkScheduleInterval> {

    private logger = new Logger('WorkScheduleIntervalRepository');


}