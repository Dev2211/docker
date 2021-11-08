import { Repository, EntityRepository } from "typeorm";
import { Logger } from "@nestjs/common";
import { Mobile_version } from "./mobile_version.entity";

@EntityRepository(Mobile_version)
export class VersionRepository extends Repository<Mobile_version> {

    private logger = new Logger('VersionRepository');


}