import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {DocConfigScheduleInterval} from "./docConfigScheduleInterval.entity";


@EntityRepository(DocConfigScheduleInterval)
export class DocConfigScheduleIntervalRepository extends Repository<DocConfigScheduleInterval> {

    private logger = new Logger('DocConfigScheduleIntervalRepository');
   

}