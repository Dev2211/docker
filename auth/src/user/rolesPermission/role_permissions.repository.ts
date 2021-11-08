import { Repository, EntityRepository } from "typeorm";
import {Logger } from "@nestjs/common";
import {RolePermissions} from "./role_permissions.entity";

@EntityRepository(RolePermissions)
export class RolePermissionRepository extends Repository<RolePermissions> {

    private logger = new Logger('RolesRepository');



}