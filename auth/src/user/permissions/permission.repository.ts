import { Repository, EntityRepository } from "typeorm";
import {Logger } from "@nestjs/common";
import {Permissions} from "./permission.entity";

@EntityRepository(Permissions)
export class PermissionRepository extends Repository<Permissions> {

    private logger = new Logger('RolesRepository');



}