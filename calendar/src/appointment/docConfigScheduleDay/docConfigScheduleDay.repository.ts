import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {DocConfigScheduleDay} from "./docConfigScheduleDay.entity";
//import { DocConfigScheduleInterval } from "./docConfigScheduleInterval/docConfigScheduleInterval.entity";


@EntityRepository(DocConfigScheduleDay)
export class DocConfigScheduleDayRepository extends Repository<DocConfigScheduleDay> {

    private logger = new Logger('DocConfigScheduleDayRepository');
   

}